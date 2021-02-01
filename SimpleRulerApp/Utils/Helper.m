//
//  Helper.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/2/21.
//

#import "Helper.h"

@implementation Helper

- (instancetype)initPrivate {
    self = [super init];
    return self;
}

+ (instancetype)sharedInstance {
    static Helper *uniqueInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uniqueInstance = [[Helper alloc] initPrivate];
    });
    
    return uniqueInstance;
}

@end
