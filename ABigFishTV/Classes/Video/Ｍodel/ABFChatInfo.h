//
//  ABFChatInfo.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/11.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABFChatInfo : NSObject

@property(nonatomic,assign) NSInteger id;
@property(nonatomic,copy)   NSString  *context;
@property(nonatomic,assign) NSInteger user_id;
@property(nonatomic,assign) NSInteger type_id;
@property(nonatomic,copy)   NSString  *username;
@property(nonatomic,copy)   NSString  *create_at;
@property(nonatomic,assign) NSInteger hit;
@property(nonatomic,copy)   NSString  *profile;
@property(nonatomic,assign) NSInteger comment_num;
@property(nonatomic,assign) NSInteger good;
@property(nonatomic,copy)   NSString  *goodNum;

@property(nonatomic,strong) NSMutableArray *images;
@property(nonatomic,strong) NSMutableArray *videos;

@property(nonatomic,assign) CGFloat contextHeight;
@property(nonatomic,assign) CGFloat contextHeight2;

@property(nonatomic,assign) CGFloat imagesHeight;

@property(nonatomic,assign) NSInteger fri;


@end
