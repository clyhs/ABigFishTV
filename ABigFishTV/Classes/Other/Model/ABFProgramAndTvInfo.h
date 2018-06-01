//
//  ABFProgramAndTvInfo.h
//  ABigFishTV
//
//  Created by 陈立宇 on 2018/6/1.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ABFProgramAndTvInfo : NSObject

@property(nonatomic,assign) NSInteger tv_id;
@property(nonatomic,copy)   NSString  *play_at;
@property(nonatomic,copy)   NSString  *title;
@property(nonatomic,copy)   NSString  *play_time;
@property(nonatomic,strong) NSMutableArray *model;


@end
