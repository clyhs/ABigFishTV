//
//  ABFChatInfo.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/11.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFChatInfo.h"
#import "NSString+ABF.h"
#import "UILabel+ABFLabel.h"
#import <MJExtension.h>
#import "ABFInfo.h"

@implementation ABFChatInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"images" : @"ABFInfo",
              @"videos" : @"ABFInfo"
        };
}

-(CGFloat) contextHeight{
    
    if(!_contextHeight){
        CGFloat labelWidth = kScreenWidth-70;
        CGFloat height = [UILabel getHeightByWidthForSpace:labelWidth-5 string:[NSString replaceEmoji: _context] font:[UIFont systemFontOfSize:16] withLineSpace:5 WordSpace:0];
        _contextHeight = height;
    }
    return _contextHeight;
}

-(CGFloat) contextHeight2{
    
    if(!_contextHeight2){
        CGFloat labelWidth = kScreenWidth-20;
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 1)];
        content.text = [NSString stringWithFormat:@"    %@",_context];
        content.font = [UIFont systemFontOfSize:18];
        content.numberOfLines = 0;
        CGFloat height = [UILabel getHeightByWidth:labelWidth title:content.text font:content.font];
        NSInteger count = height / 13 ;
        _contextHeight2 = height + 6*(count+1);
    }
    return _contextHeight2;
}

-(CGFloat) imagesHeight{

    CGFloat lineHeight= ((kScreenWidth-60)/3-10);
    CGFloat lineHeight2= (((kScreenWidth-60)*2)/3-10);
    NSInteger len = 0;
    if(!_imagesHeight){
        NSArray *images = [ABFInfo mj_keyValuesArrayWithObjectArray:_images];
        if(images.count>0){
            NSInteger count = [images count];
            /*
            if(count % 3 == 0){
                _imagesHeight = (count/3)*(lineHeight+10);
            }else{
                _imagesHeight = (count/3 + 1)*(lineHeight+10);
            }*/
            if(count <= 3){
                len = 1;
            }else if((count % 3 == 0) && (count>3)){
                len = count / 3;
            }else if((count % 3 > 0) && (count>3)){
                len = count / 3 + 1;
            }
            if(count == 1){
                _imagesHeight = lineHeight2;
            }else{
                _imagesHeight = (lineHeight+10) * len;
            }
            
            
        }else{
            _imagesHeight = 0;
        }
        
        _imagesHeight = _imagesHeight + 20;
        
        
        
    }
    return _imagesHeight;
}

@end
