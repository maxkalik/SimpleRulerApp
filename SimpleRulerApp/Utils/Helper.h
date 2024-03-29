//
//  Helper.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/2/21.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import "MeasureNode.h"
#import "UnitNode.h"
#import "Result.h"
#import "NSArray+Helper.h"

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

/* Get Hit Result From Tap Gesture */

- (NodePositions)calculateDistanceFrom:(SCNVector3)startPoint to:(SCNVector3)endPoint;

/* Calculate Distance */

- ( ARHitTestResult* _Nullable )getHitResultFromTapGesture:(UITapGestureRecognizer*)sender inSceneView:(ARSCNView *)sceneView;

/* Convert Measurement Into Text Node */

- (void)convertUnitInUnitNode:(UnitNode*)unitNode toSelectedMeasurementIndex:(NSInteger)index;
- (void)convertUnitsInMeasureNodes:(NSArray<SCNNode *>*)textNodes toSelectedMeasurementIndex:(NSInteger)index;

/* Sum of results */

- (Result*)sumOfResults:(NSArray<Result*>*)results;

/* Result String Format */

- (NSString*)convertToStringResultMeasurement:(double)measurement;

#pragma mark - Prepare Results Array

- (NSArray<Result*>*)getResultsFromMeasureNodes:(NSMutableArray<MeasureNode*>*)nodes;

#pragma mark - Save snapshot to album

- (void)snapshotFromScene:(ARSCNView *)scene;

@end

NS_ASSUME_NONNULL_END
