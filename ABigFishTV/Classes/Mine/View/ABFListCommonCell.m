//
//  ABFListCommonCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/18.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFListCommonCell.h"
#import "ABFTelevisionInfo.h"

@implementation ABFListCommonCell

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

-(void)setModel:(ABFTelevisionInfo *)model{
    _model = model;
    self.textLabel.text = model.name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(50);
        make.top.equalTo(self).offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.equalTo(@0.5);
    }];
    
    
    
    
}

@end
