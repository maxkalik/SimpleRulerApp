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
@property (weak, nonatomic) IBOutlet CircleButton *undoButton;
@property (weak, nonatomic) IBOutlet CircleButton *resultsButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitSegmentControl;

@property (nonatomic, strong) NSMutableArray<MeasureNode*> *measureNodes;
@property (nonatomic, assign) NSInteger markerCount;

@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sceneView.delegate = self;
    self.sceneView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    self.sceneView.pointOfView.camera.usesOrthographicProjection = YES;
    self.measureNodes = [[NSMutableArray<MeasureNode*> alloc] init];
    
    self.resultsButton.enabled = NO;
    self.undoButton.enabled = NO;
    
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
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (!granted) {
            NSLog(@"not granted");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This app is not authorized to use Camera." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"taped settings");
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    // [UIApplication.sharedApplication canOpenURL:settingURL];
                    [UIApplication.sharedApplication openURL:settingURL options:@{} completionHandler:^(BOOL success) {
                        if (success) {
                            NSLog(@"Opened url");
                        }
                    }];
                });
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self presentViewController:alert animated:YES completion:nil];
            });
            return;
        }
    }];
    
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
    self.undoButton.enabled = isMeasureNodesNotEmpty;
    self.resultsButton.enabled = isMeasureNodesNotEmpty;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toResults"]) {
        ResultsViewController *resultsVC = (ResultsViewController *)segue.destinationViewController;
        resultsVC.results = [Helper.sharedInstance getResultsFromMeasureNodes:self.measureNodes];
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
        self.markerCount = 0;
        [self.measureNodes removeLastObject];
        [self updateButton];
    }
}

- (IBAction)snapshotButtonTapped:(UIButton *)sender {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                NSLog(@"Authorized");
                break;
            case PHAuthorizationStatusRestricted:
                NSLog(@"Restricted");
                break;
            case PHAuthorizationStatusDenied: {
                NSLog(@"Denied");
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This app is not authorized to use Camera." preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"taped settings");
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        // [UIApplication.sharedApplication canOpenURL:settingURL];
                        [UIApplication.sharedApplication openURL:settingURL options:@{} completionHandler:^(BOOL success) {
                            if (success) {
                                NSLog(@"Opened url");
                            }
                        }];
                    });
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self presentViewController:alert animated:YES completion:nil];
                });
                
                break;
            }
            default:
                break;
        }
    }];
    
    [Helper.sharedInstance snapshotFromScene:self.sceneView];
    self.sceneView.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
        self.sceneView.alpha = 1.0;
    }];
}

@end
