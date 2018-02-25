//
//  ABFRightTableViewCell.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/19.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABFTelevisionInfo;

@interface ABFRightTableViewCell : UITableViewCell

@property(nonatomic,weak) UILabel *titleLabel;

@property(nonatomic,weak) UIView *lineView;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;

@property(nonatomic,strong) ABFTelevisionInfo *model;

@end
