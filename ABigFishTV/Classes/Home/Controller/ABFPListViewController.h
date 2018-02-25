//
//  ABFPListViewController.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/4.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABFCommentInfo;

@protocol ABFPListViewDelegate <NSObject>
- (void)pushlistForButton:(ABFCommentInfo *)model index:(NSInteger)tag;
- (void)pushlistForReplyButton:(ABFCommentInfo *)model index:(NSInteger)tag;

@end

@interface ABFPListViewController : UITableViewController

@property(nonatomic,strong)   NSString       *typeId;
@property(nonatomic,assign)   NSInteger      index;
@property(nonatomic,assign)   NSInteger      uid;
@property(nonatomic,strong)   NSMutableArray *data;

@property(nonatomic,assign)   CGFloat        height;

@property(nonatomic,weak)   id<ABFPListViewDelegate> delegate;

-(void)loadDataFirst;


@end
