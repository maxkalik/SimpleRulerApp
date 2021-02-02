//
//  MeasurementSCNText.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/1/21.
//

#import "MeasurementNode.h"

@interface MeasurementNode ()

@property (nonatomic, assign) float distance;
@property (nonatomic, assign) SCNVector3 midpoint;
@property (nonatomic, strong) NSMeasurement<NSUnitLength*>* measurement;
@property (nonatomic, strong) SCNText *text;

@end

@implementation MeasurementNode

- (id)initWithDistance:(float)distance and:(SCNVector3)midpoint {
    self = [super init];
    if (self) {
        self.distance = distance;
        self.midpoint = midpoint;
        
        self.measurement = [[NSMeasurement alloc] initWithDoubleValue:(double)distance unit:NSUnitLength.meters];
        
        [self common];
    }
    return self;
}

- (void)common {
    self.text = [SCNText textWithString:[self getMeasurementFromLength:NSUnitLength.centimeters] extrusionDepth:0.1];
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

- (NSString*)getMeasurementFromLength:(NSUnitLength*)length {
    return [NSString stringWithFormat:@"%.2f", [self.measurement measurementByConvertingToUnit:length].doubleValue];
}

- (void)showCentimeters {
    self.text.string = [self getMeasurementFromLength:NSUnitLength.centimeters];
}

- (void)showInches {
    self.text.string = [self getMeasurementFromLength:NSUnitLength.inches];
}

@end
