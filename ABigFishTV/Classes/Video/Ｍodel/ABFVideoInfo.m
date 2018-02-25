//
//  ABFVideoInfo.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/11.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFVideoInfo.h"
#import <MJExtension.h>

@implementation ABFVideoInfo


-(CGFloat) titleHeight{
    
    if(!_titleHeight){
        CGFloat labelWidth = kScreenWidth-10;
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 1)];
        content.text = _title;
        content.font = [UIFont systemFontOfSize:14];
        content.numberOfLines = 0;
        CGFloat height = [UILabel getHeightByWidth:labelWidth title:content.text font:content.font];
        NSInteger count = height / 13 ;
        _titleHeight = height + 6*(count+1);
        //_contextHeight = height/17*20;
        
    }
    return _titleHeight;
}


@end
