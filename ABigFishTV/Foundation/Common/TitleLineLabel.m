//
//  TitleLineLabel.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/9/27.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "TitleLineLabel.h"

@implementation TitleLineLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize insets=_insets;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont fontWithName:FONTNAME size:16];
        self.textColor = [UIColor grayColor];
        self.scale = 0.0;
        [self setBottomLine];
        [self setIconView];
        _bottomLine.hidden = YES;
        
    }
    return self;
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    //NSLog(@"scale=%f",_scale);
    self.textColor = RGB_255(_scale*23,_scale*158,_scale*246);
    CGFloat minScale = 1.0;
    CGFloat trueScale = minScale + (1-minScale)*scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

- (void)setIconView{
    
    UIImageView *iconView = [[UIImageView alloc] init];
    //_iconView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    iconView.hidden = YES;
    [self addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.equalTo(self).offset(12);
        make.width.height.mas_equalTo(24);
    }];
    
    _iconView = iconView;
    

}

-(void)setIconViewImage:(NSString *)imageName{
    _iconView.image = [UIImage imageNamed:imageName];
    _iconView.hidden = NO;
}

- (void)setBottomLine{

    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = COMMON_COLOR;
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@2);
    }];
    _bottomLine = bottomLine;
}

-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end
