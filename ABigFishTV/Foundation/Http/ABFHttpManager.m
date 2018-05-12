//
//  ABFHttpManager.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/22.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFHttpManager.h"

@implementation ABFHttpManager

+ (instancetype)manager
{/*
    ABFHttpManager *mgr = [super manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",
                                                    @"image/jpeg",
                                                    @"image/png",
                                                    @"text/json",
                                                    @"text/javascript",
                                                    @"text/html", nil];*/
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer.timeoutInterval = 30.f;
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    return sessionManager;
}

@end
