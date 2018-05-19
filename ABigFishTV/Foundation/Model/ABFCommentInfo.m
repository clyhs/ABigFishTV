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
#import <YYText.h>

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
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_context];
        attributedString.yy_font = [UIFont systemFontOfSize:16];
        //attributedString.yy_lineSpacing =5;
        //attributedString.yy_kern = @0;
        attributedString.yy_lineBreakMode = NSLineBreakByWordWrapping;
        
        
        YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
        modifier.fixedLineHeight = 20;
        
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(labelWidth-5, CGFLOAT_MAX);
        container.linePositionModifier = modifier;
        
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedString];
        YYLabel *label = [YYLabel new];
        label.size = layout.textBoundingSize;
        label.textLayout = layout;
        _contextHeight = label.size.height;
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
            
            /*
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content.text];
            attributedString.yy_font = [UIFont systemFontOfSize:16];
            attributedString.yy_lineSpacing =5;
            attributedString.yy_kern = @0;
            //attributedString.yy_lineBreakMode = NSLineBreakByWordWrapping;
            
            
            YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
            modifier.fixedLineHeight = 20;
            
            
            YYTextContainer *container = [YYTextContainer new];
            container.size = CGSizeMake(labelWidth, CGFLOAT_MAX);
            container.linePositionModifier = modifier;
            
            YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedString];
            YYLabel *label = [YYLabel new];
            label.size = layout.textBoundingSize;
            label.textLayout = layout;
            //[label sizeToFit];
            CGFloat height = label.size.height;
            
            if([NSString stringContainsEmoji:content.text]){
                height = height -5;
            }else{
                height = height;
            }*/
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[str stringByAppendingString:reply.context]];
            attributedString.yy_font = [UIFont systemFontOfSize:16];
            attributedString.yy_lineSpacing =5;
            attributedString.yy_kern = @0;
            //attributedString.yy_lineBreakMode = NSLineBreakByWordWrapping;
            
            
            YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
            modifier.fixedLineHeight = 20;
            
            
            YYTextContainer *container = [YYTextContainer new];
            container.size = CGSizeMake(labelWidth, CGFLOAT_MAX);
            container.linePositionModifier = modifier;
            
            YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedString];
            YYLabel *label = [YYLabel new];
            label.size = layout.textBoundingSize;
            label.textLayout = layout;
            //[label sizeToFit];
            CGFloat height = label.size.height;
            
            
            content.backgroundColor = [UIColor yellowColor];
            content.text =[str stringByAppendingString:reply.context] ;
            content.font = [UIFont systemFontOfSize:16];
            content.numberOfLines = 0;
            content.textColor = [UIColor darkGrayColor];
            
            content.frame = CGRectMake(0, 0, labelWidth, height);
            
            
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[str stringByAppendingString:[reply.context stringByReplacingEmojiCheatCodesWithUnicode]] attributes:@{NSKernAttributeName:@0}];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.headIndent = 0;//缩进
            style.firstLineHeadIndent = 0;
            style.lineSpacing = 5;//行距
            [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
            NSInteger usernameCount = str.length;
            [text addAttribute:NSForegroundColorAttributeName value:COMMON_COLOR range:NSMakeRange(0, usernameCount)];
            content.attributedText = text;
            [content sizeToFit];
            nHeight = nHeight + content.frame.size.height;
        }
        if(replyCount>0){
            nHeight = nHeight + 10;
        }
        _replyHeight = nHeight;
        
    }
    return _replyHeight;
}





@end
