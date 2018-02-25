//
//  ABFHomeInfo.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/22.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFHomeInfo.h"
#import <MJExtension.h>

@implementation ABFHomeInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"hots" : @"ABFTelevisionInfo",
              @"news" : @"ABFTelevisionInfo",
              @"recommends" : @"ABFTelevisionInfo",
              @"cartoons" : @"ABFTelevisionInfo",
              @"foreigns" : @"ABFTelevisionInfo",
              @"hongkongs" : @"ABFTelevisionInfo",
              @"ads" : @"ABFTelevisionInfo"
        };
}

@end
