//
//  MeasureNode.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/20/21.
//

#import "MeasureNode.h"

@implementation MeasureNode

- (id)initWithMakerNode:(MarkerNode*)markerNode {
    self = [super init];
    if (self) {
        [self addChildNode:markerNode];
    }
    return self;
}

- (void)updateResult:(Result *)result {
    self.result = result;
}

@end
