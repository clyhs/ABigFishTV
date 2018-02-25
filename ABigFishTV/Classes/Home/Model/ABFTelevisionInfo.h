//
//  ABFTelevisionInfo.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/22.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABFTelevisionInfo : NSObject

@property(nonatomic,assign) NSInteger id;
@property(nonatomic,copy) NSString  *name;
@property(nonatomic,copy) NSString  *url_1;
@property(nonatomic,copy) NSString  *url_2;
@property(nonatomic,copy) NSString  *url_3;
@property(nonatomic,copy) NSString  *type_ids;
@property(nonatomic,assign) NSInteger is_hot;
@property(nonatomic,assign) NSInteger is_new;
@property(nonatomic,assign) NSInteger is_recommend;
@property(nonatomic,assign) NSInteger country;
@property(nonatomic,assign) NSInteger province;
@property(nonatomic,assign) NSInteger city;
@property(nonatomic,copy) NSString  *icon;
@property(nonatomic,copy) NSString  *bg;
@property(nonatomic,copy) NSString  *keyword;
@property(nonatomic,copy) NSString  *context;
@property(nonatomic,copy) NSString  *countryName;
@property(nonatomic,copy) NSString  *provinceName;
@property(nonatomic,copy) NSString  *typeNames;
@property(nonatomic,assign) NSInteger icon_width;
@property(nonatomic,assign) NSInteger icon_height;
@property(nonatomic,assign) NSInteger hit;
@property(nonatomic,copy)   NSString  *playtitle;
@property(nonatomic,assign) NSInteger commentNum;
@property(nonatomic,copy)   NSString  *goodNum;




@end
