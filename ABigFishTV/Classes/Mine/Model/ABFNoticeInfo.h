//
//  ABFNoticeInfo.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/20.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABFNoticeInfo : NSObject

@property(nonatomic,assign) NSInteger id;
@property(nonatomic,strong) NSString  *title;
@property(nonatomic,strong) NSString  *content;
@property(nonatomic,strong) NSString  *create_at;
@property(nonatomic,assign) NSInteger type_id;
@property(nonatomic,strong) NSString  *typeName;

@end
