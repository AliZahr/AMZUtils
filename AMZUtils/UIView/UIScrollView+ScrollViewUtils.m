//
//  UIScrollView+ScrollViewUtils.m
//  TemplateApp
//
//  Created by Admin on 10/12/17.
//  Copyright © 2017 MobilePasse. All rights reserved.
//

#import "UIScrollView+ScrollViewUtils.h"

@implementation UIScrollView (ScrollViewUtils)

- (void)fixContentInset
{
    if(@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
@end
