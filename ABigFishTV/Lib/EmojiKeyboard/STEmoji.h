//
//  STEmoji.h
//  STEmojiKeyboard
//
//  Created by zhenlintie on 15/5/29.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, STEmojiType) {
    // emoji show type
    STEmojiTypePeople = 0,
    STEmojiTypeFlower,
    STEmojiTypeBell,
    STEmojiTypeVehicle,
    STEmojiTypeNumber,
};

@interface STEmoji : NSObject

@property (assign, nonatomic) STEmojiType type;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *emojis;

@end

@interface STEmoji (Generate)
+ (NSArray *)allEmojis;
@end
