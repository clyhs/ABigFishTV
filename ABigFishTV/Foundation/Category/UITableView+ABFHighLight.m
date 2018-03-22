//
//  UITableView+ABFHighLight.m
//  ABigFishTV
//
//  Created by 陈立宇 on 18/3/22.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import "UITableView+ABFHighLight.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface UITableView()<UITableViewDelegate>
@property (nonatomic,strong) UIColor *abf_normalColor;
@end


@implementation UITableView (ABFHighLight)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UITableView swizzinClass:[UITableView class] OriginalSEL:@selector(setDelegate:) TonewSEL:@selector(abf_setDelegate:)];
    });
}

- (void)abf_setDelegate:(id<UITableViewDelegate>)delegate {
    [self abf_setDelegate:delegate];
    Class class = [delegate class];
    SEL originSelector = @selector(tableView:didSelectRowAtIndexPath:);
    SEL swizzlSelector = NSSelectorFromString(@"swiz_didSelectRowAtIndexPath");
    BOOL didAddMethod = class_addMethod(class, swizzlSelector, (IMP)swiz_didSelectRowAtIndexPath, "v@:@@");
    if (didAddMethod) {
        Method originMethod = class_getInstanceMethod(class, swizzlSelector);
        Method swizzlMethod = class_getInstanceMethod(class, originSelector);
        method_exchangeImplementations(originMethod, swizzlMethod);
    }
}

void swiz_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, NSIndexPath *indexpath) {
    SEL selector = NSSelectorFromString(@"swiz_didSelectRowAtIndexPath");
    ((void(*)(id, SEL,id, NSIndexPath *))objc_msgSend)(self, selector, tableView, indexpath);
    UITableView *_tableView = (UITableView *)tableView;
    if (!_tableView.abf_highLightColor) {return;}
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexpath];
    if (!_tableView.abf_normalColor) {
        _tableView.abf_normalColor = cell.backgroundColor;
    }
    cell.backgroundColor = _tableView.abf_highLightColor;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cell.backgroundColor = _tableView.abf_normalColor;
    });
}

+ (void)swizzinClass:(Class)swizzingClass OriginalSEL:(SEL)originalSEL TonewSEL:(SEL)newSEL {
    Method originalMehtod = class_getInstanceMethod(swizzingClass, originalSEL);
    Method newMethod = class_getInstanceMethod(swizzingClass, newSEL);
    BOOL didAddMethod = class_addMethod(swizzingClass, originalSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (didAddMethod) {
        class_replaceMethod(swizzingClass, newSEL, method_getImplementation(originalMehtod), method_getTypeEncoding(originalMehtod));
    }else {
        method_exchangeImplementations(originalMehtod, newMethod);
    }
}

// ----------------------- 高亮颜色 -----------------------
- (void)setAbf_highLightColor:(UIColor *)abf_highLighColor {
    objc_setAssociatedObject(self, @selector(abf_highLightColor), abf_highLighColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)abf_highLightColor {
    return objc_getAssociatedObject(self, @selector(abf_highLightColor));
}

// ----------------------- 默认状态的颜色 -----------------------
- (void)setAbf_normalColor:(UIColor *)abf_normalColor {
    objc_setAssociatedObject(self, @selector(abf_normalColor), abf_normalColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)abf_normalColor {
    return objc_getAssociatedObject(self, @selector(abf_normalColor));
}


@end
