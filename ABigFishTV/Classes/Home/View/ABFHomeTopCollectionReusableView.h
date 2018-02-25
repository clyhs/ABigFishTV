//
//  ABFHomeTopCollectionReusableView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/13.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABFHomeTopCollectionReusableView : UICollectionReusableView

@property(nonatomic,strong) UIView *topView;

@property(nonatomic,strong) UIView *botView;

@property(nonatomic,strong) UIView *adView;

@property(nonatomic,strong) NSString *title;

@property (nonatomic, weak) UIButton *moreBtn;

@end
