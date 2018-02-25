//
//  ABFCommentInfo.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/7.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABFCommentInfo : NSObject

@property(nonatomic,assign) NSInteger id;
@property(nonatomic,copy)   NSString *context;
@property(nonatomic,copy)   NSString *create_at;
@property(nonatomic,assign) NSInteger user_id;
@property(nonatomic,assign) NSInteger reply_id;
@property(nonatomic,assign) NSInteger uid;
@property(nonatomic,assign) NSInteger type_id;
@property(nonatomic,assign) NSInteger good;
@property(nonatomic,assign) NSInteger bad;
@property(nonatomic,assign) NSInteger pid;
@property(nonatomic,copy)   NSString  *username;
@property(nonatomic,copy)   NSString  *replayname;
@property(nonatomic,copy)   NSString  *profile;

@property(nonatomic,strong) NSMutableArray *childs;

@property(nonatomic,assign) CGFloat contextHeight;

@property(nonatomic,assign) CGFloat replyHeight;


@end
