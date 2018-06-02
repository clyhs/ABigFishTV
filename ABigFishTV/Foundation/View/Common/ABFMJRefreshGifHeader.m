//
//  ABFMJRefreshGifHeader.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/12.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFMJRefreshGifHeader.h"

@implementation ABFMJRefreshGifHeader

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    ABFMJRefreshGifHeader *header = [super headerWithRefreshingTarget:target refreshingAction:action];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    //[header setTitle:@"数据加载中 ..." forState:MJRefreshStateRefreshing];
    NSMutableArray *refreshingImages  = [NSMutableArray array];
    for (int i = 1; i< 15; ++i) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%d",i]];
        [refreshingImages addObject:image];
    }
    [header setImages:@[refreshingImages.firstObject] forState:MJRefreshStateIdle];
    [header setImages:@[refreshingImages.firstObject] forState:MJRefreshStatePulling];
    [header setImages:[refreshingImages copy] forState:MJRefreshStateRefreshing];
    return header;
}


@end
