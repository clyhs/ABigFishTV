//
//  ABFCommentViewCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/7.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFCommentViewCell.h"
#import "ABFCommentInfo.h"

@implementation ABFCommentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //定义CELL单元格内容
        [self setUsernameLabUI];
        [self setProfileUI];
        [self setTimeLabUI];
        [self setContextLabUI];
        [self setLineUI];
        [self setReplyViewUI];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setUsernameLabUI];
        [self setProfileUI];
        [self setTimeLabUI];
        [self setContextLabUI];
        [self setLineUI];
        [self setReplyViewUI];
        [self setReplyToolView];
        [self setGoodToolView];
    }
    
    return self;
    
}

-(void)setUsernameLabUI{
    
    _usernameLab = [[UILabel alloc] init];
    _usernameLab.font = [UIFont systemFontOfSize:16];
    _usernameLab.textAlignment =NSTextAlignmentLeft;
    _usernameLab.textColor = [UIColor darkGrayColor];
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

-(void)setTimeLabUI{
    _timeLab = [[UILabel alloc] init];
    _timeLab.font = [UIFont systemFontOfSize:14];
    _timeLab.textAlignment =NSTextAlignmentLeft;
    _timeLab.textColor = [UIColor lightGrayColor];
    [self addSubview:_timeLab];
}

-(void)setContextLabUI{
    
    _contextLab = [[UILabel alloc] init];
    _contextLab.font = [UIFont systemFontOfSize:16];
    _contextLab.textColor = [UIColor darkGrayColor];
    _contextLab.numberOfLines = 0;
    
    [self addSubview:_contextLab];
}

-(void)setReplyViewUI{

    _replyView = [[UIView alloc] init];
    _replyView.backgroundColor = RGB_255(243, 243, 243);
    [self addSubview:_replyView];
}

-(void)setReplyToolView{

    _replyToolView = [[UIView alloc] init];
    //_replyToolView.backgroundColor = RGB_255(250, 250, 250);
    [self addSubview:_replyToolView];
    
    _replyImgView = [[UIImageView alloc] init];
    _replyImgView.image = [UIImage imageNamed:@"btn_comment"];
    [self.replyToolView addSubview:_replyImgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTouchButton:)];
    _replyToolView.tag = 101;
    [_replyToolView addGestureRecognizer:tap];
}

-(void)setGoodToolView{
    _goodToolView = [[UIView alloc] init];
    //_goodToolView.backgroundColor = RGB_255(250, 250, 250);
    [self addSubview:_goodToolView];
    
    _goodImgView = [[UIImageView alloc] init];
    _goodImgView.image = [UIImage imageNamed:@"btn_good"];
    [self.goodToolView addSubview:_goodImgView];
    
    _goodLab = [[UILabel alloc] init];
    _goodLab.font = [UIFont systemFontOfSize:14];
    _goodLab.textColor = [UIColor lightGrayColor];
    _goodLab.textAlignment = NSTextAlignmentLeft;
    _goodLab.text = @"0";
    [self addSubview:_goodLab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTouchButton:)];
    _goodToolView.tag = 102;
    [_goodToolView addGestureRecognizer:tap];
    
}

-(void) setLineUI{
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = RGB_255(243, 243, 243);
    
    [self addSubview:_lineView];
}

-(void)setModel:(ABFCommentInfo *)model{
    _model = model;
    _usernameLab.text = model.username;
    [_profile sd_setImageWithURL:[NSURL URLWithString:model.profile] placeholderImage:[UIImage imageNamed:@""]];
    _timeLab.text = model.create_at;
    //_contextLab.text = [_model.context stringByReplacingEmojiCheatCodesWithUnicode];
    //[UILabel changeSpaceForLabel:_contextLab withLineSpace:5 WordSpace:3];
    CGFloat labelWidth = kScreenWidth-60;
    _contextLab.text =[_model.context stringByReplacingEmojiCheatCodesWithUnicode];
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

    
    NSArray *replys = [ABFCommentInfo mj_objectArrayWithKeyValuesArray:model.childs];
    NSInteger replyCount = replys.count;
    CGFloat nHeight = 0;
    //UITapGestureRecognizer *tap = nil;
    //UIView *labelView = nil;
    for(NSInteger i=0;i<replyCount;i++){
        ABFCommentInfo *reply = replys[i];
        
        NSString *str = [reply.replayname stringByAppendingString:@":"];
        if(reply.username !=nil){
            str = [str stringByAppendingFormat:@"@%@:",reply.username];
        }

        CGFloat height = [UILabel getHeightByWidthForSpace:labelWidth-10 string:[str stringByAppendingString:reply.context] font:[UIFont systemFontOfSize:16] withLineSpace:5 WordSpace:2];
        
        UILabel *content = [[UILabel alloc] init];
        content.text =[str stringByAppendingString:reply.context] ;
        content.font = [UIFont systemFontOfSize:16];
        content.numberOfLines = 0;
        content.textColor = [UIColor darkGrayColor];
        
        content.frame = CGRectMake(5, nHeight+5, labelWidth-8, height);
        nHeight = nHeight + height;
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[str stringByAppendingString:[reply.context stringByReplacingEmojiCheatCodesWithUnicode]] attributes:@{NSKernAttributeName:@2}];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.headIndent = 0;//缩进
        style.firstLineHeadIndent = 0;
        style.lineSpacing = 5;//行距
        [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
        NSInteger usernameCount = str.length;
        [text addAttribute:NSForegroundColorAttributeName value:COMMON_COLOR range:NSMakeRange(0, usernameCount)];
        content.attributedText = text;
        [content sizeToFit];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTouchReplyButton:)];
        content.tag = i;
        content.userInteractionEnabled = YES;
        [content addGestureRecognizer:tap];
        
        [self.replyView addSubview:content];
    }

    
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_usernameLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(60);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [_profile mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    
    
    [_replyToolView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.timeLab.mas_right).offset(10);
        make.centerY.equalTo(self.timeLab).offset(0);
        make.width.height.mas_equalTo(40);
    }];
    [_replyImgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.replyToolView).offset(10);
        make.centerY.equalTo(self.replyToolView);
        make.width.height.mas_equalTo(22);
    }];
    
    [_goodToolView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self).offset(-30);
        //make.top.equalTo(self).offset(0);
        make.centerY.equalTo(self.usernameLab);
        make.width.height.mas_equalTo(40);
    }];
    
    [_goodImgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.goodToolView).offset(10);
        make.top.equalTo(self.goodToolView).offset(9);
        make.width.height.mas_equalTo(18);
    }];
    
    [_goodLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.goodToolView).offset(30);
        make.centerY.equalTo(self.self.usernameLab);
        make.width.height.mas_equalTo(30);
    }];
    
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [_contextLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(60);
        make.top.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(self.model.contextHeight);
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(60);
        make.top.equalTo(self.contextLab.mas_bottom).offset(10);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(20);
    }];
    
    [_replyView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(60);
        make.top.equalTo(self).offset(60+self.model.contextHeight+25);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(self.model.replyHeight);
    }];
    
    
}

-(void)OnTouchButton:(id)sender{
    
    NSLog(@"touch");
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    
    UIView *view = (UIView *)tap.view;
    
    self.isGood = !self.isGood;
    NSLog(@"%d",self.isGood);
    if(self.isGood && view.tag == 102){
        _goodImgView.image = [UIImage imageNamed:@"btn_redgood"];
    }else{
        _goodImgView.image = [UIImage imageNamed:@"btn_good"];
    }
    
    if ([self.delegate respondsToSelector:@selector(pushForButton:index:)]) {
        [self.delegate pushForButton:self.model index:view.tag];
    }
}

-(void)OnTouchReplyButton:(id)sender{
    
    NSLog(@"touch");
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    
    UIView *view = (UIView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(pushForReplyButton:index:)]) {
        [self.delegate pushForReplyButton:self.model index:view.tag];
    }
}

@end
