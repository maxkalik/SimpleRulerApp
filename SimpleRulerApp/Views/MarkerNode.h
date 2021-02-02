//
//  MarkerNode.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/2/21.
//

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarkerNode : SCNNode

- (id)initWithHitResult:(ARHitTestResult*)hitResult;

@end

NS_ASSUME_NONNULL_END
