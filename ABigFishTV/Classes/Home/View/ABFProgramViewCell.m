//
//  ABFProgramViewCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/12/18.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFProgramViewCell.h"
#import "ABFProgramModel.h"
#import "NSDate+ABFDate.h"

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


-(void)setModel:(ABFProgramModel *)model{
    _model = model;
    NSLog(@"============%@",model.playtime);
    _timeLab.text = model.playtime;
    _nameLab.text = model.title;
    NSDate *datenow = [NSDate date];
    if(![model.playtimes isEqualToString:@""] && ![model.endtimes isEqualToString:@""]){
        NSTimeInterval playtimes    =[model.playtimes doubleValue] ;
        NSTimeInterval endtimes    =[model.endtimes doubleValue] ;
        NSDate *playdate = [NSDate dateWithTimeIntervalSince1970:playtimes];
        NSDate *enddate = [NSDate dateWithTimeIntervalSince1970:endtimes];
        
        NSInteger p = [NSDate compareOneDay:playdate withAnotherDay:datenow];
        NSInteger e = [NSDate compareOneDay:enddate withAnotherDay:datenow];
        if(p == -1 && e == 1){
            _nameLab.textColor = COMMON_COLOR;
        }
    }
    
    
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
