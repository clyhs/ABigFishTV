//
//  ABFVideoListViewController.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/11.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABFVideoListViewController : UIViewController


//
@property(nonatomic,copy)   NSString    *typeId;
//
@property(nonatomic,assign) NSInteger   index;

@property(nonatomic,strong) UITableView *tableView;

@end
