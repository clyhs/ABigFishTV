//
//  ABFProgramViewCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/12/18.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFProgramViewCell.h"
#import "ABFProgramInfo.h"

@implementation ABFProgramViewCell

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
        [self addTimeLabel];
        [self addNameLabel];
        [self addBottomLine];
    }
    return self;
}

-(void)addTimeLabel{
    
    UILabel *tLabel = [[UILabel alloc] init];
    tLabel.font = [UIFont systemFontOfSize:14];
    tLabel.textColor = COMMON_COLOR;
    tLabel.textAlignment = NSTextAlignmentLeft;
    //textLabel.text=title;
    [self addSubview:tLabel];
    _timeLab = tLabel;
    
}

-(void)addNameLabel{
    
    UILabel *nLabel = [[UILabel alloc] init];
    nLabel.font = [UIFont systemFontOfSize:14];
    nLabel.textColor = [UIColor darkGrayColor];
    nLabel.textAlignment = NSTextAlignmentLeft;
    //textLabel.text=title;
    [self addSubview:nLabel];
    _nameLab = nLabel;
    
}

-(void)addBottomLine{
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = LINE_BG;
    [self addSubview:lineView];
    _lineView = lineView;
}


-(void)setModel:(ABFProgramInfo *)model{
    _model = model;
    NSLog(@"============%@",model.play_time);
    _timeLab.text = model.play_time;
    _nameLab.text = model.title;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(10);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(70);
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
}

@end
