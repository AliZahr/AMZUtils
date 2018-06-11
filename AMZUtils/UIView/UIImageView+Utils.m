//
//  UIImageView+Utils.m
//  Al Chef
//
//  Created by Admin on 4/17/18.
//  Copyright © 2018 MobilePasse. All rights reserved.
//

#import "UIImageView+Utils.h"

@implementation UIImageView (Utils)

- (void)setImageBlur
{
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.image.CGImage];

    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];

    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];

    UIImage *retVal = [UIImage imageWithCGImage:cgImage];

    if (cgImage) {
        CGImageRelease(cgImage);
    }
    self.image = retVal;
}


@end
