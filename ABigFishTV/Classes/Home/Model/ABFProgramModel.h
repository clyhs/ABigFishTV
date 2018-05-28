//
//  ABFProgramModel.h
//  ABigFishTV
//
//  Created by 陈立宇 on 2018/5/28.
//  Copyright © 2018年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABFProgramModel : NSObject

@property(nonatomic,copy) NSString *playid;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *itemid;
@property(nonatomic,copy) NSString *pic;
@property(nonatomic,copy) NSString *classid;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *mainstars;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *playtimes;
@property(nonatomic,copy) NSString *endtime;
@property(nonatomic,copy) NSString *playtime;
@property(nonatomic,copy) NSString *endtimes;
@property(nonatomic,assign) NSInteger isplay;
@property(nonatomic,assign) NSInteger isday;
@property(nonatomic,assign) NSInteger width;

@end
