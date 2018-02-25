//
//  ABFVideoInfo.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/11.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABFVideoInfo : NSObject

@property(nonatomic,assign) NSInteger id;
@property(nonatomic,copy)   NSString *title;
@property(nonatomic,copy)   NSString *url;
@property(nonatomic,copy)   NSString *create_at;
@property(nonatomic,copy)   NSString *desc;
@property(nonatomic,assign) NSInteger user_id;
@property(nonatomic,assign) NSInteger hit;
@property(nonatomic,copy)   NSString *cover;
@property(nonatomic,assign) NSInteger status;
@property(nonatomic,assign) NSInteger size;
@property(nonatomic,copy)   NSString  *username;
@property(nonatomic,copy)   NSString  *profile;
@property(nonatomic,copy)   NSString  *goodNum;
@property(nonatomic,assign) NSInteger comment_num;

@property(nonatomic,assign) CGFloat titleHeight;

@end
