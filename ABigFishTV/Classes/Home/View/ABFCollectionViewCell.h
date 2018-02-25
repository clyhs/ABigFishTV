//
//  ABFCollectionViewCell.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/22.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABFTelevisionInfo.h"

@interface ABFCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UIImage *iconImg;
@property(nonatomic,strong) UIImageView *icon;

@property(nonatomic,strong) UIImageView *eyeImageView;

@property(nonatomic,strong) UILabel *hitLab;

@property(nonatomic,copy) ABFTelevisionInfo *model;

@end
