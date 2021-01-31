//
//  ViewController.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 1/29/21.
//

#import "ViewController.h"

@interface ViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (nonatomic, strong) NSMutableArray<SCNNode*> *markerNodes;
@property (nonatomic, strong) NSMutableArray<SCNNode*> *lineNodes;
@property (nonatomic, strong) SCNNode *textNode;

@end

    
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sceneView.delegate = self;
    self.sceneView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    // self.sceneView.autoenablesDefaultLighting = YES;
    
    self.markerNodes = [[NSMutableArray alloc] init];
    self.lineNodes = [[NSMutableArray alloc] init];
    self.textNode = [[SCNNode alloc] init];
    
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
    
    if (self.markerNodes.count > 2) {
        [self.markerNodes.firstObject removeFromParentNode];
        [self.markerNodes removeObjectAtIndex:0];
        [self calculateDistance];
    } else if (self.markerNodes.count == 2) {
        [self calculateDistance];
    }
}

- (SCNNode*)drawTheLineFrom:(SCNVector3)startPoint to:(SCNVector3)endPoint {
    // draw the line
    SCNVector3 vertices[] = { startPoint, endPoint };
    int indices[] = {0, 1};
    
    SCNGeometrySource *vertexSource = [SCNGeometrySource geometrySourceWithVertices:vertices count:2];
    
    NSData *indexData = [NSData dataWithBytes:indices length:sizeof(indices)];
    SCNGeometryElement *element = [SCNGeometryElement geometryElementWithData:indexData primitiveType:SCNGeometryPrimitiveTypeLine primitiveCount:1 bytesPerIndex:sizeof(int)];
    SCNGeometry *line = [SCNGeometry geometryWithSources:[[NSArray alloc] initWithObjects:vertexSource, nil] elements:[[NSArray alloc] initWithObjects:element, nil]];
    
    // line color
    line.firstMaterial.lightingModelName = SCNLightingModelConstant;
    line.firstMaterial.diffuse.contents = UIColor.whiteColor;
    
    SCNNode *lineNode = [SCNNode nodeWithGeometry:line];
    
    return lineNode;
}


- (SCNNode*)drawThiCylinderLineFrom:(SCNVector3)startPoint to:(SCNVector3)endPoint {
    // SCNVector3 vector = SCNVector3Make(startPoint.x - endPoint.x, startPoint.y - endPoint.y, startPoint.z - endPoint.z);
    
    GLKVector3 startPosition = SCNVector3ToGLKVector3(startPoint);
    GLKVector3 endPosition = SCNVector3ToGLKVector3(endPoint);
    
    float distance = GLKVector3Distance(startPosition, endPosition);
    
    // float distance = sqrtf(vector.x * vector.x + vector.y + vector.y + vector.z * vector.z);
    SCNVector3 midPosition = SCNVector3Make((startPoint.x + endPoint.x) / 2, (startPoint.y + endPoint.y) / 2, (startPoint.z + endPoint.z) / 2);
    
    SCNCylinder *cylinderLine = [SCNCylinder cylinderWithRadius:0.002 height:distance];
    // cylinderLine.radialSegmentCount = 5;
    cylinderLine.firstMaterial.diffuse.contents = UIColor.whiteColor;
    
    SCNNode *lineNode = [SCNNode nodeWithGeometry:cylinderLine];
    lineNode.position = midPosition;
    [lineNode lookAt:endPoint up:self.sceneView.scene.rootNode.worldUp localFront:lineNode.worldUp];
    return lineNode;
    
}


- (void)calculateDistance {
    SCNNode *start = [self.markerNodes objectAtIndex:0];
    SCNNode *end = [self.markerNodes objectAtIndex:1];
    
    // draw the line
    // SCNNode *lineNode = [self drawTheLineFrom:start.position to:end.position];
    SCNNode *lineNode = [self drawThiCylinderLineFrom:start.position to:end.position];
    
    [self.sceneView.scene.rootNode addChildNode:lineNode];
    [self.lineNodes addObject:lineNode];
    
    NSLog(@"%lu",self.lineNodes.count);
    
    if (self.lineNodes.count > 1) {
        [self.lineNodes.firstObject removeFromParentNode];
        [self.lineNodes removeObjectAtIndex:0];
    }
    
    
    // calculate distance
    GLKVector3 startPosition = SCNVector3ToGLKVector3(start.position);
    GLKVector3 endPosition = SCNVector3ToGLKVector3(end.position);
    
    float distance = GLKVector3Distance(startPosition, endPosition);
    
    // find midpoint between points for text node position
    /*
         x1 + x2    y1 + y2    z1 + z2
     M( ---------, ---------, --------- )
            2          2          2
    */
    GLKVector3 sum = GLKVector3Add(startPosition, endPosition);
    SCNVector3 midpoint = SCNVector3Make(sum.x / 2, sum.y / 2, sum.z / 2);
    
    [self addText:[NSString stringWithFormat:@"%.2f", [self convertToInchesFromMeters:distance]] :midpoint];
}

- (void)addText:(NSString*)str :(SCNVector3)location {
    SCNText *text = [SCNText textWithString:str extrusionDepth:0.1];
    text.font = [UIFont fontWithName:@"futura" size:16];
    text.flatness = 0.0;
    CGFloat scaleFactor = 0.02 / text.font.pointSize;
    
    // make text always be turned toward to the camera
    SCNBillboardConstraint *constraint = [[SCNBillboardConstraint alloc] init];
    // [self.textNode.constraints arrayByAddingObject:constraint];
    self.textNode.constraints = [[NSArray alloc] initWithObjects:constraint, nil];
    
    self.textNode.geometry = text;
    self.textNode.scale = SCNVector3Make(scaleFactor, scaleFactor, scaleFactor);
    
    SCNVector3 max;
    SCNVector3 min;
    
    [self.textNode getBoundingBoxMin:&max max:&min];
    float offset = (max.x - min.x) / 2 * scaleFactor;
    
    SCNVector3 textPosition = SCNVector3Make(location.x + offset, location.y, location.z);
    
    self.textNode.position = textPosition;
    [self.sceneView.scene.rootNode addChildNode:self.textNode];
    // NSLog(@"%@", self.sceneView.scene.rootNode.childNodes);
}

- (double)convertToInchesFromMeters:(float)meters {
    NSMeasurement<NSUnitLength*>* measurement = [[NSMeasurement alloc] initWithDoubleValue:(double)meters unit:NSUnitLength.meters];
    NSMeasurement<NSUnitLength*>* length;
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        length = [measurement measurementByConvertingToUnit:NSUnitLength.centimeters];
        
    } else {
        length = [measurement measurementByConvertingToUnit:NSUnitLength.inches];
    }
    return length.doubleValue;
}

- (IBAction)segmentControlChanged:(id)sender {
    [self calculateDistance];
}

@end
