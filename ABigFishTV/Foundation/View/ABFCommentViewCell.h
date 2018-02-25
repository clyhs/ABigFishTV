//
//  ABFCommentViewCell.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/7.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABFCommentInfo;

@protocol ABFCommentViewCellDelegate <NSObject>
- (void)pushForButton:(ABFCommentInfo *)model index:(NSInteger)tag;
- (void)pushForReplyButton:(ABFCommentInfo *)model index:(NSInteger)tag;
@end

@interface ABFCommentViewCell : UITableViewCell

@property(nonatomic,strong) ABFCommentInfo *model;

@property(nonatomic,strong)   UILabel *usernameLab;
@property(nonatomic,strong)   UIImageView *profile;
@property(nonatomic,strong)   UILabel *timeLab;
@property(nonatomic,strong)   UILabel *contextLab;
@property(nonatomic,strong)   UIView  *replyView;

@property(nonatomic,strong)   UIView  *lineView;

@property(nonatomic,strong)   UIView  *replyToolView;
@property(nonatomic,strong)   UIView  *goodToolView;
@property(nonatomic,strong)   UIImageView *replyImgView;
@property(nonatomic,strong)   UIImageView *goodImgView;

@property(nonatomic,assign)   Boolean isGood;

@property (nonatomic, weak) id<ABFCommentViewCellDelegate> delegate;


@end
