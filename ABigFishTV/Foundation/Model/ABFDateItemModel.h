//
//  ABFDateItemModel.h
//  ABigFishTV
//
//  Created by 陈立宇 on 18/3/10.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABFDateItemModel : NSObject

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) BOOL isCurrentDate;    // 是否为[NSDate date]当天
@property (nonatomic, assign) BOOL isCurrentMonth;   // 是否为当前展示月份里的日期
@property (nonatomic, assign) NSInteger starRating;  // 跑步评分
//@property (nonatomic, assign) BOOL hasRunRecord;     // 是否有跑步记录

@property (nonatomic, assign) BOOL selected;         // 是否被选中

@end
