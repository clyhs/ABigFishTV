//
//  ABFChatToolBar.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/26.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABFChatToolBar;
@protocol ABFChatToolBarDelegate <NSObject>

@optional
- (void)chatToolBar:(ABFChatToolBar *)toolBar didClickBtn:(NSInteger)index;

@end

@interface ABFChatToolBar : UIView

@property (nonatomic, weak) id<ABFChatToolBarDelegate> delegate;

@end
