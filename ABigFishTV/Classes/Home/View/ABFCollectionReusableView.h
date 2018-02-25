//
//  ABFCollectionReusableView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/22.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABFCollectionReusableView : UICollectionReusableView

@property(nonatomic,strong) NSString *title;

@property (nonatomic, weak) UIButton *moreBtn;

@end
