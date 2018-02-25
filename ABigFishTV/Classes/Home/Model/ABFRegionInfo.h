//
//  ABFRegionInfo.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/13.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABFRegionInfo : NSObject

@property(nonatomic,assign) NSInteger code;
@property(nonatomic,assign) NSInteger parentCode;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) NSString  *name;
@property(nonatomic,strong) NSString  *fullName;

@end
