//
//  UITabBarController+ABFPlayerRotation.m
//  ABigFishPlayer
//
//  Created by 陈立宇 on 2018/3/24.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import "UITabBarController+ABFPlayerRotation.h"
#import <objc/runtime.h>
@implementation UITabBarController (ABFPlayerRotation)

+ (void)load
{
    SEL selectors[] = {
        @selector(selectedIndex)
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"zf_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}

- (NSInteger)zf_selectedIndex
{
    NSInteger index = [self zf_selectedIndex];
    if (index > self.viewControllers.count) { return 0; }
    return index;
}

/**
 * 如果window的根视图是UITabBarController，则会先调用这个Category，然后调用UIViewController+ZFPlayerRotation
 * 只需要在支持除竖屏以外方向的页面重新下边三个方法
 */

// 是否支持自动转屏
- (BOOL)shouldAutorotate
{
    UIViewController *vc = self.viewControllers[self.selectedIndex];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.topViewController shouldAutorotate];
    } else {
        return [vc shouldAutorotate];
    }
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    UIViewController *vc = self.viewControllers[self.selectedIndex];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.topViewController supportedInterfaceOrientations];
    } else {
        return [vc supportedInterfaceOrientations];
    }
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    UIViewController *vc = self.viewControllers[self.selectedIndex];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.topViewController preferredInterfaceOrientationForPresentation];
    } else {
        return [vc preferredInterfaceOrientationForPresentation];
    }
}
@end
