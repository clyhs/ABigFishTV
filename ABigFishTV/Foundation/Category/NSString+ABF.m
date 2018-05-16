//
//  NSString+ABF.m
//  ABigFishTV
//
//  Created by 陈立宇 on 2018/5/16.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import "NSString+ABF.h"

@implementation NSString (ABF)

+ (NSString *)sendOnjectReturnEMJString:(NSString *)obj
{
    NSString *uniStr = [NSString stringWithUTF8String:[obj UTF8String]];
    NSData *uniData = [uniStr dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *goodStr = [[NSString alloc] initWithData:uniData encoding:NSUTF8StringEncoding] ;
    return goodStr;
}

+ (NSString*)replaceEmoji:(NSString *)str {
    
    __block NSMutableString* temp = [NSMutableString string];
    
    [str enumerateSubstringsInRange:NSMakeRange(0, [str length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex: 0];
        
        // surrogate pair
        
        if (0xd800 <= hs && hs <= 0xdbff) {const unichar ls = [substring characterAtIndex: 1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f) {
                //对转码过后的编码利用^对表情编码前后抱起来
                [temp appendString:[self sendOnjectReturnEMJString:[NSString stringWithFormat:@"^%@^", substring]]];
            }else {
                [temp appendString:substring];
            }
            
        } else {
            if (0x2100 <= hs && hs <= 0x26ff) {
                [temp appendString:[self sendOnjectReturnEMJString:[NSString stringWithFormat:@"^%@^", substring]]];
            }else {
                [temp appendString:substring];
            }
        }
        
    }];
    NSLog(@"%@", temp);
    return temp;
}

+ (NSString *)sendEMJStringReturnstring:(NSString *)obj {
    NSMutableString * returnStr = [[NSMutableString alloc] initWithCapacity:0];
    
    NSArray * arr = [obj componentsSeparatedByString:@"^"];
    for (int i = 0; i < arr.count; i ++) {
        [returnStr appendString:[self chage:arr[i]]];
    }
    return returnStr;
}

+ (NSString *)chage:(NSString *)obj {
    NSData *jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];
    NSString *goodMsg1 = [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
    
    if (goodMsg1 == nil ||[goodMsg1 isEqualToString:@""]) {
        return obj;
    }else {
        return goodMsg1;
    }
}

//判断是否含有Emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue =NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800) {
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f77f) {
                        returnValue =YES;
                    }
                }
            }else if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    returnValue =YES;
                }
            }else {
                // non surrogate
                if (0x2100 <= hs && hs <= 0x27ff) {
                    returnValue =YES;
                }else if (0x2B05 <= hs && hs <= 0x2b07) {
                    returnValue =YES;
                }else if (0x2934 <= hs && hs <= 0x2935) {
                    returnValue =YES;
                }else if (0x3297 <= hs && hs <= 0x3299) {
                    returnValue =YES;
                }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                    returnValue =YES;
                }
            }
        }
    }];
    return returnValue;
}


@end
