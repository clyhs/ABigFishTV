//
//  ABFNoticeCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/20.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFNoticeCell.h"
#import "ABFNoticeInfo.h"

@implementation ABFNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self addTitleLabel];
        [self addBottomLine];
        [self addTypenameLabel];
        [self addCreateAtLabel];
    }
    
    return self;
}


-(void)addTitleLabel{
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = [UIColor darkGrayColor];
    textLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:textLabel];
    _titleLabel = textLabel;
    
}

-(void)addCreateAtLabel{
    
    UILabel *cLabel = [[UILabel alloc] init];
    cLabel.font = [UIFont systemFontOfSize:12];
    cLabel.textColor = [UIColor lightGrayColor];
    cLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:cLabel];
    _createAtLab = cLabel;
    
}

-(void)addTypenameLabel{
    
    UILabel *tLabel = [[UILabel alloc] init];
    tLabel.font = [UIFont systemFontOfSize:12];
    tLabel.textColor = [UIColor redColor];
    tLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:tLabel];
    _typeNameLab = tLabel;
    
}

-(void)addBottomLine{
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = LINE_BG;
    [self addSubview:lineView];
    _lineView = lineView;
}

-(void)setModel:(ABFNoticeInfo *)model{
    _titleLabel.text = model.title;
    _typeNameLab.text = model.typeName;
    _createAtLab.text = model.create_at;
    _model = model;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@20);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.equalTo(@0.5);
    }];
    [_typeNameLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(30);
        make.width.mas_offset(50);
        make.height.equalTo(@20);
    }];
    [_createAtLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(60);
        make.top.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@20);
    }];
    
    
    
    
}

@end
