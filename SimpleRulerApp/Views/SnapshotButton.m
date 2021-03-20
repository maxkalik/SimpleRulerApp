//
//  SnapshotButton.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 3/6/21.
//

#import "SnapshotButton.h"

@implementation SnapshotButton

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self common];
    }
    return self;
}

- (void)common {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 60, 60)] CGPath]];
    circleLayer.fillColor = [UIColor.whiteColor CGColor];
    self.showsTouchWhenHighlighted = YES;
    [self.layer addSublayer:circleLayer];
}

@end
