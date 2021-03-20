//
//  SnapshotButton.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 3/6/21.
//

#import "SnapshotButton.h"

@interface SnapshotButton ()

@property (nonatomic, strong)CAShapeLayer *circleLayer;

@end

@implementation SnapshotButton

@synthesize enabled = _enabled;

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self common];
    }
    return self;
}

- (void)common {
    self.circleLayer = [[CAShapeLayer alloc] init];
    [self.circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 60, 60)] CGPath]];
    self.circleLayer.fillColor = [UIColor.whiteColor CGColor];
    self.showsTouchWhenHighlighted = YES;
    [self.layer addSublayer:self.circleLayer];
}

- (void)setEnabled:(BOOL)enabled {
    self.circleLayer.opacity = enabled ? 0.8 : 0.2;
    _enabled = enabled;
}

@end
