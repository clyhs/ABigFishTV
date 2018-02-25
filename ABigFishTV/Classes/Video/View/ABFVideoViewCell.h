//
//  ABFVideoViewCell.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/11.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABFVideoInfo;

@interface ABFVideoViewCell : UITableViewCell

@property(nonatomic,strong) UILabel      *titleLab;

@property(nonatomic,strong) UIView       *coverBgView;

@property(nonatomic,strong) UIImageView  *coverView;

@property(nonatomic,strong) UIImageView  *playImage;

@property(nonatomic,strong) UILabel      *usernameLab;

@property(nonatomic,strong) UIImageView  *profile;

@property (nonatomic, weak) UIView       *bottomLine;

@property(nonatomic,strong)   UIView  *commentView;
@property(nonatomic,strong)   UIView  *goodView;

@property(nonatomic,strong)   UIImageView *commentImgView;
@property(nonatomic,strong)   UIImageView *goodImgView;

@property(nonatomic,strong)   UILabel *commentLab;
@property(nonatomic,strong)   UILabel *goodLab;


@property(nonatomic,strong) ABFVideoInfo *model;



@end
