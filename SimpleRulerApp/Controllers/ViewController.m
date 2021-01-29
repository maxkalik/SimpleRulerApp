//
//  ViewController.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 1/29/21.
//

#import "ViewController.h"

@interface ViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (nonatomic, strong) NSMutableArray<SCNNode*> *markerNodes;

@property (nonatomic, assign) CGFloat panStartZ;
@end

    
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sceneView.delegate = self;
    self.sceneView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    self.sceneView.autoenablesDefaultLighting = YES;
    
    self.markerNodes = [[NSMutableArray alloc] init];
    
    UIGestureRecognizer* panRecongnizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragObject:)];
    [self.sceneView addGestureRecognizer:panRecongnizer];
}

- (void)dragObject:(UIPanGestureRecognizer*)sender {
    // NSLog(@"%f", [sender locationInView:self.sceneView].x);
    CGPoint touchLocation = [sender locationInView:self.sceneView];
    ARHitTestResult* hitTestResut = [self.sceneView hitTest:touchLocation types:ARHitTestResultTypeFeaturePoint].firstObject;
    if (self.markerNodes.count > 0) {
        simd_float4 location = hitTestResut.worldTransform.columns[3];
        [self.markerNodes objectAtIndex:0].position = SCNVector3Make(location.x, location.y, location.z);
    }
    
    
    // switch (sender.state) {
    //     case UIGestureRecognizerStateBegan: {
    //         ARHitTestResult* hitTestResut = [self.sceneView hitTest:touchLocation types:ARHitTestResultTypeFeaturePoint].lastObject;
    //         // NSLog(@"began %f", hitTestResut.worldTransform.columns[3].z);
    //         // NSLog(@"began last pan location %@", hitTestResut.worldTransform);
    //         self.panStartZ = hitTestResut.worldTransform.columns[3].z;
    //     }
    //     case UIGestureRecognizerStateChanged: {
    //         if (self.markerNodes.count > 0) {
    //             SCNVector3 worldTouchPosition = [self.sceneView unprojectPoint:SCNVector3Make(touchLocation.x, touchLocation.y, self.panStartZ)];
    //             markerNode.position = SCNVector3Make(location.x, location.y, location.z);
    //
    //             NSLog(@"changed %f", touchLocation.x);
    //         }
    //     }
    //     default: break;
    // }
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touches.allObjects.firstObject locationInView:self.sceneView];
    ARHitTestResult* hitTestResut = [self.sceneView hitTest:touchLocation types:ARHitTestResultTypeFeaturePoint].firstObject;
    if (hitTestResut == nil) { return; }
    
    // NSLog(@"%@", hitTestResut);
    [self addMarkerAt:hitTestResut];
}


- (void)addMarkerAt:(ARHitTestResult*)hitResult {
    SCNCone* cone = [SCNCone coneWithTopRadius:0.005 bottomRadius:0.001 height:0.02];
    SCNMaterial* material = [[SCNMaterial alloc] init];
    material.diffuse.contents = UIColor.blueColor;
    cone.materials = [NSArray arrayWithObjects:material, nil];
    SCNNode* markerNode = [SCNNode nodeWithGeometry:cone];
    
    simd_float4 location = hitResult.worldTransform.columns[3];
    markerNode.position = SCNVector3Make(location.x, location.y, location.z);
    [self.sceneView.scene.rootNode addChildNode:markerNode];
    
    [self.markerNodes addObject:markerNode];
    
    
    
    [self calculateDistance];
}

- (void)calculateDistance {
    NSLog(@"%@", self.markerNodes);
}

@end
