//
//  ABFPlayerControlViewDelegate.h
//  ABigFishPlayer
//
//  Created by 陈立宇 on 2018/3/24.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#ifndef ABFPlayerControlViewDelegate_h
#define ABFPlayerControlViewDelegate_h

@protocol ABFPlayerControlViewDelegate <NSObject>

@optional
/** 播放按钮事件 */
- (void)abf_controlView:(UIView *)controlView playAction:(UIButton *)sender;
/** 全屏按钮事件 */
- (void)abf_controlView:(UIView *)controlView fullScreenAction:(UIButton *)sender;
/**  返回按钮事件 */
- (void)abf_controlView:(UIView *)controlView backAction:(UIButton *)sender;
/**  cell播放中小屏状态 关闭按钮事件 */
- (void)abf_controlView:(UIView *)controlView closeAction:(UIButton *)sender;
/** 锁定屏幕方向按钮时间 */
- (void)abf_controlView:(UIView *)controlView lockScreenAction:(UIButton *)sender;
/** slider的点击事件（点击slider控制进度） */
- (void)abf_controlView:(UIView *)controlView progressSliderTap:(CGFloat)value;
/** 开始触摸slider */
- (void)abf_controlView:(UIView *)controlView progressSliderTouchBegan:(UISlider *)slider;
/** slider触摸中 */
- (void)abf_controlView:(UIView *)controlView progressSliderValueChanged:(UISlider *)slider;
/** slider触摸结束 */
- (void)abf_controlView:(UIView *)controlView progressSliderTouchEnded:(UISlider *)slider;
/** 加载失败按钮事件 */
- (void)abf_controlView:(UIView *)controlView failAction:(UIButton *)sender;
/** 重播按钮事件 */
- (void)abf_controlView:(UIView *)controlView repeatPlayAction:(UIButton *)sender;
/**播放源选择**/
- (void)abf_controlView:(UIView *)controlView menuAction:(UIButton *)sender;

- (void)abf_controlView:(UIView *)controlView menulabAction:(id)sender;
@end

#endif /* ABFPlayerControlViewDelegate_h */
