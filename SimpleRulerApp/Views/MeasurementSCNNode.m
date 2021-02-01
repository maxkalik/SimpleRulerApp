//
//  MeasurementSCNText.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/1/21.
//

#import "MeasurementSCNNode.h"

@interface MeasurementSCNNode ()

@property (nonatomic, assign) float distance;
@property (nonatomic, assign) SCNVector3 midpoint;
@property (nonatomic, assign) double centimeters;
@property (nonatomic, assign) double inches;

@property (nonatomic, strong) SCNText *text;

@end

@implementation MeasurementSCNNode

- (id)initWithDistance:(float)distance and:(SCNVector3)midpoint {
    self = [super init];
    if (self) {
        self.distance = distance;
        self.midpoint = midpoint;
        
        NSMeasurement<NSUnitLength*>* measurement = [[NSMeasurement alloc] initWithDoubleValue:(double)distance unit:NSUnitLength.meters];
        self.centimeters = [measurement measurementByConvertingToUnit:NSUnitLength.centimeters].doubleValue;
        self.inches = [measurement measurementByConvertingToUnit:NSUnitLength.inches].doubleValue;
        
        [self common];
    }
    return self;
}

- (void)common {
    self.text = [SCNText textWithString:[NSString stringWithFormat:@"%.2f", self.centimeters] extrusionDepth:0.1];
    self.text.font = [UIFont fontWithName:@"futura" size:16];
    self.text.flatness = 0.0;
    self.text.alignmentMode = kCAAlignmentCenter;
    [self adjustToScale];
}

- (void)adjustToScale {
    CGFloat scaleFactor = 0.02 / self.text.font.pointSize;
    
    // make text always be turned toward to the camera
    SCNBillboardConstraint *constraint = [[SCNBillboardConstraint alloc] init];
    self.constraints = [[NSArray alloc] initWithObjects:constraint, nil];
    
    self.geometry = self.text;
    self.scale = SCNVector3Make(scaleFactor, scaleFactor, scaleFactor);
    
    SCNVector3 max;
    SCNVector3 min;
    [self getBoundingBoxMin:&max max:&min];
    float offset = (max.x - min.x) / 2 * scaleFactor;
    
    SCNVector3 textPosition = SCNVector3Make(self.midpoint.x + offset, self.midpoint.y + 0.02, self.midpoint.z);
    self.position = textPosition;
}

- (void)showMeters {
    NSLog(@"SHOW METERS %@", [NSString stringWithFormat:@"%.2f", self.centimeters]);
    self.text.string = [NSString stringWithFormat:@"%.2f", self.centimeters];
}

- (void)showInches {
    NSLog(@"SHOW INCHES %@", [NSString stringWithFormat:@"%.2f", self.inches]);
    self.text.string = [NSString stringWithFormat:@"%.2f", self.inches];
}

@end
