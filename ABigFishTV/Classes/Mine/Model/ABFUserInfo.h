//
//  ABFUserInfo.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/11.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABFUserInfo : NSObject

@property(nonatomic,assign) NSInteger id;
@property(nonatomic,strong) NSString *username;
@property(nonatomic,strong) NSString *password;
@property(nonatomic,strong) NSString *qq;
@property(nonatomic,strong) NSString *mail;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *desc;
@property(nonatomic,assign) NSInteger login_num;
@property(nonatomic,strong) NSString *login_at;
@property(nonatomic,strong) NSString *profile;
@property(nonatomic,strong) NSString *motto;

@property(nonatomic,assign) NSInteger history;
@property(nonatomic,assign) NSInteger likenum;
@property(nonatomic,assign) NSInteger notices;

@end
