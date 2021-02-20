//
//  MeasureNode.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/20/21.
//

#import <SceneKit/SceneKit.h>
#import "MarkerNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface MeasureNode : SCNNode

- (id)initWithMakerNode:(MarkerNode*)markerNode;

@end

NS_ASSUME_NONNULL_END
