//
//  ABFCommentTFView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/25.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRPlaceholderTextView.h"

@protocol ABFCommentTFDelegate <NSObject>

@optional

-(void) submitClick:(id) sender;

@end

@interface ABFCommentTFView : UIView

@property(nonatomic,weak) BRPlaceholderTextView *inputTextField;
//文字个数提示label
@property (nonatomic, strong) UILabel *textNumberLabel;

@property(nonatomic,weak) id<ABFCommentTFDelegate> delegate;

@end
