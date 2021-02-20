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
        self.centimeters = [measurement measurementByConvertingToUnit:NSUnitLength.centimeters].doubleValue;
        self.inches = [measurement measurementByConvertingToUnit:NSUnitLength.inches].doubleValue;
    }
    return self;
}

@end
