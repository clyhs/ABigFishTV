//
//  ABFSettingViewController.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/12/5.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABFSettingViewControllerDelegate <NSObject>

-(void)logoutAction;

@end

@interface ABFSettingViewController : UIViewController

@property(nonatomic,weak) UITableView *tableView;

@property(nonatomic,assign) NSObject<ABFSettingViewControllerDelegate> *delegate;

@end
