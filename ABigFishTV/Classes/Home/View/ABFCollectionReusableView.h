//
//  ABFCollectionReusableView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/22.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABFCollectionReusableViewDelegate <NSObject>
- (void)pushReusableView:(NSString *)name url:(NSString *)url;
@end

@interface ABFCollectionReusableView : UICollectionReusableView

@property(nonatomic,weak) id<ABFCollectionReusableViewDelegate> delegate;

@property(nonatomic,strong) NSString *title;

@property(nonatomic,strong) NSString *url;

@property (nonatomic, weak) UIButton *moreBtn;

@end
