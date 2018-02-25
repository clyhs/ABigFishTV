//
//  ABFCacheManager.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/25.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABFCacheManager : NSObject

+ (instancetype)manager;

-( float )filePath;

-( long ) fileSizeAtPath:( NSString *) filePath;

-( float ) folderSizeAtPath:( NSString *) folderPath;

-(void)clearFile;

@end
