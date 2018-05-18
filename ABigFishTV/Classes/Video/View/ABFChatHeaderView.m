//
//  ABFChatHeaderView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/24.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFChatHeaderView.h"
#import "ABFChatInfo.h"
#import "ABFInfo.h"
#import "MyLayout.h"

@implementation ABFChatHeaderView

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
        self.backgroundColor = [UIColor whiteColor];
        [self setTopViewUI];
        //[self setShareBtn];
        [self setContextViewUI];
        [self setImagesViewUI];
        [self addBottomLine];
    }
    
    return self;
}

-(void)setTopViewUI{
    
    _topView = [[UIView alloc] init];
    [self addSubview:_topView];
    
    _profile = [[UIImageView alloc] init];
    _profile.layer.masksToBounds = YES;
    _profile.layer.cornerRadius = 20;
    _profile.layer.borderWidth = 2.0;
    _profile.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.topView addSubview:_profile];
    
    _usernameLab = [[UILabel alloc] init];
    _usernameLab.font = [UIFont systemFontOfSize:16];
    _usernameLab.textColor = [UIColor darkGrayColor];
    _usernameLab.textAlignment = NSTextAlignmentLeft;
    [self.topView addSubview:_usernameLab];
    
    _timeLab = [[UILabel alloc] init];
    _timeLab.font = [UIFont systemFontOfSize:14];
    _timeLab.textAlignment =NSTextAlignmentLeft;
    _timeLab.textColor = [UIColor lightGrayColor];
    [self.topView addSubview:_timeLab];
    
    
}


-(void)setContextViewUI{
    
    _contextView = [[UIView alloc] init];
    [self addSubview:_contextView];
    
    _contextLab = [[UILabel alloc] init];
    _contextLab.font = [UIFont systemFontOfSize:16];
    _contextLab.textColor = [UIColor darkGrayColor];
    _contextLab.numberOfLines = 0;
    [self.contextView addSubview:_contextLab];
}
-(void)setImagesViewUI{
    
    _imagesView = [[UIView alloc] init];
    _imagesView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imagesView];
    
}

-(void)setShareBtn{
    /*
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
    [_shareBtn setImage:[UIImage imageNamed:@"btn_lightshare"] forState:UIControlStateSelected];
    [_shareBtn addTarget:self action:@selector(shareClick:)
      forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareBtn];*/
}

-(void)addBottomLine{
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = LINE_BG;
    [self addSubview:_bottomLine];
}

-(void)setModel:(ABFChatInfo *)model{
    _model = model;
    _usernameLab.text = model.username;
    [_profile sd_setImageWithURL:[NSURL URLWithString:model.profile] placeholderImage:[UIImage imageNamed:@""]];
    _timeLab.text = model.create_at;
    NSString *str =[NSString stringWithFormat:@"%@",model.context];
    //_contextLab.text = model.context;
    _contextLab.text =[str stringByReplacingEmojiCheatCodesWithUnicode];
    _contextLab.font = [UIFont systemFontOfSize:16];
    _contextLab.numberOfLines = 0;
    _contextLab.textColor = [UIColor darkGrayColor];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_contextLab.text attributes:@{NSKernAttributeName:@3}];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 0;//缩进
    style.firstLineHeadIndent = 0;
    style.lineSpacing = 5;//行距
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    _contextLab.attributedText = text;
    [_contextLab sizeToFit];
    [_contextView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(60);
        make.top.equalTo(self).offset(60);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(model.contextHeight);
    }];
    [_contextLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.contextView).offset(0);
        make.top.equalTo(self.contextView).offset(0);
        make.right.equalTo(self.contextView.mas_right).offset(-5);
        make.height.equalTo(self.contextView);
    }];
    
    [_imagesView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(50);
        make.top.equalTo(self).offset(60+model.contextHeight);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(model.imagesHeight);
    }];
    
    MyFloatLayout *mylayout  = [MyFloatLayout floatLayoutWithOrientation:MyOrientation_Vert];
    mylayout.wrapContentHeight = YES;
    mylayout.myWidth = kScreenWidth;
    mylayout.myTop = 0;
    mylayout.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    mylayout.gravity = MyGravity_Horz_Fill;
    mylayout.subviewSpace = 5;
    
    NSArray *images = [ABFInfo mj_keyValuesArrayWithObjectArray:model.images];
    CGFloat width = ((kScreenWidth-60)/3-10);
    CGFloat height = width;
    int i = 0;
    for (ABFInfo *info in images) {
        UIView *imgView = [[UIView alloc] initWithFrame:CGRectMake(width*i, 0, width, height)];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.mySize = CGSizeMake(width,height);
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = 4;
        imgView.layer.borderColor = [UIColor whiteColor].CGColor;
        imgView.layer.borderWidth = 0.4f;
        
        UIImageView *img = [[UIImageView alloc] init];
        img.frame = imgView.bounds;
        [img sd_setImageWithURL:[NSURL URLWithString:info.url] placeholderImage:[UIImage imageNamed:@""]];
        [imgView addSubview:img];
        imgView.tag = 100+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTouchImage:)];
        [imgView addGestureRecognizer:tap];
        [mylayout addSubview:imgView];
        i++;
    }
    [self.imagesView addSubview:mylayout];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(50);
    }];
    
    [_usernameLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.topView).offset(60);
        make.top.equalTo(self.topView).offset(10);
        make.right.equalTo(self.topView).offset(50);
        make.height.mas_equalTo(20);
    }];
    
    [_profile mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.topView).offset(10);
        make.top.equalTo(self.topView).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.topView).offset(60);
        make.top.equalTo(self.topView).offset(35);
        make.right.equalTo(self.topView).offset(-5);
        make.height.mas_equalTo(20);
    }];
    /*
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.topView).offset(-5);
        make.top.equalTo(self.topView).offset(5);
        make.width.height.mas_equalTo(40);
    }];*/
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(5);
    }];
    
}

-(void)OnTouchImage:(id)sender{
    
    NSLog(@"touch");
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    
    UIView *view = (UIView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(pushForImage:imageIndex:)]) {
        [self.delegate pushForImage:self.model imageIndex:view.tag];
    }
}
/*
-(void)shareClick:(id)sender{

    if ([self.delegate respondsToSelector:@selector(shareAction)]) {
        [self.delegate shareAction];
    }
}*/


@end
