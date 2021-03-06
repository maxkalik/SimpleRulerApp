//
//  ImageSaver.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 3/6/21.
//

#import "ImageSaver.h"

@implementation ImageSaver

- (instancetype)initPrivate {
    self = [super init];
    return self;
}

+ (instancetype)sharedInstance {
    static ImageSaver *uniqueInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uniqueInstance = [[ImageSaver alloc] initPrivate];
    });
    
    return uniqueInstance;
}

- (void)writeToPhotoAlbumImage:(UIImage*)image {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

@end
