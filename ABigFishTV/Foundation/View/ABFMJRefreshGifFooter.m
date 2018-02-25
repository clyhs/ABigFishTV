//
//  ABFMJRefreshGifFooter.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/20.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFMJRefreshGifFooter.h"

@implementation ABFMJRefreshGifFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action{
    
    ABFMJRefreshGifFooter *footer = [super footerWithRefreshingTarget:target refreshingAction:action];
    footer.stateLabel.hidden = NO;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"数据加载中 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多的数据" forState:MJRefreshStateNoMoreData];
    
    NSMutableArray *refreshingImages  = [NSMutableArray array];
    for (int i = 1; i< 5; ++i) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh%d",i]];
        [refreshingImages addObject:image];
    }
    [footer setImages:@[refreshingImages.firstObject] forState:MJRefreshStateIdle];
    [footer setImages:@[refreshingImages.firstObject] forState:MJRefreshStatePulling];
    [footer setImages:[refreshingImages copy] forState:MJRefreshStateRefreshing];
    
    
    return footer;
    
}

@end
