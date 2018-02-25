//
//  ABFDictInfo.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/8.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABFDictInfo : NSObject

@property(nonatomic,assign)  NSInteger id;
@property(nonatomic,copy)    NSString  *name;
@property(nonatomic,assign)  NSInteger pid;
@property(nonatomic,assign)  NSInteger sort;
@property(nonatomic,copy)    NSString  *schar;
@property(nonatomic,copy)    NSString  *icon;

@property(nonatomic,strong)  NSMutableArray *tvs;



@end
