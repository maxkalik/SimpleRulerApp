//
//  UIViewController+Alert.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 3/20/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^completion)(UIAlertAction *);

@interface UIViewController (Alert)

- (void)alertWithTitle:(NSString*)title message:(NSString*)message completion:(nullable completion)completionHandler;

@end

NS_ASSUME_NONNULL_END
