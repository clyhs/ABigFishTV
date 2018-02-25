//
//  ABFLeftTableViewCell.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/8.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABFLeftTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UIImageView *icon;

@property(nonatomic,strong) UIView  *rightLine;
@property(nonatomic,strong) UIView  *bottomLine;

@property(nonatomic,strong) NSString *iconUrl;

@end
