//
//  ABFCommentView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/25.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABFCommentDelegate <NSObject>

@optional

-(void) commentClick:(id) sender;
-(void) goodClick:(id) sender;
-(void) jibaoClick:(id) sender;

@end

@interface ABFCommentView : UIView

@property(nonatomic,weak) id<ABFCommentDelegate> delegate;

@property(nonatomic,strong) UILabel *commentNumLab;

@property(nonatomic,strong) UIButton *dingBtn;

@property(nonatomic,strong) UIButton *jibaoBtn;

@end
