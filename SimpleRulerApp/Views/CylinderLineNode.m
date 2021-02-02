//
//  CylinderLine.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/2/21.
//

#import "CylinderLineNode.h"

@interface CylinderLineNode ()

@property (nonatomic, assign) float distance;
@property (nonatomic, assign) SCNVector3 midpoint;

@end

@implementation CylinderLineNode

- (id)initWithDistance:(float)distance and:(SCNVector3)midpoint {
    self = [super init];
    if (self) {
        self.distance = distance;
        self.midpoint = midpoint;
        
        [self common];
    }
    return self;
}

- (void)common {
    SCNCylinder *cylinderLine = [SCNCylinder cylinderWithRadius:0.002 height:self.distance];
    cylinderLine.radialSegmentCount = 5;
    cylinderLine.firstMaterial.diffuse.contents = UIColor.whiteColor;
    
    self.geometry = cylinderLine;
    self.position = self.midpoint;
}

@end
