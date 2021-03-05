//
//  Result.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/20/21.
//

#import "Result.h"

@implementation Result

- (instancetype)initWithDistance:(float)distance {
    self = [super init];
    if (self) {
        NSMeasurement<NSUnitLength*>* measurement = [[NSMeasurement alloc] initWithDoubleValue:(double)distance unit:NSUnitLength.meters];
        self.inches = [measurement measurementByConvertingToUnit:NSUnitLength.inches].doubleValue;
        self.centimeters = [measurement measurementByConvertingToUnit:NSUnitLength.centimeters].doubleValue;
    }
    return self;
}

- (instancetype)initWithInches:(double)inches andCentimeters:(double)centimeters {
    self = [self init];
    if (self) {
        self.inches = inches;
        self.centimeters = centimeters;
    }
    return self;
}

@end
