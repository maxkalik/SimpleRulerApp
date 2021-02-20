//
//  HomeViewControllerHelper.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/19/21.
//

#import "HomeViewControllerHelper.h"

@implementation HomeViewControllerHelper

- (instancetype)initPrivate {
    self = [super init];
    return self;
}

+ (instancetype)sharedInstance {
    static HomeViewControllerHelper *uniqueInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uniqueInstance = [[HomeViewControllerHelper alloc] initPrivate];
    });
    
    return uniqueInstance;
}


- (ARHitTestResult* _Nullable)getHitResultFromTapGesture:(UITapGestureRecognizer*)sender inSceneView:(ARSCNView *)sceneView {
    switch (sender.state) {
        case UIGestureRecognizerStateEnded: {
            CGPoint location = [sender locationOfTouch:0 inView:sceneView];
            NSArray<ARHitTestResult*>* hitTestResut = [sceneView hitTest:location types:ARHitTestResultTypeFeaturePoint];
            return hitTestResut.firstObject;
        };
        default:
            return nil;
    }
}

- (void)convertMeasurementInTextNode:(MeasurementNode*)textNode toSelectedMeasurementIndex:(NSInteger)index {
    switch (index) {
        case 1: {
            [textNode showInches];
            break;
        };
        default: {
            [textNode showCentimeters];
            break;
        };
    }
}

@end
