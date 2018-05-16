//
//  ABFCommentInfo.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/7.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFCommentInfo.h"
#import <MJExtension.h>
#import "NSString+ABF.h"

@implementation ABFCommentInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"childs" : @"ABFCommentInfo"
        };
}

-(CGFloat) contextHeight{

    if(!_contextHeight){
        CGFloat labelWidth = kScreenWidth-60;
        
        UILabel *context = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 1)];
        context.font = [UIFont systemFontOfSize:16];
        context.text = [_context stringByReplacingEmojiCheatCodesWithUnicode];
        CGFloat height = [UILabel getChangeSpaceForLabel:context withLineSpace:5 WordSpace:3];
        _contextHeight = height;
    }
    return _contextHeight;
}

-(CGFloat) replyHeight{
    
    if(!_replyHeight){
        
        CGFloat labelWidth = kScreenWidth-70;
        NSArray *replys = [ABFCommentInfo mj_objectArrayWithKeyValuesArray:_childs];
        NSInteger replyCount = replys.count;
        CGFloat nHeight = 0;
        for(NSInteger i=0;i<replyCount;i++){
            ABFCommentInfo *reply = replys[i];
            UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 1)];
            NSString *str = [reply.replayname stringByAppendingString:@":"];
            
            if(reply.username !=nil){
                str = [str stringByAppendingFormat:@"回复[%@]:",reply.username];
            }
            
            content.text =[[str stringByAppendingString:reply.context] stringByReplacingEmojiCheatCodesWithUnicode] ;
            content.font = [UIFont systemFontOfSize:16];

            CGFloat height = [UILabel getHeightByWidthForSpace:labelWidth-5 string:[NSString replaceEmoji: [str stringByAppendingString:reply.context]] font:[UIFont systemFontOfSize:16] withLineSpace:5 WordSpace:3];
            nHeight =nHeight+ height;
        }
        if(replyCount>0){
            nHeight = nHeight+10;
        }
        _replyHeight = nHeight;
        
    }
    
    return _replyHeight;

}

@end
