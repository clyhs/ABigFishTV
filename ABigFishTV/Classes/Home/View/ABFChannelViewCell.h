//
//  ABFChannelViewCell.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/24.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABFTelevisionInfo;

@interface ABFChannelViewCell : UITableViewCell

@property(strong,nonatomic) UILabel *titleLab;

@property(nonatomic,strong) UIImageView *playImageView;

@property(nonatomic,strong) UIImageView *eyeImageView;

@property(nonatomic,strong) UILabel *hitLab;

@property(nonatomic,strong) UIView  *bottomLine;

@property(nonatomic,strong) UIImageView *playImage;

@property(nonatomic,strong) ABFTelevisionInfo *model;


-(void)setPlayerImage:(NSString *)url;
@end
