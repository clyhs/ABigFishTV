//
//  ABFCommentTFView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/25.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFCommentTFView.h"

@implementation ABFCommentTFView

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
        [self addTextField];
        [self addDoBtn];
    }
    
    return self;
}


-(void) addLineView{
    
    UIView *clineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    clineView.backgroundColor = LINE_BG;
    [self addSubview:clineView];
}

-(void) addTextField{
    
    BRPlaceholderTextView *inputTextField = [[BRPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 50) ];
    inputTextField.layer.cornerRadius = 3.0;
    inputTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    inputTextField.layer.borderWidth = 0.8f;
    inputTextField.placeholder= @"发表评论";
    inputTextField.maxTextLength = 90;
    [inputTextField setPlaceholderColor:[UIColor lightGrayColor]];
    [inputTextField setPlaceholderOpacity:1];
    [self addSubview:inputTextField];
    inputTextField.backgroundColor=[UIColor whiteColor];
    _inputTextField = inputTextField;
    
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentLeft;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _textNumberLabel.backgroundColor = [UIColor clearColor];
    _textNumberLabel.text = [NSString stringWithFormat:@"0/%d    ",90];
    _textNumberLabel.frame = CGRectMake(10, 65, 100, 15);
    [self addSubview:_textNumberLabel];
    
}

-(void) addDoBtn{
    
    UIButton *doBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    doBtn.frame = CGRectMake(kScreenWidth-60, 55, 50, 50);
    //doBtn.layer.cornerRadius = 4.0;
    //doBtn.layer.borderWidth = 0.8f;
    //doBtn.layer.borderColor = RGB_255(23, 158, 246).CGColor;
    //doBtn.backgroundColor = RGB_255(23, 158, 246);
    //[doBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    [doBtn setBackgroundImage:[UIImage imageNamed:@"btn_submit"] forState:UIControlStateNormal];
    doBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //doBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [doBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doBtn addTarget:self action:@selector(onSubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doBtn];
    
}

-(void) onSubmitClick:(id) sender{
    UIButton *dingBtn = (UIButton *)sender;
    dingBtn.selected = !dingBtn.selected;
    if ([self.delegate respondsToSelector:@selector(submitClick:)]) {
        [self.delegate submitClick:sender];
    }
    
}
@end
