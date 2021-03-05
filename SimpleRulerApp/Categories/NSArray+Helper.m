//
//  NSArray+Helper.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 3/6/21.
//

#import "NSArray+Helper.h"

@implementation NSArray (Helper)

- (NSArray *)map: (MapBlock)block {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (id object in self) {
        [resultArray addObject:block(object)];
    }
    return resultArray;
}

@end
