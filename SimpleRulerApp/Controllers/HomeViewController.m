//
//  ViewController.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 1/29/21.
//

#import "HomeViewController.h"
#import <Photos/Photos.h>

@interface HomeViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (weak, nonatomic)   IBOutlet UISegmentedControl *unitSegmentControl;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic, strong) NSMutableArray<MeasureNode*> *measureNodes;
@property (nonatomic, assign) NSInteger markerCount;
@property (nonatomic, assign) BOOL isCameraAuthorized;

@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScene];
    [self setupCommon];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    [self.sceneView.session runWithConfiguration:configuration];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestAccessToCamera];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.sceneView.session pause];
}

#pragma mark - METHODS

- (void)setupCommon {
    [self enableAllButtonsWithFlag:NO];
    self.markerCount = 0;
    self.isCameraAuthorized = NO;
}

- (void)setupScene {
    self.sceneView.delegate = self;
    self.sceneView.pointOfView.camera.usesOrthographicProjection = YES;
    self.measureNodes = [[NSMutableArray<MeasureNode*> alloc] init];
    UIGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.sceneView addGestureRecognizer:tapGestureRecognizer];
}

- (void)requestAccessToCamera {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (!granted) {
            [self showAlertToAuthUserSettings];
        } else {
            self.isCameraAuthorized = YES;
        }
    }];
}

- (void)enableAllButtonsWithFlag:(BOOL)flag {
    for (UIButton *button in self.buttons) {
        button.enabled = flag;
    }
}

- (void)handleTap:(UITapGestureRecognizer*)sender {
    if (!self.isCameraAuthorized) {
        [self showAlertToAuthUserSettings];
        return;
    }
    ARHitTestResult* hitResult = [Helper.sharedInstance getHitResultFromTapGesture:sender inSceneView:self.sceneView];
    [self addMarkerAt:hitResult];
}

- (void)showAlertToAuthUserSettings {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self alertWithTitle:@"Camera is not authorized"
                     message:@"To see the objects, to make snapshots the app needs permition to use the camera."
                  completion:^(UIAlertAction * _Nonnull action) {
            NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [UIApplication.sharedApplication openURL:settingURL options:@{} completionHandler:nil];
        }];
    });
}

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
    MeasureNode *measureNode = [self.measureNodes lastObject];
    SCNNode *start = [measureNode.childNodes firstObject];
    SCNNode *end = [measureNode.childNodes lastObject];
    
    NodePositions nodePositions = [Helper.sharedInstance calculateDistanceFrom:start.position to:end.position];
    [measureNode updateResult:[[Result alloc] initWithDistance:nodePositions.distance]];
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
    BOOL isMeasureNodesNotEmpty = self.measureNodes.count > 0;    
    [self enableAllButtonsWithFlag:isMeasureNodesNotEmpty];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toResults"]) {
        ResultsViewController *resultsVC = (ResultsViewController *)segue.destinationViewController;
        resultsVC.results = [Helper.sharedInstance getResultsFromMeasureNodes:self.measureNodes];
    }
}

- (void)checkLibraryAuthorization {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusDenied: {
                [self showAlertToAuthUserSettings];
                break;
            }
            default:
                break;
        }
    }];
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
        self.markerCount = 0;
        [self.measureNodes removeLastObject];
        [self updateButton];
    }
}

- (IBAction)snapshotButtonTapped:(UIButton *)sender {
    [self checkLibraryAuthorization];
    [Helper.sharedInstance snapshotFromScene:self.sceneView];
    self.sceneView.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
        self.sceneView.alpha = 1.0;
    }];
}

@end
