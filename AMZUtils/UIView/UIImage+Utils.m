//
//  UIImage+Utils.m
//  TemplateApp
//
//  Created by Admin on 11/8/18.
//  Copyright © 2018 MobilePasse. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)

- (NSData *)compressImage
{
    NSData *imageData;
    imageData=[[NSData alloc] initWithData:UIImageJPEGRepresentation((self), 1.0)];
    
    NSLog(@"[BEFORE] image size: %lu--", (unsigned long)[imageData length]);
    
    CGFloat scale= (100*1024)/(CGFloat)[imageData length];
    
    
    UIImage *small_image=[UIImage imageWithCGImage:self.CGImage scale:scale orientation:self.imageOrientation];
    
    imageData = UIImageJPEGRepresentation(small_image, scale*1.00);
    
    NSLog(@"[AFTER] image size: %lu:%f", (unsigned long)[imageData length],scale);

    return imageData;
}

@end
