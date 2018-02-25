//
//  ABFMineMenuCell.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/25.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFMineMenuCell.h"

@implementation ABFMineMenuCell

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
        self.backgroundColor = [UIColor whiteColor];
        [self addMessageLabel];
        [self addlikeLabel];
        [self addHistoryLabel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self addMessageLabel];
        [self addlikeLabel];
        [self addHistoryLabel];
    }
    
    return self;
}

-(void)addMessageLabel{
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.textColor = [UIColor darkGrayColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.text=@"消息";
    
    [self addSubview:messageLabel];
    _messageLabel = messageLabel;

}

-(void)addlikeLabel{
    
    UILabel *likeLabel = [[UILabel alloc] init];
    likeLabel.font = [UIFont systemFontOfSize:14];
    likeLabel.textColor = [UIColor darkGrayColor];
    likeLabel.textAlignment = NSTextAlignmentCenter;
    likeLabel.text=@"关注";
    
    [self addSubview:likeLabel];
    _likeLabel = likeLabel;
    
}

-(void)addHistoryLabel{
    
    UILabel *hLabel = [[UILabel alloc] init];
    hLabel.font = [UIFont systemFontOfSize:14];
    hLabel.textColor = [UIColor darkGrayColor];
    hLabel.textAlignment = NSTextAlignmentCenter;
    hLabel.text=@"历史";
    
    [self addSubview:hLabel];
    _historyLabel = hLabel;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = kScreenWidth / 3;
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-width*2);
        make.height.equalTo(@20);
    }];
    
    [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(width);
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-width);
        make.height.equalTo(@20);
    }];
    
    [_historyLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(width*2);
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(0);
        make.height.equalTo(@20);
    }];
    
    
}



@end
