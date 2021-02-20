//
//  CircleButton.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/20/21.
//

#import "CircleButton.h"

@implementation CircleButton

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self common];
    }
    return self;
}

- (void)common {
    
    UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect: [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    blur.frame = self.bounds;
    [self insertSubview:blur atIndex:0];
    blur.userInteractionEnabled = NO;
    self.layer.cornerRadius = 20.0;
    self.layer.masksToBounds = YES;
    self.showsTouchWhenHighlighted = YES;
    
    if (self.imageView != nil) {
        [self bringSubviewToFront:self.imageView];
    }
}

@end
