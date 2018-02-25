//
//  ABFRightTableViewCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/19.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFRightTableViewCell.h"
#import "ABFTelevisionInfo.h"

@implementation ABFRightTableViewCell

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
        //self.backgroundColor = RGB_255(250, 250, 250);
        [self addTitleLabel];
        [self addBottomLine];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self addTitleLabel:title];
        [self addBottomLine];
    }
    
    return self;
}

-(void)addTitleLabel{
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = [UIColor darkGrayColor];
    textLabel.textAlignment = NSTextAlignmentLeft;
    //textLabel.text=title;
    [self addSubview:textLabel];
    _titleLabel = textLabel;
    
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

-(void)addBottomLine{
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = LINE_BG;
    [self addSubview:lineView];
    _lineView = lineView;
}

-(void)setModel:(ABFTelevisionInfo *)model{
    _model = model;
    _titleLabel.text = model.name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(40);
        make.top.equalTo(self).offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self).offset(0);
        make.height.equalTo(@0.5);
    }];
}

@end
