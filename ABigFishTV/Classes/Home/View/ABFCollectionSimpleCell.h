//
//  ABFCollectionSimpleCell.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/12/5.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABFTelevisionInfo;

@interface ABFCollectionSimpleCell : UICollectionViewCell

@property(strong,nonatomic) UILabel *titleLab;

@property(nonatomic,strong) UIImageView *playImageView;

@property(nonatomic,strong) UIImageView *eyeImageView;

@property(nonatomic,strong) UILabel *hitLab;

@property(nonatomic,strong) UIView  *bottomLine;

@property(nonatomic,strong) UIImageView *playImage;

@property(nonatomic,strong) UILabel *playtitleLab;

@property(nonatomic,strong) UILabel *nexttitleLab;

@property(nonatomic,strong) ABFTelevisionInfo *model;


-(void)setPlayerImage:(NSString *)url;

@end
