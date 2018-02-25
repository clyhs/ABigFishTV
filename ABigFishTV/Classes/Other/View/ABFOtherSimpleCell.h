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

@property(nonatomic,weak) UIView *lineView;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;

@end
