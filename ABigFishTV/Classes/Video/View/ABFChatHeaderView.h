//
//  ABFChatHeaderView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/24.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABFChatInfo;

@protocol ABFChatHeaderImageDelegate <NSObject>
- (void)pushForImage:(ABFChatInfo *)model imageIndex:(NSInteger)index;
- (void)shareAction;
@end

@interface ABFChatHeaderView : UIView

@property(nonatomic,strong)   ABFChatInfo *model;

@property(nonatomic,strong)   UILabel *usernameLab;

@property(nonatomic,strong)   UIImageView *profile;

@property(nonatomic,strong)   UILabel *timeLab;

@property(nonatomic,strong)   UILabel *contextLab;

@property(nonatomic,strong)   UIView  *topView;
@property(nonatomic,strong)   UIView  *contextView;
@property(nonatomic,strong)   UIView  *imagesView;

@property(nonatomic,strong)   UIView  *bottomLine;

@property(nonatomic,strong)   UIButton *shareBtn;

@property (nonatomic, weak) id<ABFChatHeaderImageDelegate> delegate;

@end
