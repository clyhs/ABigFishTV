//
//  STEmojiKeyboard.h
//  STEmojiKeyboard
//
//  Created by zhenlintie on 15/5/29.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STEmojiKeyboard : UIInputView <UIInputViewAudioFeedback>
+ (instancetype)keyboard;
@property (strong, nonatomic) id<UITextInput> textView;
@end


