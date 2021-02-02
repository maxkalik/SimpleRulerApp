//
//  CylinderLine.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/2/21.
//

#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CylinderLineNode : SCNNode

- (id)initWithDistance:(float)distance and:(SCNVector3)midpoint;

@end

NS_ASSUME_NONNULL_END
