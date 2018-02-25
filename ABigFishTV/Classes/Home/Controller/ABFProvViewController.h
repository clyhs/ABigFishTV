//
//  ABFProvViewController.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/14.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABFProvViewController : UIViewController


//
@property(nonatomic,copy)   NSString    *typeId;
//
@property(nonatomic,assign) NSInteger   index;

@property(nonatomic,copy)   NSString    *code;

@property(nonatomic,weak)   UICollectionView *collectionView;

-(void)changeCell:(BOOL)flag;

@end
