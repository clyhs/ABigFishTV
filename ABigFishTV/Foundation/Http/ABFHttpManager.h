//
//  ABFHttpManager.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/22.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
//#import <AFNetworking.h>

@interface ABFHttpManager : AFHTTPRequestOperationManager
//@interface ABFHttpManager : AFHTTPSessionManager

+ (instancetype)manager;

@end
