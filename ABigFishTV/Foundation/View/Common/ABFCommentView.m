//
//  ABFCommentView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/25.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFCommentView.h"

@implementation ABFCommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = RGB_255(250, 250, 250);
        [self addLineView];
        [self addInputBtn];
        [self addCommentView];
        [self addGoodBtn];
        //[self addjibaoBtn];
    }
    
    return self;
}

-(void) addLineView{
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView.backgroundColor = LINE_BG;
    [self addSubview:lineView];
    
}

-(void) addInputBtn{
    
    UIButton *inputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    inputBtn.frame = CGRectMake(20, 10, 120, 25);
    
    inputBtn.backgroundColor = [UIColor whiteColor];
    inputBtn.layer.cornerRadius = 12.0;//2.0是圆角的弧度，根据需求自己更改
    inputBtn.layer.borderColor = RGB_255(204,204,204).CGColor;
    inputBtn.layer.borderWidth = 0.8f;//设置边框颜色
    [inputBtn setImage:[UIImage imageNamed:@"icon_pen"] forState:UIControlStateNormal];
    inputBtn.imageEdgeInsets = UIEdgeInsetsMake(1, 2, 1, 60);
    [inputBtn setTitle:@"写评论" forState:UIControlStateNormal];
    //button标题的偏移量，这个偏移量是相对于图片的
    inputBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    //设置button正常状态下的标题颜色
    [inputBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    inputBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [inputBtn addTarget:self action:@selector(onCommentClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:inputBtn];
    
}

-(void) addGoodBtn{
    UIButton *goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goodBtn.frame = CGRectMake(kScreenWidth-60, 2, 40, 40);
    goodBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [goodBtn setImage:[UIImage imageNamed:@"btn_good"] forState:UIControlStateNormal];
    [goodBtn setImage:[UIImage imageNamed:@"btn_redgood"] forState:UIControlStateSelected];
    [goodBtn addTarget:self action:@selector(onGoodClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:goodBtn];
    _dingBtn = goodBtn;
    
}

-(void)addjibaoBtn{
    UIButton *jiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jiBtn.frame = CGRectMake(kScreenWidth-150, 2, 40, 40);
    jiBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [jiBtn setImage:[UIImage imageNamed:@"btn_jibao"] forState:UIControlStateNormal];
    [jiBtn setImage:[UIImage imageNamed:@"btn_jibao"] forState:UIControlStateSelected];
    [jiBtn addTarget:self action:@selector(onJibaoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:jiBtn];
    _jibaoBtn = jiBtn;
}

-(void) addCommentView{
    UIView *commentView = [[UIView alloc] init];
    commentView.frame = CGRectMake(kScreenWidth-100, 0, 40, 40);
    
    UIImageView *commentImage = [[UIImageView alloc] init];
    commentImage.frame = CGRectMake(0, 12, 24, 24);
    commentImage.image = [UIImage imageNamed:@"icon_comment"];
    [commentView addSubview:commentImage];
    
    _commentNumLab = [[UILabel alloc] init];
    _commentNumLab.text = @"0";
    _commentNumLab.layer.masksToBounds = YES;
    _commentNumLab.layer.borderColor = [UIColor redColor].CGColor;
    _commentNumLab.layer.borderWidth = 0.5;
    _commentNumLab.layer.cornerRadius = 8;
    _commentNumLab.textAlignment = NSTextAlignmentCenter;
    _commentNumLab.textColor = [UIColor whiteColor];
    _commentNumLab.font = [UIFont systemFontOfSize:12];
    _commentNumLab.backgroundColor = [UIColor redColor];
    _commentNumLab.frame = CGRectMake(16, 7, 20, 16);
    [commentView addSubview:_commentNumLab];
    
    
    [self addSubview:commentView];
    
}

-(void) onGoodClick:(id) sender{
    UIButton *dingBtn = (UIButton *)sender;
    dingBtn.selected = !dingBtn.selected;
    if ([self.delegate respondsToSelector:@selector(goodClick:)]) {
        [self.delegate goodClick:sender];
    }
    
}

-(void) onJibaoClick:(id) sender{
    UIButton *dingBtn = (UIButton *)sender;
    dingBtn.selected = !dingBtn.selected;
    if ([self.delegate respondsToSelector:@selector(jibaoClick:)]) {
        [self.delegate jibaoClick:sender];
    }
    
}

-(void) onCommentClick:(id) sender{
    NSLog(@"pinglun");
    if ([self.delegate respondsToSelector:@selector(commentClick:)]) {
        [self.delegate commentClick:sender];
    }
    
}

@end
