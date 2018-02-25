//
//  ABFDictInfo.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/8.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFDictInfo.h"
#import <MJExtension.h>

@implementation ABFDictInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"tvs" : @"ABFTelevisionInfo",
              @"news" : @"ABFTelevisionInfo",
              @"recommends" : @"ABFTelevisionInfo"
              };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"schar":@"char"};
}

@end
