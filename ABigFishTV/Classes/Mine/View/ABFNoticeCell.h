//
//  ABFNoticeCell.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/20.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABFNoticeInfo;

@interface ABFNoticeCell : UITableViewCell

@property(nonatomic,weak) UIView *lineView;

@property(nonatomic,weak) UILabel *titleLabel;

@property(nonatomic,weak) UILabel *typeNameLab;

@property(nonatomic,weak) UILabel *createAtLab;

@property(nonatomic,strong) ABFNoticeInfo *model;

@end
