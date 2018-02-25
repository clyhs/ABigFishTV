//
//  ABFCommentInfo.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/7.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFCommentInfo.h"
#import <MJExtension.h>

@implementation ABFCommentInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"childs" : @"ABFCommentInfo"
        };
}

-(CGFloat) contextHeight{

    if(!_contextHeight){
        CGFloat labelWidth = kScreenWidth-30;
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 1)];
        content.text = _context;
        content.font = [UIFont systemFontOfSize:16];
        content.numberOfLines = 0;
        CGFloat height = [UILabel getHeightByWidth:labelWidth title:content.text font:content.font];
        NSInteger count = height / 13 ;
        _contextHeight = height + 6*(count+1);
        //_contextHeight = height/17*20;

    }
    return _contextHeight;
}

-(CGFloat) replyHeight{
    
    if(!_replyHeight){
        
        CGFloat labelWidth = kScreenWidth-20-10;
        NSArray *replys = [ABFCommentInfo mj_objectArrayWithKeyValuesArray:_childs];
        NSInteger replyCount = replys.count;
        CGFloat nHeight = 0;
        for(NSInteger i=0;i<replyCount;i++){
            ABFCommentInfo *reply = replys[i];
            UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 20)];
            NSString *str = [reply.replayname stringByAppendingString:@":"];
            
            if(reply.username !=nil){
                str = [str stringByAppendingFormat:@"回复[%@]:",reply.username];
            }
            
            content.text =[str stringByAppendingString:reply.context] ;
            content.font = [UIFont systemFontOfSize:14];
            content.numberOfLines = 0;
            CGFloat height = [UILabel getHeightByWidth:labelWidth title:content.text font:content.font];
            nHeight = nHeight + height+ 7;
        }
        _replyHeight = nHeight;
        
    }
    
    return _replyHeight;

}

@end
