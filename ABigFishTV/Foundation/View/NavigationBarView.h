//
//  NavigationBarView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/23.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationBarView : UIView

@property (nonatomic, strong) NSString *title;

@property (nonatomic, copy)   void (^navBackHandle)(void);

@property (nonatomic, assign) CGFloat backgroundAlpha;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
