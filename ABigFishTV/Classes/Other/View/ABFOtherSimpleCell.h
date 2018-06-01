//
//  ABFOtherSimpleCell.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/6.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABFOtherSimpleCell : UITableViewCell

@property(nonatomic,weak) UILabel *titleLabel;

@property(nonatomic,weak) UILabel *timeLabel;

@property(nonatomic,weak) UIView *lineView;

-(void)setTitle:(NSString *)title time:(NSString *)time;


@end
