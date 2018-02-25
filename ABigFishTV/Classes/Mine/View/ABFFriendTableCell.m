//
//  ABFFriendTableCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/12/6.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFFriendTableCell.h"
#import "ABFUserInfo.h"

@implementation ABFFriendTableCell

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
        [self setLineUI];
        [self setMottoLab];
    }
    return self;
}

-(void)setUsernameLabUI{
    
    _usernameLab = [[UILabel alloc] init];
    _usernameLab.font = [UIFont systemFontOfSize:14];
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

-(void)setMottoLab{

    _mottoLab = [[UILabel alloc] init];
    _mottoLab.font = [UIFont systemFontOfSize:14];
    _mottoLab.textAlignment =NSTextAlignmentLeft;
    _mottoLab.textColor = [UIColor lightGrayColor];
    [self addSubview:_mottoLab];
}

-(void) setLineUI{
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = LINE_BG;
    
    [self addSubview:_lineView];
}

-(void)setModel:(ABFUserInfo *)model{
    _model = model;
    _usernameLab.text = model.username;
    _mottoLab.text = model.motto;
    [_profile sd_setImageWithURL:[NSURL URLWithString:model.profile] placeholderImage:[UIImage imageNamed:@""]];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_usernameLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(60);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    [_mottoLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(60);
        make.top.equalTo(self).offset(30);
        make.width.mas_equalTo(self.width-60-40);
        make.height.mas_equalTo(20);
    }];
    
    [_profile mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(0.5);
    }];
}

@end
