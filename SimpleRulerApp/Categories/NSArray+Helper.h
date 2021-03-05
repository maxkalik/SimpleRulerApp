//
//  NSArray+Helper.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 3/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef id _Nullable (^MapBlock)(id);

@interface NSArray (Helper)

- (NSArray *)map:(MapBlock)block;

@end

NS_ASSUME_NONNULL_END
