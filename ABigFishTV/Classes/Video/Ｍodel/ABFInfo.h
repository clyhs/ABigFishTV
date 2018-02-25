//
//  ABFInfo.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/11.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABFInfo : NSObject

@property(nonatomic,assign) NSInteger id;
@property(nonatomic,assign) NSInteger chat_id;
@property(nonatomic,copy)   NSString  *url;
@property(nonatomic,assign) NSInteger size;

@end
