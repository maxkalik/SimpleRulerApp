//
//  ViewController.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 1/29/21.
//

#import "HomeViewController.h"

@interface HomeViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (weak, nonatomic) IBOutlet CircleButton *resultsButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitSegmentControl;

@property (nonatomic, strong) NSMutableArray<MeasureNode*> *measureNodes;
@property (nonatomic, strong) NSMutableArray<Result*> *results;
@property (nonatomic, assign) NSInteger markerCount;

@end

@implementation HomeViewController
@synthesize results = _results;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sceneView.delegate = self;
    self.sceneView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    self.sceneView.pointOfView.camera.usesOrthographicProjection = YES;
    self.measureNodes = [[NSMutableArray alloc] init];
    
    UIGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.sceneView addGestureRecognizer:tapGestureRecognizer];
    self.markerCount = 0;
}

- (void)handleTap:(UITapGestureRecognizer*)sender {
    ARHitTestResult* hitResult = [Helper.sharedInstance getHitResultFromTapGesture:sender inSceneView:self.sceneView];
    [self addMarkerAt:hitResult];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    [self.sceneView.session runWithConfiguration:configuration];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.sceneView.session pause];
}

#pragma mark - METHODS

- (void)initiateMeasureNodeWithMarkerNode:(MarkerNode*)markerNode {
    MeasureNode *measureNode = [[MeasureNode alloc] initWithMakerNode:markerNode];
    [self.measureNodes addObject:measureNode];
    [self.sceneView.scene.rootNode addChildNode:measureNode];
}

- (void)addMarkerAt:(ARHitTestResult*)hitResult {
    MarkerNode *markerNode = [[MarkerNode alloc] initWithHitResult:hitResult];
    
    self.markerCount += 1;
    
    if (self.markerCount > 1) {
        SCNNode *measureNode = [self.measureNodes lastObject];
        [measureNode addChildNode:markerNode];
        [self calculateDistance];
        self.markerCount = 0;
    } else {
        [self initiateMeasureNodeWithMarkerNode:markerNode];
    }
}

- (void)calculateDistance {
    SCNNode *measureNode = [self.measureNodes lastObject];
    SCNNode *start = [measureNode.childNodes firstObject];
    SCNNode *end = [measureNode.childNodes lastObject];
    
    NodePositions nodePositions = [Helper.sharedInstance calculateDistanceFrom:start.position to:end.position];
    
    Result *result = [[Result alloc] initWithDistance:nodePositions.distance];
    [self.results addObject:result];
    [self updateButton];
    
    [self addTextForNodePositions:nodePositions];
    [self addLineForNodePositions:nodePositions];
}

- (void)addLineForNodePositions:(NodePositions)nodePositions {
    CylinderLineNode *cylinderLineNode = [[CylinderLineNode alloc] initWithDistance:nodePositions.distance and:nodePositions.midpoint];
    [cylinderLineNode lookAt:nodePositions.end up:self.sceneView.scene.rootNode.worldUp localFront:cylinderLineNode.worldUp];
    [[self.measureNodes lastObject] addChildNode:cylinderLineNode];
}

- (void)addTextForNodePositions:(NodePositions)nodePositions {
    UnitNode *unitNode = [[UnitNode alloc] initWithDistance:nodePositions.distance and:nodePositions.midpoint];
    [Helper.sharedInstance convertUnitInUnitNode:unitNode toSelectedMeasurementIndex:self.unitSegmentControl.selectedSegmentIndex];
    [[self.measureNodes lastObject] addChildNode:unitNode];
}

- (void)updateButton {
    self.resultsButton.enabled = self.results.count > 0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toResults"]) {
        ResultsViewController *resultsVC = (ResultsViewController *)segue.destinationViewController;
        resultsVC.results = self.results;
    }
}

#pragma mark - IBActions

- (IBAction)segmentControlChanged:(UISegmentedControl *)sender {
    [Helper.sharedInstance convertUnitsInMeasureNodes:self.sceneView.scene.rootNode.childNodes
                             toSelectedMeasurementIndex:sender.selectedSegmentIndex];
}

- (IBAction)undoButtonTapped:(UIButton *)sender {
    if (self.measureNodes.count > 0) {
        SCNNode *node = [self.measureNodes lastObject];
        [node removeFromParentNode];
        [self.results removeLastObject];
        [self.measureNodes removeLastObject];
        [self updateButton];
    }
}

@end
