//
//  ABFMenuView.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/12.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavBindingDelegate <NSObject>
- (void)pushVC:(id)sender name:(NSString *)name url:(NSString *)url;
@end


@interface ABFMenuView : UIView

-(id)initWithFrame:(CGRect)frame menuArray:(NSMutableArray *)menuArray;

@property (nonatomic,strong) NSMutableArray *menuArray;

@property (nonatomic, weak) id<NavBindingDelegate> delegate;

@end
