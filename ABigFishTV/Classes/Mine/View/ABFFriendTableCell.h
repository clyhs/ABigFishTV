//
//  ABFFriendTableCell.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/12/6.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABFUserInfo;

@interface ABFFriendTableCell : UITableViewCell

@property(nonatomic,strong)   UILabel *usernameLab;
@property(nonatomic,strong)   UIImageView *profile;
@property(nonatomic,strong)   UILabel *mottoLab;
@property(nonatomic,strong)   UIView  *lineView;

@property(nonatomic,strong) ABFUserInfo *model;

@end
