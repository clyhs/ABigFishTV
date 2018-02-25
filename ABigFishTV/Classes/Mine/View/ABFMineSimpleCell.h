//
//  ABFMineSimpleCell.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/25.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABFMineSimpleCell : UITableViewCell

@property(nonatomic,weak) UILabel *titleLabel;
@property(nonatomic,weak) UILabel *descLabel;
@property(nonatomic,weak) UIImageView *iconimage;
@property(nonatomic,weak) UIImageView *profile;
@property(nonatomic,weak) UIImage *profileImage;
@property(nonatomic,strong) NSString *profileUrl;
@property(nonatomic,weak) UIView *lineView;

@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *desc;
@property(nonatomic,strong) NSString *iconName;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;

@end
