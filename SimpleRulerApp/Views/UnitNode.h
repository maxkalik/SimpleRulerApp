//
//  MeasurementSCNText.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/1/21.
//

#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnitNode : SCNNode

- (id)initWithDistance:(float)distance and:(SCNVector3)midpoint;
- (void)showCentimeters;
- (void)showInches;

@end

NS_ASSUME_NONNULL_END
