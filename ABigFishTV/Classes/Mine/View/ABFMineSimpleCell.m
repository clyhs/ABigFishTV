//
//  ABFMineSimpleCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/25.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFMineSimpleCell.h"

@implementation ABFMineSimpleCell

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
        [self addTitleLabel];
        [self addBottomLine];
        [self addDesc];
        [self addIcon];
        [self setProfile];
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
        [self addTitleLabel:title];
        [self addBottomLine];
        [self addDesc];
    }
    
    return self;
}

-(void)addTitleLabel:(NSString*)title{
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = [UIColor darkGrayColor];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.text=title;
    [self addSubview:textLabel];
    _titleLabel = textLabel;

}

-(void)addTitleLabel{
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = [UIColor darkGrayColor];
    textLabel.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:textLabel];
    _titleLabel = textLabel;
    
}

-(void)addBottomLine{

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = LINE_BG;
    [self addSubview:lineView];
    _lineView = lineView;
}

-(void) addIcon{
    
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    //[iconImg setImage:[UIImage imageNamed:_meItem.icon]];
    [self addSubview:iconImg];
    _iconimage = iconImg;
    
}

-(void)setIconName:(NSString *)iconName{
    _iconimage.image = [UIImage imageNamed:iconName];
}

-(void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}

-(void) addDesc{
    
    UILabel *dLabel = [[UILabel alloc] init];
    dLabel.font = [UIFont systemFontOfSize:12];
    dLabel.textColor = COMMON_COLOR;
    //dLabel.text = _meItem.desc;
    dLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:dLabel];
    _descLabel = dLabel;
    
}

-(void)setDesc:(NSString *)desc{
    _descLabel.text =desc;
}

-(void)setProfile{

    UIImageView *profile = [[UIImageView alloc] init];
    //[iconImg setImage:[UIImage imageNamed:_meItem.icon]];
    [self addSubview:profile];
    profile.hidden = YES;
    //profile.backgroundColor = LINE_BG;
    profile.layer.borderWidth = 1.0f;
    profile.layer.borderColor = [UIColor whiteColor].CGColor;
    profile.layer.masksToBounds = YES;
    profile.layer.cornerRadius = 35*0.5;
    _profile = profile;
    
}

-(void)setProfileImage:(UIImage *)profileImage{
    [_profile setImage:profileImage];
    _profileImage = profileImage;
}

-(void)setProfileUrl:(NSString *)profileUrl{
    _profileUrl = profileUrl;
    [_profile sd_setImageWithURL:[NSURL URLWithString:profileUrl] placeholderImage:[UIImage imageNamed:@"profile"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(50);
        make.top.equalTo(self).offset(15);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-30);
        make.bottom.equalTo(self).offset(-5);
        make.height.equalTo(@20);
    }];
    [_profile mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self).offset(-30);
        make.top.equalTo(self).offset(7.5);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.equalTo(@0.5);
    }];
    
    
    
    
    
    
}


@end
