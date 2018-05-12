//
//  ABFProgramViewCell.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/12/18.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABFProgramInfo;

@interface ABFProgramViewCell : UITableViewCell

@property(nonatomic,strong) ABFProgramInfo *model;
@property(nonatomic,weak)   UILabel *timeLab;
@property(nonatomic,weak)   UILabel *nameLab;
@property(nonatomic,weak)   UIView  *lineView;

@end
