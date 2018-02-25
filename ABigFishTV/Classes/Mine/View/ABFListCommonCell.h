//
//  ABFListCommonCell.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/18.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABFTelevisionInfo;

@interface ABFListCommonCell : UITableViewCell

@property(nonatomic,weak) UILabel *titleLabel;

@property(nonatomic,weak) UIView *lineView;

@property(nonatomic,strong) ABFTelevisionInfo *model;


- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;

@end
