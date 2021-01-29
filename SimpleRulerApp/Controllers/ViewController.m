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
@end

    
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sceneView.delegate = self;
    self.sceneView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    self.sceneView.autoenablesDefaultLighting = YES;
    
    self.markerNodes = [[NSMutableArray alloc] init];
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
    if (hitTestResut == nil) {
        return;
    }
    
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
