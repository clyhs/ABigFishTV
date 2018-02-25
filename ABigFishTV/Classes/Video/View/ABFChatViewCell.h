//
//  ABFChatViewCell.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/11.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABFChatInfo;

@protocol ABFChatImageDelegate <NSObject>
- (void)pushForImage:(ABFChatInfo *)model imageIndex:(NSInteger)index;
@end

@interface ABFChatViewCell : UITableViewCell

@property(nonatomic,strong)   ABFChatInfo *model;

@property(nonatomic,strong)   UILabel *usernameLab;

@property(nonatomic,strong)   UIImageView *profile;

@property(nonatomic,strong)   UILabel *timeLab;

@property(nonatomic,strong)   UILabel *contextLab;

@property(nonatomic,strong)   UIView  *toolLine;
@property(nonatomic,strong)   UIView  *bottomLine;

@property(nonatomic,strong)   UIView  *zfView;
@property(nonatomic,strong)   UIView  *commentView;
@property(nonatomic,strong)   UIView  *goodView;

@property(nonatomic,strong)   UIImageView *zfImgView;
@property(nonatomic,strong)   UIImageView *commentImgView;
@property(nonatomic,strong)   UIImageView *goodImgView;

@property(nonatomic,strong)   UILabel *commentLab;
@property(nonatomic,strong)   UILabel *goodLab;

@property(nonatomic,strong)   UIButton *goodBtn;
@property(nonatomic,strong)   UIButton *commentBtn;
@property(nonatomic,strong)   UIButton *zfBtn;

@property(nonatomic,strong)   UIView  *topView;
@property(nonatomic,strong)   UIView  *contextView;
@property(nonatomic,strong)   UIView  *imagesView;
@property(nonatomic,strong)   UIView  *toolView;

@property (nonatomic, weak) id<ABFChatImageDelegate> delegate;

@end
