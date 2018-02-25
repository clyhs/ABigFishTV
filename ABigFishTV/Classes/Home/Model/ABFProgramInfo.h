//
//  ABFProgramInfo.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/12/18.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABFProgramInfo : NSObject

@property(nonatomic,assign) NSInteger id;
@property(nonatomic,assign) NSInteger tv_id;
@property(nonatomic,copy)   NSString  *title;
@property(nonatomic,copy)   NSString  *play_at;
@property(nonatomic,copy)   NSString  *url;
@property(nonatomic,copy)   NSString  *play_date;
@property(nonatomic,copy)   NSString  *play_time;

@end
