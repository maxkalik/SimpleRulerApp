//
//  ViewController.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 1/29/21.
//

#import "HomeViewController.h"
#import "MeasurementNode.h"
#import "CylinderLineNode.h"
#import "MarkerNode.h"
#import "Helper.h"

@interface HomeViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, strong) NSMutableArray<MarkerNode*> *markerNodes;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sceneView.delegate = self;
    self.sceneView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    self.sceneView.pointOfView.camera.usesOrthographicProjection = YES;
    self.markerNodes = [[NSMutableArray alloc] init];
    
    UIGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.sceneView addGestureRecognizer:tapGestureRecognizer];
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

- (void)addMarkerAt:(ARHitTestResult*)hitResult {
    MarkerNode *markerNode = [[MarkerNode alloc] initWithHitResult:hitResult];
    
    [self.sceneView.scene.rootNode addChildNode:markerNode];
    [self.markerNodes addObject:markerNode];
    
    if (self.markerNodes.count % 2 == 0) {
        [self calculateDistance];
    }
}

- (void)calculateDistance {
    SCNNode *start = [self.markerNodes objectAtIndex:self.markerNodes.count - 2];
    SCNNode *end = [self.markerNodes lastObject];

    NodePositions nodePositions = [Helper.sharedInstance calculateDistanceFrom:start.position to:end.position];
    
    [self addTextForNodePositions:nodePositions];
    [self addLineForNodePositions:nodePositions];
}

- (void)addLineForNodePositions:(NodePositions)nodePositions {
    CylinderLineNode *cylinderLineNode = [[CylinderLineNode alloc] initWithDistance:nodePositions.distance and:nodePositions.midpoint];
    [cylinderLineNode lookAt:nodePositions.end up:self.sceneView.scene.rootNode.worldUp localFront:cylinderLineNode.worldUp];
    [self.sceneView.scene.rootNode addChildNode:cylinderLineNode];
}

- (void)addTextForNodePositions:(NodePositions)nodePositions {
    MeasurementNode *textNode = [[MeasurementNode alloc] initWithDistance:nodePositions.distance and:nodePositions.midpoint];
    [self.sceneView.scene.rootNode addChildNode:textNode];
}

- (IBAction)segmentControlChanged:(id)sender {
    for (SCNNode *node in self.sceneView.scene.rootNode.childNodes) {
        if ([node isKindOfClass: [MeasurementNode class]]) {
            MeasurementNode *textNode = (MeasurementNode*)node;
            [Helper.sharedInstance convertMeasurementInTextNode:textNode toSelectedMeasurementIndex:self.segmentControl.selectedSegmentIndex];
        }
    }
}

@end
