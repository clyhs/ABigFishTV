//
//  ABFMineHeaderView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/24.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MenuBindingDelegate <NSObject>
- (void)pushVC:(NSInteger)tag;
- (void)settingVC:(id)sender;
@end

@interface ABFMineHeaderView : UIView

@property(nonatomic,weak) UIImageView *profile;

@property(nonatomic,weak) UILabel  *username;

@property(nonatomic,weak) UILabel  *descLabel;

@property(nonatomic,weak) UIView   *topView;

@property(nonatomic,weak) UIView   *botView;

@property(nonatomic,strong) UILabel *messageTLab;

@property(nonatomic,strong) UILabel *likeTLab;

@property(nonatomic,strong) UILabel *historyTLab;

@property(nonatomic,strong) UIButton *settingBtn;

@property (nonatomic, weak) id<MenuBindingDelegate> delegate;

@end
