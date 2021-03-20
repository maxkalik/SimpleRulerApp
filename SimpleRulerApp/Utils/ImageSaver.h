//
//  ImageSaver.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 3/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageSaver : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)sharedInstance;
- (void)writeToPhotoAlbumImage:(UIImage*)image;

@end

NS_ASSUME_NONNULL_END
