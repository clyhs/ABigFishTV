//
//  STEmoji.m
//  STEmojiKeyboard
//
//  Created by zhenlintie on 15/5/29.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import "STEmoji.h"

@implementation STEmoji
@end

@implementation STEmoji (Generate)

+ (NSDictionary *)emojis{
    static NSDictionary *__emojis = nil;
    if (!__emojis){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"json"];
        NSData *emojiData = [[NSData alloc] initWithContentsOfFile:path];
        __emojis = [NSJSONSerialization JSONObjectWithData:emojiData options:NSJSONReadingAllowFragments error:nil];
    }
    return __emojis;
}

+ (instancetype)peopleEmoji{
    STEmoji *emoji = [STEmoji new];
    emoji.title = @"人物";
    emoji.emojis = [self emojis][@"people"];
    emoji.type = STEmojiTypePeople;
    return emoji;
}

+ (instancetype)flowerEmoji{
    STEmoji *emoji = [STEmoji new];
    emoji.title = @"自然";
    emoji.emojis = [self emojis][@"flower"];
    emoji.type = STEmojiTypeFlower;
    return emoji;
}

+ (instancetype)bellEmoji{
    STEmoji *emoji = [STEmoji new];
    emoji.title = @"日常";
    emoji.emojis = [self emojis][@"bell"];
    emoji.type = STEmojiTypeBell;
    return emoji;
}

+ (instancetype)vehicleEmoji{
    STEmoji *emoji = [STEmoji new];
    emoji.title = @"建筑与交通";
    emoji.emojis = [self emojis][@"vehicle"];
    emoji.type = STEmojiTypeVehicle;
    return emoji;
}

+ (instancetype)numberEmoji{
    STEmoji *emoji = [STEmoji new];
    emoji.title = @"符号";
    emoji.emojis = [self emojis][@"number"];
    emoji.type = STEmojiTypeNumber;
    return emoji;
}

+ (NSArray *)allEmojis{
    return @[[self peopleEmoji], [self flowerEmoji], [self bellEmoji], [self vehicleEmoji], [self numberEmoji]];
}

@end
