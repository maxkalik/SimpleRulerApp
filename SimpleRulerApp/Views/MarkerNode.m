//
//  MarkerNode.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/2/21.
//

#import "MarkerNode.h"

@interface MarkerNode ()

@property (nonatomic, weak, nullable) ARHitTestResult* hitResult;

@end

@implementation MarkerNode

- (id)initWithHitResult:(ARHitTestResult*)hitResult {
    self = [super init];
    if (self) {
        self.hitResult = hitResult;
        [self common];
    }
    
    return self;
}

- (void)common {
    if (self.hitResult != nil) {
        SCNCylinder *cylinder = [SCNCylinder cylinderWithRadius:0.007 height:0.0001];
        SCNMaterial* material = [[SCNMaterial alloc] init];
        material.diffuse.contents = UIColor.whiteColor;
        cylinder.materials = [[NSArray alloc] initWithObjects:material, nil];
        
        self.geometry = cylinder;
        
        simd_float4 location = self.hitResult.worldTransform.columns[3];
        self.position = SCNVector3Make(location.x, location.y, location.z);
    }
}

@end
