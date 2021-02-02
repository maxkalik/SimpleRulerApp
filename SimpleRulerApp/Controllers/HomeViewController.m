//
//  ViewController.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 1/29/21.
//

#import "HomeViewController.h"
#import "MeasurementSCNNode.h"
#import "CylinderLineSCNNode.h"
#import "Helper.h"

@interface HomeViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, strong) NSMutableArray<SCNNode*> *markerNodes;

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
    switch (sender.state) {
        case UIGestureRecognizerStateEnded: {
            CGPoint location = [sender locationOfTouch:0 inView:self.sceneView];
            NSArray<ARHitTestResult*>* hitTestResut = [self.sceneView hitTest:location types:ARHitTestResultTypeFeaturePoint];
            if (hitTestResut.firstObject == nil) { return; }
            [self addMarkerAt:hitTestResut.firstObject];
        };
        default:
            break;
    }
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
    // SCNCone* cone = [SCNCone coneWithTopRadius:0.007 bottomRadius:0.001 height:0.03];
    SCNCylinder *cylinder = [SCNCylinder cylinderWithRadius:0.007 height:0.0001];
    SCNMaterial* material = [[SCNMaterial alloc] init];
    material.diffuse.contents = UIColor.whiteColor;
    cylinder.materials = [[NSArray alloc] initWithObjects:material, nil];
    SCNNode* markerNode = [SCNNode nodeWithGeometry:cylinder];
    
    simd_float4 location = hitResult.worldTransform.columns[3];
    markerNode.position = SCNVector3Make(location.x, location.y, location.z);
    [self.sceneView.scene.rootNode addChildNode:markerNode];
    
    [self.markerNodes addObject:markerNode];
    
    if (self.markerNodes.count % 2 == 0) {
        NSLog(@"calculate distance");
        [self calculateDistance];
    }
}

- (void)calculateDistance {
    SCNNode *start = [self.markerNodes objectAtIndex:self.markerNodes.count - 2];
    SCNNode *end = [self.markerNodes lastObject];

    NodePositions nodePositions = [Helper.sharedInstance calculateDistanceFrom:start.position to:end.position];
    
    [self addTextFor:nodePositions];
    [self addLineFor:nodePositions];
}

- (void)addLineFor:(NodePositions)nodePositions {
    CylinderLineSCNNode *cylinderLineNode = [[CylinderLineSCNNode alloc] initWithDistance:nodePositions.distance and:nodePositions.midpoint];
    [cylinderLineNode lookAt:nodePositions.end up:self.sceneView.scene.rootNode.worldUp localFront:cylinderLineNode.worldUp];
    [self.sceneView.scene.rootNode addChildNode:cylinderLineNode];
}

- (void)addTextFor:(NodePositions)nodePositions {
    MeasurementSCNNode *textNode = [[MeasurementSCNNode alloc] initWithDistance:nodePositions.distance and:nodePositions.midpoint];
    [self.sceneView.scene.rootNode addChildNode:textNode];
}

- (void)convertMeasurementInTextNode:(MeasurementSCNNode*)textNode {
    switch (self.segmentControl.selectedSegmentIndex) {
        case 1: {
            [textNode showInches];
            break;
        };
        default: {
            [textNode showCentimeters];
            break;
        };
    }
}

- (IBAction)segmentControlChanged:(id)sender {
    for (SCNNode *node in self.sceneView.scene.rootNode.childNodes) {
        if ([node isKindOfClass: [MeasurementSCNNode class]]) {
            MeasurementSCNNode *textNode = (MeasurementSCNNode*)node;
            [self convertMeasurementInTextNode:textNode];
        }
    }
}

@end
