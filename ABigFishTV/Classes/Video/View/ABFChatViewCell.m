//
//  ABFChatViewCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/11.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFChatViewCell.h"
#import "ABFChatInfo.h"
#import "ABFInfo.h"
#import "MyLayout.h"
#import <YYText.h>


@implementation ABFChatViewCell

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
        //self.backgroundColor = [UIColor yellowColor];
        [self setTopViewUI];
        [self setContextViewUI];
        [self setImagesViewUI];
        [self setToolViewUI];
        [self addBottomLine];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setTopViewUI];
        [self setContextViewUI];
        [self setImagesViewUI];
        [self setToolViewUI];
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
    
    _guangzhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _guangzhuBtn.backgroundColor = COMMON_COLOR;
    [_guangzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
    [_guangzhuBtn setTitle:@"已关注" forState:UIControlStateSelected];
    
    [_guangzhuBtn setTintColor:[UIColor whiteColor]];
    _guangzhuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _guangzhuBtn.layer.cornerRadius = 4;
    _guangzhuBtn.layer.masksToBounds = YES;
    _guangzhuBtn.layer.borderWidth = 0;
    _guangzhuBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0,0, 0);
    [_guangzhuBtn addTarget:self action:@selector(guangzhuClick:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self.topView addSubview:_guangzhuBtn];
    

}

-(void)setContextViewUI{

    _contextView = [[UIView alloc] init];
    
    [self addSubview:_contextView];
    //_contextView.backgroundColor = [UIColor yellowColor];
    _contextLab = [[UILabel alloc] init];
    _contextLab.font = [UIFont systemFontOfSize:16];
    //_contextLab.backgroundColor = [UIColor yellowColor];
    _contextLab.textColor = [UIColor darkGrayColor];
    _contextLab.numberOfLines = 0;
    [self.contextView addSubview:_contextLab];
}

-(void)setImagesViewUI{
    
    _imagesView = [[UIView alloc] init];
    _imagesView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imagesView];

}

-(void)setToolViewUI{
    _toolView = [[UIView alloc] init];
    _toolView.backgroundColor = [UIColor whiteColor];
    _toolView.opaque = YES;
    [self addSubview:_toolView];
    //CGFloat width = kScreenWidth/3;
    
    _zfView = [[UIView alloc] init];
    _zfView.opaque = YES;
    [self.toolView addSubview:_zfView];
    _zfImgView = [[UIImageView alloc] init];
    _zfImgView.image = [UIImage imageNamed:@"btn_zf"];
    [self.zfView addSubview:_zfImgView];
    
    _goodView = [[UIView alloc] init];
    _goodView.opaque = YES;
    [self.toolView addSubview:_goodView];
    _goodImgView = [[UIImageView alloc] init];
    _goodImgView.image = [UIImage imageNamed:@"btn_good"];
    [self.goodView addSubview:_goodImgView];
    _goodLab = [[UILabel alloc] init];
    _goodLab.font = [UIFont systemFontOfSize:16];
    _goodLab.textColor = [UIColor lightGrayColor];
    _goodLab.text = @"32";
    _goodLab.textAlignment = NSTextAlignmentLeft;
    [self.goodView addSubview:_goodLab];
    
    
    _commentView = [[UIView alloc] init];
    _commentView.opaque = YES;
    [self.toolView addSubview:_commentView];
    _commentImgView = [[UIImageView alloc] init];
    _commentImgView.image = [UIImage imageNamed:@"btn_comment"];
    [self.commentView addSubview:_commentImgView];
    _commentLab = [[UILabel alloc] init];
    _commentLab.font = [UIFont systemFontOfSize:16];
    _commentLab.textColor = [UIColor lightGrayColor];
    //_commentLab.text = @"12";
    _commentLab.textAlignment = NSTextAlignmentLeft;
    [self.commentView addSubview:_commentLab];
    
    
    _toolLine = [[UIView alloc] init];
    _toolLine.backgroundColor = LINE_BG;
    [self.toolView addSubview:_toolLine];
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

    
    CGFloat labelWidth = kScreenWidth-60;
    
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[_model.context stringByReplacingEmojiCheatCodesWithUnicode]];
    attString.yy_font = [UIFont systemFontOfSize:16];
    attString.yy_lineSpacing =5;
    attString.yy_kern = @0;
    //attributedString.yy_lineBreakMode = NSLineBreakByWordWrapping;
    YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
    modifier.fixedLineHeight = 20;
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(labelWidth, CGFLOAT_MAX);
    container.linePositionModifier = modifier;
    YYTextLayout *attlayout = [YYTextLayout layoutWithContainer:container text:attString];
    YYLabel *attlabel = [YYLabel new];
    attlabel.size = attlayout.textBoundingSize;
    attlabel.textLayout = attlayout;
    //[label sizeToFit];
    CGFloat attheight = attlabel.size.height;
    
    _contextLab.text =[_model.context stringByReplacingEmojiCheatCodesWithUnicode];
    _contextLab.font = [UIFont systemFontOfSize:16];
    _contextLab.numberOfLines = 0;
    _contextLab.textColor = [UIColor darkGrayColor];
    
    
    
    [_contextView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(60);
        make.top.equalTo(self).offset(60);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(attheight);
    }];
    
    [_contextLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.contextView).offset(0);
        make.top.equalTo(self.contextView).offset(0);
        make.right.equalTo(self.contextView.mas_right).offset(-5);
        make.height.equalTo(self.contextView);
    }];
    
    [_imagesView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(55);
        make.top.equalTo(self).offset(60+attheight);
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
    NSInteger len = [images count];
    CGFloat spession = 0;
    if(len == 1){
        spession =((kScreenWidth-60)*2/3-10);
    }else{
        spession = ((kScreenWidth-60)/3-10);
    }
    CGFloat width = spession;
    CGFloat height = width;
    int i = 0;
    for (ABFInfo *info in images) {
        UIView *imgView = [[UIView alloc] initWithFrame:CGRectMake(width*i, 0, width, height)];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.mySize = CGSizeMake(width,height);
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = 4;
        imgView.layer.borderColor = [UIColor whiteColor].CGColor;
        imgView.layer.borderWidth = 0.0f;
        
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
    _commentLab.text = [NSString stringWithFormat:@"%ld",model.comment_num];
    _goodLab.text = model.goodNum;
    
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(60+model.contextHeight+model.imagesHeight);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(40);
    }];
    
    [_zfView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.toolView).offset(0);
        make.top.equalTo(self.toolView).offset(0);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(40);
    }];
    [_zfImgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.zfView).offset(kScreenWidth/6-10);
        make.top.equalTo(self.zfView).offset(14);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = LINE_BG;
    [_commentView addSubview:leftLine];
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = LINE_BG;
    [_commentView addSubview:rightLine];
    
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.toolView).offset(kScreenWidth/3);
        make.top.equalTo(self.toolView).offset(0);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(40);
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.commentView).offset(0);
        make.top.equalTo(self.commentView).offset(8);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(self.commentView).offset(-2);
    }];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.commentView).offset(0);
        make.top.equalTo(self.commentView).offset(8);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(self.commentView).offset(-2);
    }];
    [_commentImgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.commentView).offset(kScreenWidth/6-12);
        make.top.equalTo(self.commentView).offset(12);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
    [_commentLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.commentView).offset(kScreenWidth/6+10+5);
        make.top.equalTo(self.commentView).offset(12);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(24);
    }];
    
    [_goodView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.toolView).offset(kScreenWidth/3*2);
        make.top.equalTo(self.toolView).offset(0);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(40);
    }];
    [_goodImgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.goodView).offset(kScreenWidth/6-14);
        make.top.equalTo(self.goodView).offset(13);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    [_goodLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.goodView).offset(kScreenWidth/6+10+5);
        make.top.equalTo(self.goodView).offset(12);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(24);
    }];
    
    /*
    [_zfBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.toolView).offset(0);
        make.top.equalTo(self.toolView).offset(10);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(22);
    }];
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.toolView).offset(kScreenWidth/3);
        make.top.equalTo(self.toolView).offset(10);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(22);
    }];
    [_goodBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.toolView).offset(kScreenWidth*2/3);
        make.top.equalTo(self.toolView).offset(9);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(22);
    }];*/
    [_toolLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.toolView).offset(0);
        make.top.equalTo(self.toolView).offset(0);
        make.width.mas_equalTo(self.toolView);
        make.height.mas_equalTo(0.6);
    }];

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
    [_guangzhuBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.topView).offset(-10);
        make.top.equalTo(self.topView).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(23);
    }];
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

-(void)guangzhuClick:(id)sender{
    UIButton *gzbtn = (UIButton *)sender;
    gzbtn.selected=!gzbtn.selected;
    if(gzbtn.selected){
        gzbtn.backgroundColor = [UIColor lightGrayColor];
    }else{
        gzbtn.backgroundColor = COMMON_COLOR;
    }
    if([self.delegate respondsToSelector:@selector(guangzhu:)]){
        [self.delegate guangzhu:self.model];
    }
}

@end
