//
//  ABFChannelListViewController.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/23.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABFChannelListViewController : UIViewController


@property(nonatomic,copy) NSString *url;

@property(nonatomic,weak) UITableView *tableView;

@property(nonatomic,weak) UICollectionView *collectionView;

@end
