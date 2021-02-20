//
//  Helper.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/2/21.
//

#import "Helper.h"

@implementation Helper

- (instancetype)initPrivate {
    self = [super init];
    return self;
}

+ (instancetype)sharedInstance {
    static Helper *uniqueInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uniqueInstance = [[Helper alloc] initPrivate];
    });
    
    return uniqueInstance;
}

#pragma mark - Get Hit Result From Tap Gesture

- (ARHitTestResult* _Nullable)getHitResultFromTapGesture:(UITapGestureRecognizer*)sender inSceneView:(ARSCNView *)sceneView {
    switch (sender.state) {
        case UIGestureRecognizerStateEnded: {
            CGPoint location = [sender locationOfTouch:0 inView:sceneView];
            NSArray<ARHitTestResult*>* hitTestResut = [sceneView hitTest:location types:ARHitTestResultTypeFeaturePoint];
            return hitTestResut.firstObject;
        };
        default:
            return nil;
    }
}

#pragma mark - Calculate Distance

- (NodePositions)calculateDistanceFrom:(SCNVector3)startPoint to:(SCNVector3)endPoint {
    // calculate distance
    GLKVector3 startPosition = SCNVector3ToGLKVector3(startPoint);
    GLKVector3 endPosition = SCNVector3ToGLKVector3(endPoint);
    
    float distance = GLKVector3Distance(startPosition, endPosition);
    
    // find midpoint between points for text node position
    /*
         x1 + x2    y1 + y2    z1 + z2
     M( ---------, ---------, --------- )
            2          2          2
    */
    
    GLKVector3 sum = GLKVector3Add(startPosition, endPosition);
    SCNVector3 midpoint = SCNVector3Make(sum.x / 2, sum.y / 2, sum.z / 2);
    
    NodePositions nodePositions = {
        .distance = distance,
        .midpoint = midpoint,
        .start = startPoint,
        .end = endPoint
    };
    
    return nodePositions;
}

#pragma mark - Convert Measurement Into Text Node

- (void)convertMeasurementInTextNode:(NSArray<SCNNode *>*)textNodes toSelectedMeasurementIndex:(NSInteger)index {
    for (SCNNode *node in textNodes) {
        if ([node isKindOfClass: [MeasurementNode class]]) {
            MeasurementNode *textNode = (MeasurementNode*)node;
            switch (index) {
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
    }
}

@end
