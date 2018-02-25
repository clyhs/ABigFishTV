//
//  ABFChatHeaderSectionView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/25.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABFChatHeaderSectionView : UIView

@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UILabel *goodLab;

@property(nonatomic,strong) UIView  *bottomLine;
@property (nonatomic, weak) UIView  *leftLineView;

@end
