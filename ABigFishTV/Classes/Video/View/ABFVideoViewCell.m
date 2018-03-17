//
//  ABFVideoViewCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/11.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFVideoViewCell.h"
#import "ABFVideoInfo.h"

@implementation ABFVideoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setTitleLabUI];
        [self setCoverBgView];
        [self setCoverViewUI];
        [self setPlayImage];
        [self setUsernameLabUI];
        [self setProfileUI];
        [self setBottomLineUI];
    }
    
    return self;
}

-(void)setTitleLabUI{
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont systemFontOfSize:16];
    _titleLab.textColor = [UIColor darkGrayColor];
    _titleLab.numberOfLines = 0;
    [self addSubview:_titleLab];
    
    
}

-(void)setCoverBgView{

    _coverBgView = [[UIView alloc] init];
    //_coverView.alpha = 0.1;
    _coverBgView.backgroundColor = [UIColor blackColor];
    _coverBgView.layer.borderWidth = 1.0f;
    _coverBgView.layer.borderColor = LINE_BG.CGColor;
    _coverBgView.layer.masksToBounds = YES;
    _coverBgView.layer.cornerRadius = 4;
    [self addSubview:_coverBgView];
}

-(void)setCoverViewUI{
    
    _coverView = [[UIImageView alloc] init];
    _coverView.alpha = 0.8;
    [self.coverBgView addSubview:_coverView];
    //_coverView.frame = _coverBgView.bounds;
    
}

-(void)setPlayImage{
    _playImage =[[UIImageView alloc] init];
    [self.coverView addSubview:_playImage];
    [_playImage setImage:[UIImage imageNamed:@"btn_player"]];
}

-(void)setUsernameLabUI{
    
    _usernameLab = [[UILabel alloc] init];
    _usernameLab.font = [UIFont systemFontOfSize:16];
    _usernameLab.textColor = [UIColor darkGrayColor];
    _usernameLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_usernameLab];
    
}

-(void)setProfileUI{
    
    _profile = [[UIImageView alloc] init];
    _profile.layer.masksToBounds = YES;
    _profile.layer.cornerRadius = 20;
    _profile.layer.borderWidth = 2.0;
    _profile.layer.borderColor = [UIColor whiteColor].CGColor;
    //[userImg sd_setImageWithURL:_commentInfo.user.img placeholderImage:[UIImage imageNamed:@""]];
    [self addSubview:_profile];
    
}

- (void)setBottomLineUI{
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = LINE_BG;
    [self addSubview:bottomLine];
    _bottomLine = bottomLine;
    
}

-(void)setModel:(ABFVideoInfo *)model{
    
    _model = model;
    _usernameLab.text = model.username;
    [_profile sd_setImageWithURL:[NSURL URLWithString:model.profile] placeholderImage:[UIImage imageNamed:@""]];
    
    _titleLab.text = model.title;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_model.title];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 0;//缩进
    style.firstLineHeadIndent = 0;
    style.lineSpacing = 6;//行距
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    _titleLab.attributedText = text;
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(model.titleHeight);
    }];
    
    
    
    [_coverBgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.titleLab.mas_left).offset(0);
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(kScreenWidth * 9/16);
    }];
    
    
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.width.height.equalTo(self.coverBgView);
    }];
    
    [_playImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self.coverView);
        make.height.width.mas_equalTo(64);
    }];
    
    [_coverView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@""]];
    
    
    [_usernameLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.titleLab.mas_left).offset(50);
        make.top.equalTo(self.coverBgView.mas_bottom).offset(15);
        //make.right.equalTo(self.titleLab.mas_right).offset(0);
        make.width.mas_offset(kScreenWidth/3-50);
        make.height.mas_equalTo(20);
    }];
    
    [_profile mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.titleLab.mas_left).offset(0);
        make.top.equalTo(self.coverBgView.mas_bottom).offset(5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    _goodView = [[UIView alloc] init];
    _goodView.opaque = YES;
    [self addSubview:_goodView];
    _goodImgView = [[UIImageView alloc] init];
    _goodImgView.image = [UIImage imageNamed:@"btn_good"];
    [self.goodView addSubview:_goodImgView];
    _goodLab = [[UILabel alloc] init];
    _goodLab.font = [UIFont systemFontOfSize:16];
    _goodLab.textColor = [UIColor lightGrayColor];
    _goodLab.text = model.goodNum;
    _goodLab.textAlignment = NSTextAlignmentLeft;
    [self.goodView addSubview:_goodLab];
    
    
    _commentView = [[UIView alloc] init];
    _commentView.opaque = YES;
    //_commentView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_commentView];
    _commentImgView = [[UIImageView alloc] init];
    _commentImgView.image = [UIImage imageNamed:@"btn_comment"];
    [self.commentView addSubview:_commentImgView];
    _commentLab = [[UILabel alloc] init];
    _commentLab.font = [UIFont systemFontOfSize:16];
    _commentLab.textColor = [UIColor lightGrayColor];
    _commentLab.text = [NSString stringWithFormat:@"%ld",model.comment_num];
    _commentLab.textAlignment = NSTextAlignmentLeft;
    [self.commentView addSubview:_commentLab];

}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    /*
    
    [_usernameLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(60);
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(50);
        make.height.mas_equalTo(20);
    }];*/
    
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.usernameLab.mas_right).offset(0);
        make.top.equalTo(self.coverBgView.mas_bottom).offset(6);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(40);
    }];
    [_commentImgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.commentView).offset(kScreenWidth/6-12);
        make.top.equalTo(self.commentView).offset(8);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    [_commentLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.commentView).offset(kScreenWidth/6+10+8);
        make.top.equalTo(self.commentView).offset(11);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    [_goodView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.commentView.mas_right).offset(0);
        make.top.equalTo(self.coverBgView.mas_bottom).offset(6);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(40);
    }];
    [_goodImgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.goodView).offset(kScreenWidth/6-18);
        make.top.equalTo(self.goodView).offset(9);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    [_goodLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.goodView).offset(kScreenWidth/6+8);
        make.top.equalTo(self.goodView).offset(12);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(5);
    }];
}

@end
