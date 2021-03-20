//
//  UIViewController+Alert.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 3/20/21.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)

- (void)alertWithTitle:(NSString*)title message:(NSString*)message completion:(nullable completion)completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:completionHandler];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
