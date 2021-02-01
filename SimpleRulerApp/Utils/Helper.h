//
//  Helper.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Helper : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
