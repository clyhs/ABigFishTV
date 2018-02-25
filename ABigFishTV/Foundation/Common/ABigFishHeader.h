//
//  ABigFishHeader.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/9/23.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#ifndef ABigFishHeader_h
#define ABigFishHeader_h

#ifdef __OBJC__

#import <UIKit/UIKit.h>

#endif


//屏幕高度
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

//屏幕宽度
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

//颜色 两种参数
#define RGB_255(r,g,b) [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:1]

#define RGBA_255(r,g,b,a) [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:a]

#define COMMON_COLOR RGB_255(23, 158, 246)
#define LINE_BG RGB_255(236, 236, 236)

#define FONTNAME @"HelveticaNeue"

#define BaseUrl @"www.***.com"
#define TVListUrl @"/api/tv/page/2"
#define TVIndexUrl @"/api/tv/index"
#define TVUpdatehitUrl @"/api/tv/updatehit/"
#define TVCommentUrl @"/api/comment/page/"
#define TVAllChannelUrl @"/api/tv/all"
#define LoginUrl @"/api/user/login"
#define ChatUrl @"/api/chat/page"
#define VideoUrl @"/api/video/page"
#define RegionUrl @"/api/region/provinces"
#define TVProvinceUrl @"/api/tv/province"
#define TVProvinceForIndexUrl @"/api/tv/provinceforindex/"
#define SearchTVUrl @"/api/tv/search"
#define TVRecordUrl @"/api/tv/record/"
#define TVCollectUrl @"/api/tv/collect/"
#define NoticeListUrl @"/api/notice/page"
#define TVDelRecordUrl @"/api/tv/delrecord"
#define TVCommentAddUrl @"/api/comment/add"
#define ChatAddUrl @"/api/chat/add"
#define UserFriendsUrl @"/api/user/friends/"
#define UserProfile @"/api/user/profile"
#define TVProgramUrl @"/api/tv/programbyid/"
#define UserGoodUrl @"/api/user/good" 
#define UserGetGoodUrl @"/api/user/getgood/"
#define UserRegisterUrl @"/api/user/registerforother"





#endif /* ABigFishHeader_h */
