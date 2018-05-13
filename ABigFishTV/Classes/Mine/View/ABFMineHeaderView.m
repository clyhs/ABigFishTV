//
//  ABFMineHeaderView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/24.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFMineHeaderView.h"

@interface ABFMineHeaderView()

@property(nonatomic,weak) UIView   *messageView;
@property(nonatomic,weak) UIView   *likeView;
@property(nonatomic,weak) UIView   *historyView;
@property(nonatomic,strong) UIView *leftLineView;
@property(nonatomic,strong) UIView *rightLineView;

@property(nonatomic,strong) UILabel *messageLab;
@property(nonatomic,strong) UILabel *likeLab;
@property(nonatomic,strong) UILabel *historyLab;

@property(nonatomic,weak) UIImageView   *miView;
@property(nonatomic,weak) UIImageView   *liView;
@property(nonatomic,weak) UIImageView   *hiView;

@end

@implementation ABFMineHeaderView

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
        
        //self.backgroundColor = COMMON_COLOR;
        [self addTopView];
    
        [self addProfile];
        
        [self addUsernameLabel];
        
        [self addDescLabel];
        
        [self addBotView];
        
        [self setMenuUI];
        
        [self setLineView];
        
        [self addSettingBtn];
    }
    
    return self;
}

-(void)addTopView{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = COMMON_COLOR;
    [self addSubview:topView];
    _topView = topView;
}

-(void)addProfile{
    
    UIImageView *profile = [[UIImageView alloc] init];
    profile.backgroundColor = LINE_BG;
    profile.layer.borderWidth = 2.0f;
    profile.layer.borderColor = LINE_BG.CGColor;
    profile.layer.masksToBounds = YES;
    profile.layer.cornerRadius = 75*0.5;
    UIImage *img = [UIImage imageNamed:@"profile"];
    [profile setImage:img];
    [self.topView addSubview:profile];
    _profile = profile;

}

-(void)addUsernameLabel{
    
    UILabel *usernameLabel = [[UILabel alloc] init];
    usernameLabel.font = [UIFont systemFontOfSize:18];
    usernameLabel.textColor = [UIColor whiteColor];
    usernameLabel.textAlignment = NSTextAlignmentLeft;
    usernameLabel.text=@"未登陆";
    [self.topView addSubview:usernameLabel];
    _username = usernameLabel;

}

-(void)addDescLabel{

    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textColor = [UIColor whiteColor];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.text=@"登录特权：关注，留言等";
    [self.topView addSubview:descLabel];
    _descLabel = descLabel;
}

-(void)addBotView{
    UIView *botView = [[UIView alloc] init];
    botView.backgroundColor = [UIColor whiteColor];
    [self addSubview:botView];
    _botView = botView;
}

-(void)addSettingBtn{
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //settingBtn.hidden = YES;
    settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setImage:[UIImage imageNamed:@"btn_setting"] forState:UIControlStateNormal];
    settingBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [settingBtn addTarget:self action:@selector(settingClick:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:settingBtn];
    _settingBtn =settingBtn;
    _settingBtn.hidden = YES;

}

-(void)setMenuUI{
    
    UIView *messageView = [[UIView alloc] init];
    [self.botView addSubview:messageView];
    _messageView = messageView;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapMenu:)];
    messageView.tag = 101;
    [messageView addGestureRecognizer:tap1];
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.font = [UIFont systemFontOfSize:16];
    messageLabel.textColor = [UIColor darkGrayColor];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.text=@"消息";
    [self.messageView addSubview:messageLabel];
    _messageLab = messageLabel;
    /*
    UILabel *messageTLabel = [[UILabel alloc] init];
    messageTLabel.font = [UIFont systemFontOfSize:14];
    messageTLabel.textColor = [UIColor darkGrayColor];
    messageTLabel.textAlignment = NSTextAlignmentLeft;
    messageTLabel.text=@"0";
    [self.messageView addSubview:messageTLabel];
    _messageTLab = messageTLabel;*/
    
    UIImageView *miView = [[UIImageView alloc] init];
    [miView setImage:[UIImage imageNamed:@"icon_mi"]];
    [self.messageView addSubview:miView];
    _miView = miView;
    
    
    UIView *likeView = [[UIView alloc] init];
    [self.botView addSubview:likeView];
    _likeView = likeView;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapMenu:)];
    likeView.tag = 102;
    [likeView addGestureRecognizer:tap2];
    UILabel *likeLabel = [[UILabel alloc] init];
    likeLabel.font = [UIFont systemFontOfSize:16];
    likeLabel.textColor = [UIColor darkGrayColor];
    likeLabel.textAlignment = NSTextAlignmentLeft;
    likeLabel.text=@"收藏";
    [self.likeView addSubview:likeLabel];
    _likeLab = likeLabel;
    /*
    UILabel *likeTLabel = [[UILabel alloc] init];
    likeTLabel.font = [UIFont systemFontOfSize:14];
    likeTLabel.textColor = [UIColor darkGrayColor];
    likeTLabel.textAlignment = NSTextAlignmentLeft;
    likeTLabel.text=@"0";
    [self.likeView addSubview:likeTLabel];
    _likeTLab = likeTLabel;*/
    
    UIImageView *liView = [[UIImageView alloc] init];
    [liView setImage:[UIImage imageNamed:@"icon_li"]];
    [self.likeView addSubview:liView];
    _liView = liView;
    
    UIView *historyView = [[UIView alloc] init];
    [self.botView addSubview:historyView];
    _historyView = historyView;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapMenu:)];
    historyView.tag = 103;
    [historyView addGestureRecognizer:tap3];
    UILabel *hLabel = [[UILabel alloc] init];
    hLabel.font = [UIFont systemFontOfSize:16];
    hLabel.textColor = [UIColor darkGrayColor];
    hLabel.textAlignment = NSTextAlignmentLeft;
    hLabel.text=@"历史";
    [self.historyView addSubview:hLabel];
    _historyLab = hLabel;
    /*
    UILabel *hTLabel = [[UILabel alloc] init];
    hTLabel.font = [UIFont systemFontOfSize:14];
    hTLabel.textColor = [UIColor darkGrayColor];
    hTLabel.textAlignment = NSTextAlignmentLeft;
    hTLabel.text=@"0";
    [self.historyView addSubview:hTLabel];
    _historyTLab = hTLabel;*/
    
    UIImageView *hiView = [[UIImageView alloc] init];
    [hiView setImage:[UIImage imageNamed:@"icon_hi"]];
    [self.historyView addSubview:hiView];
    _hiView = hiView;
    
}

-(void)setLineView{
    
    _leftLineView = [[UIView alloc] init];
    _leftLineView.backgroundColor =LINE_BG;
    
    _rightLineView = [[UIView alloc] init];
    _rightLineView.backgroundColor = LINE_BG;
    
    [self.likeView addSubview:_leftLineView];
    [self.likeView addSubview:_rightLineView];

}



-(void)OnTapMenu:(id)sender{
    //NSLog(@"tag:%ld",sender.view.tag);
    //UIView *v = (UIView *)sender;
    //NSLog(@"tag:%ld",v.tag);
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    
    UIView *view = (UIView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(pushVC:)]) {
        [self.delegate pushVC:view.tag];
    }
    
}

-(void)settingClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(settingVC:)]) {
        [self.delegate settingVC:sender];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height = kScreenWidth*2/3-10-60;
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.width.equalTo(self);
        make.height.mas_offset(height);
    }];
    
    [_profile mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.topView).offset(40);
        make.top.equalTo(self.topView).offset(height/3);
        make.width.height.equalTo(@75);
    }];
    
    [_username mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.topView).offset(125);
        make.top.equalTo(self.topView).offset(height/3+8);
        make.width.mas_equalTo(kScreenWidth-125-10);
        make.height.equalTo(@30);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.topView).offset(125);
        make.top.equalTo(self.topView).offset(height/3+40);
        make.width.equalTo(@180);
        make.height.equalTo(@20);
    }];
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.top.equalTo(self.topView).offset(15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [_botView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(kScreenWidth*2/3-5-60);
        make.width.equalTo(self);
        make.height.mas_offset(60);
    }];
    
    CGFloat width = kScreenWidth / 3;
    
    [_messageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.botView).offset(0);
        make.top.equalTo(self.botView).offset(0);
        make.right.equalTo(self.botView).offset(-width*2);
        make.height.equalTo(self.botView);
    }];
    
    [_likeView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.botView).offset(width);
        make.top.equalTo(self.botView).offset(0);
        make.width.mas_offset(width);
        make.height.equalTo(self.botView);
    }];
    
    [_leftLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.likeView).offset(0);
        make.top.equalTo(self.likeView).offset(4);
        make.width.mas_offset(0.3);
        make.bottom.equalTo(self.likeView).offset(-4);
    }];
    
    [_rightLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.likeView).offset(4);
        make.right.equalTo(self.likeView).offset(0);
        make.width.mas_offset(0.3);
        make.bottom.equalTo(self.likeView).offset(-4);
    }];
    
    [_historyView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.botView).offset(width*2);
        make.top.equalTo(self.botView).offset(0);
        make.right.equalTo(self.botView).offset(0);
        make.height.equalTo(self.botView);
    }];
    
    [_miView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.messageView).offset(width/2 - 25);
        make.top.equalTo(self.messageView).offset(20);
        make.width.height.mas_equalTo(23);
        
    }];
    
    [_messageLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.messageView).offset(width/2+2);
        make.top.equalTo(self.messageView).offset(20);
        make.right.equalTo(self.messageView).offset(0);
        make.height.equalTo(@24);
    }];
    
    [_liView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.likeView).offset(width/2 - 25);
        make.top.equalTo(self.likeView).offset(20);
        make.width.height.mas_equalTo(24);
        
    }];
    
    [_likeLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.likeView).offset(width/2+2);
        make.top.equalTo(self.likeView).offset(20);
        make.right.equalTo(self.likeView).offset(0);
        make.height.equalTo(@24);
    }];
    
    
    [_hiView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.historyView).offset(width/2 - 25);
        make.top.equalTo(self.historyView).offset(20);
        make.width.height.mas_equalTo(24);
        
    }];
    
    [_historyLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.historyView).offset(width/2+2);
        make.top.equalTo(self.historyView).offset(20);
        make.right.equalTo(self.historyView).offset(0);
        make.height.equalTo(@24);
    }];
    /*
    [_messageTLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.messageView).offset(width/2+10);
        make.top.equalTo(self.messageView).offset(30);
        make.right.equalTo(self.messageView).offset(-10);
        make.height.equalTo(@20);
    }];
    
    [_likeTLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.likeView).offset(width/2+10);
        make.top.equalTo(self.likeView).offset(30);
        make.right.equalTo(self.likeView).offset(-10);
        make.height.equalTo(@20);
    }];
    
    [_historyTLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.historyView).offset(width/2+10);
        make.top.equalTo(self.historyView).offset(30);
        make.right.equalTo(self.historyView).offset(-10);
        make.height.equalTo(@20);
    }];*/
    
}

@end
