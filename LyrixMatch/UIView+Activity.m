//
//  UIView+Activity.m
//  PaperStack
//
//  Created by Hamon Riazy on 4/3/14.
//  Copyright (c) 2014 Hamon Riazy. All rights reserved.
//

#import "UIView+Activity.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface UIView (ActivityPrivate)

- (CGPoint)centerPointForPosition:(id)position withNotification:(UIView *)notification;
- (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image;

@end

NSString * const kActivityViewKey  = @"kActivityViewKey";

@implementation UIView (Activity)

- (void)showActivity {
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &kActivityViewKey);
    if (existingActivityView != nil) return;
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    activityView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    activityView.backgroundColor = [UIColor clearColor];
    activityView.alpha = 0.0f;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = activityView.frame.size.width / 2.0f;
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate ourselves with the activity view
    objc_setAssociatedObject (self, &kActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0f;
                     } completion:nil];
}

- (void)hideActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &kActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &kActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

@end
