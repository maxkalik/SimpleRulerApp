//
//  HomeViewControllerHelper.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/19/21.
//

#import <Foundation/Foundation.h>
#import <ARKit/ARKit.h>
#import "MeasurementNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewControllerHelper : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)sharedInstance;

- (ARHitTestResult* _Nullable)getHitResultFromTapGesture:(UITapGestureRecognizer*)sender inSceneView:(ARSCNView *)sceneView;
- (void)convertMeasurementInTextNode:(MeasurementNode*)textNode toSelectedMeasurementIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
