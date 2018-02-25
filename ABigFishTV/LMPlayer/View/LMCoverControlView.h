//
//  LMCoverView.h
//  拉面视频Demo
//
//  Created by 李小南 on 16/9/26.
//  Copyright © 2016年 lamiantv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LMCoverControlViewDelegate <NSObject>

/** 返回按钮被点击 */
- (void)coverControlViewBackButtonClick;
/** 分享按钮被点击 */
- (void)coverControlViewShareButtonClick;

//- (void)cutImageButtonClick;
/** 封面图片Tap事件 */
- (void)coverControlViewBackgroundImageViewTapAction;
@end

@interface LMCoverControlView : UIView
@property (nonatomic, weak) id<LMCoverControlViewDelegate> delegate;
/** 更新封面图片 */
- (void)syncCoverImageViewWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage;
@end
