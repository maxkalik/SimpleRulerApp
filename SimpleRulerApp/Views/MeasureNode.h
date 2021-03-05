//
//  MeasureNode.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/20/21.
//

#import <SceneKit/SceneKit.h>
#import "MarkerNode.h"
#import "Result.h"

NS_ASSUME_NONNULL_BEGIN

@interface MeasureNode : SCNNode

@property (nonatomic, strong) Result* result;

- (id)initWithMakerNode:(MarkerNode*)markerNode;
- (void)updateResult:(Result *)nodePositions;

@end

NS_ASSUME_NONNULL_END
