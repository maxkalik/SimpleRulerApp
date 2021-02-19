//
//  Helper.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/2/21.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import "MeasurementNode.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct NodePositions {
    float distance;
    SCNVector3 midpoint;
    SCNVector3 start;
    SCNVector3 end;
} NodePositions;

@interface Helper : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)sharedInstance;

- (NodePositions)calculateDistanceFrom:(SCNVector3)startPoint to:(SCNVector3)endPoint;
- ( ARHitTestResult* _Nullable )getHitResultFromTapGesture:(UITapGestureRecognizer*)sender inSceneView:(ARSCNView *)sceneView;
- (void)convertMeasurementInTextNode:(NSArray<SCNNode *>*)textNodes toSelectedMeasurementIndex:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
