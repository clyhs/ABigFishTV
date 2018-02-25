//
//  ABFHomeInfo.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/22.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABFTelevisionInfo.h"

@interface ABFHomeInfo : NSObject

@property(nonatomic,strong) NSMutableArray *hots;
@property(nonatomic,strong) NSMutableArray *news;
@property(nonatomic,strong) NSMutableArray *recommends;
@property(nonatomic,strong) NSMutableArray *cartoons;
@property(nonatomic,strong) NSMutableArray *foreigns;
@property(nonatomic,strong) NSMutableArray *hongkongs;
@property(nonatomic,strong) NSMutableArray *ads;



@end
