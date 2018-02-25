//
//  LMLoadingView.h
//  拉面视频Demo
//
//  Created by 李小南 on 2016/10/12.
//  Copyright © 2016年 lamiantv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LMLoadingViewDelegate <NSObject>

/** 返回按钮被点击 */
- (void)loadingViewBackButtonClick;
/** 分享按钮被点击 */
- (void)loadingViewShareButtonClick;
@end

@interface LMLoadingView : UIView
@property (nonatomic, weak) id<LMLoadingViewDelegate> delegate;
@end
