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
        SCNSphere *sphere = [SCNSphere sphereWithRadius:0.007];
        SCNMaterial* material = [[SCNMaterial alloc] init];
        material.diffuse.contents = UIColor.whiteColor;
        sphere.materials = [[NSArray alloc] initWithObjects:material, nil];
        
        self.geometry = sphere;
        
        simd_float4 location = self.hitResult.worldTransform.columns[3];
        self.position = SCNVector3Make(location.x, location.y, location.z);
    }
}

@end
