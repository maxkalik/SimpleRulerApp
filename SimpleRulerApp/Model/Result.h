//
//  Result.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/20/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Result : NSObject

@property (nonatomic, assign) float centimeters;
@property (nonatomic, assign) float inches;

- (instancetype)initWithDistance:(float)distance;

@end

NS_ASSUME_NONNULL_END
