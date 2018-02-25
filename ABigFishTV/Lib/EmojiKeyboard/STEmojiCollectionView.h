//
//  STEmojiCollectionView.h
//  STEmojiKeyboard
//
//  Created by zhenlintie on 15/5/29.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STEmojiCollectionViewDelegate;

@interface STEmojiCollectionView : UIScrollView

@property (weak, nonatomic) id<STEmojiCollectionViewDelegate> emojiDelegate;

- (void)resetData;
- (void)reloadData;

- (void)showSection:(NSInteger)section;

@end

@protocol STEmojiCollectionViewDelegate <NSObject>

@required
- (NSInteger)countOfEmojiPageSection;
- (NSArray *)emojisForSection:(NSInteger)section;
- (NSString *)titleForSection:(NSInteger)section;

@optional
- (void)emojiDidClicked:(NSString *)emoji;
- (void)didScrollToSection:(NSInteger)section;

@end
