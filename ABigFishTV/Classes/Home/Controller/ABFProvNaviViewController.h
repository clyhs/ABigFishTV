//
//  ABFProvNaviViewController.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/16.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassValueDelegate <NSObject>

-(void)passValue:(NSString *)value;

@end

@interface ABFProvNaviViewController : UIViewController

@property(nonatomic,strong) NSMutableArray *dataArrays;

@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;

@end
