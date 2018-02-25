//
//  STEmojiKeyboard.m
//  STEmojiKeyboard
//
//  Created by zhenlintie on 15/5/29.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import "STEmojiKeyboard.h"
#import "STEmoji.h"
#import "STEmojiCollectionView.h"

#define kSTEmojiKeyboardFrame CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 262)
#define kSTEmojiToolBarHeight 30

@interface STEmojiToolBar : UIView
@property (assign, nonatomic) STEmojiType showType;
+ (instancetype)toolBarWithEmojis:(NSArray *)emojis;
@property (strong, nonatomic) void (^actionHandler)(STEmojiType);
@property (strong, nonatomic) void (^deleteHandler)();
@end

@implementation STEmojiToolBar{
    BOOL _beginDelete;
    CGFloat _time;
    NSArray *_emojis;
}

+ (instancetype)toolBarWithEmojis:(NSArray *)emojis{
    STEmojiToolBar *toolbar = [self new];
    [toolbar loadEmojis:emojis];
    return toolbar;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, CGRectGetHeight(kSTEmojiKeyboardFrame)-kSTEmojiToolBarHeight, CGRectGetWidth(kSTEmojiKeyboardFrame), kSTEmojiToolBarHeight)]){
        _beginDelete = NO;
        self.showType = STEmojiTypePeople;
    }
    return self;
}

- (void)loadUI{
    self.backgroundColor = [UIColor clearColor];
    UIButton *(^getButton)(CGRect, NSInteger, NSString *);
    getButton = ^UIButton *(CGRect frame, NSInteger tag, NSString *title){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = tag;
        button.adjustsImageWhenHighlighted = NO;
        button.tintColor = [UIColor colorWithRed:132/255.0 green:120/255.0 blue:158/255.0 alpha:0.8];
        button.frame = frame;
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.minimumScaleFactor = 0.8;
        [button addTarget:self action:@selector(emojiButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        return button;
    };
    
    CGFloat w = CGRectGetWidth(self.frame)/6;
    CGFloat h = CGRectGetHeight(self.frame);
    CGFloat left = 0;
    for (STEmoji *emoji in _emojis){
        UIButton *emojiButton = getButton(CGRectMake(left, 0, w, h),
                                          emoji.type,
                                          emoji.title);
        [self addSubview:emojiButton];
        left += w;
    }
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteButton.frame = CGRectMake(left, 0, w, h);
    deleteButton.tag = 100;
    deleteButton.tintColor = [UIColor whiteColor];
    [deleteButton setImage:[[UIImage imageNamed:@"keyboard_btn_delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [deleteButton addTarget:self action:@selector(deleteCancel) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton addTarget:self action:@selector(deleteCancel) forControlEvents:UIControlEventTouchDragOutside];
    [self addSubview:deleteButton];
}

- (void)loadEmojis:(NSArray *)emojis{
    _emojis = emojis;
    [self loadUI];
    self.showType = STEmojiTypePeople;
}

- (void)emojiButtonTouchDown:(UIButton *)button{
    if (self.actionHandler){
        self.actionHandler(button.tag);
    }
}

- (void)deleteButtonTouchDown{
    if (self.deleteHandler){
        self.deleteHandler();
        _beginDelete = YES;
        _time = 0.3;
        [self deleteDown];
    }
}

- (void)deleteCancel{
    _beginDelete = NO;
}

- (void)deleteDown{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_beginDelete){
            if (self.deleteHandler){
                self.deleteHandler();
            }
            _time = 0.1;
            [self deleteDown];
        }
    });
}

- (void)setShowType:(STEmojiType)showType{
    _showType = showType;
    for (UIButton *button in self.subviews){
        button.selected = (button.tag == _showType);
    }
}

@end

@interface STEmojiKeyboard () <STEmojiCollectionViewDelegate>

@property (strong, nonatomic) STEmojiCollectionView *emojiPageView;
@property (strong, nonatomic) STEmojiToolBar *toolBar;

@property (strong, nonatomic) NSArray *emojiData;

@end

@implementation STEmojiKeyboard{
    BOOL _dataDidLoad;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)keyboard{
    static dispatch_once_t onceToken;
    static STEmojiKeyboard *_sharedKeyboard;
    dispatch_once(&onceToken, ^{
        _sharedKeyboard = [self new];
    });
    return _sharedKeyboard;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:kSTEmojiKeyboardFrame inputViewStyle:UIInputViewStyleKeyboard]){
        self.clipsToBounds = NO;
        _dataDidLoad = NO;
        _emojiData = [STEmoji allEmojis];
        [self loadUI];
    }
    return self;
}

- (BOOL)enableInputClicksWhenVisible{
    return YES;
}

- (void)loadUI{
    _emojiPageView = [[STEmojiCollectionView alloc] initWithFrame:self.bounds];
    _emojiPageView.emojiDelegate = self;
    _toolBar = [STEmojiToolBar toolBarWithEmojis:_emojiData];
    __weak typeof(self) ws = self;
    __weak typeof(_emojiPageView) wPageView = _emojiPageView;
    __weak typeof(_toolBar) wToolBar = _toolBar;
    [_toolBar setActionHandler:^(STEmojiType showType) {
        [wPageView showSection:showType];
        [wToolBar setShowType:showType];
    }];
    [_toolBar setDeleteHandler:^{
        [ws deletePressed];
    }];
    [self addSubview:_emojiPageView];
    [self addSubview:_toolBar];
}

- (void)changeKeyboard{
    [(UIControl *)self.textView resignFirstResponder];
    [(UITextView *)self.textView setInputView:nil];
    [(UIControl *)self.textView becomeFirstResponder];
}

- (void)deletePressed{
    [self.textView deleteBackward];
    [[UIDevice currentDevice] playInputClick];
    [self textChanged];
}

- (void)insertEmoji:(NSString *)emoji{
    [[UIDevice currentDevice] playInputClick];
    [self.textView insertText:emoji];
    [self textChanged];
}

- (void)textChanged{
    if ([self.textView isKindOfClass:[UITextView class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
    else if ([self.textView isKindOfClass:[UITextField class]])
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
}

#pragma mark - setter

- (void)setTextView:(id<UITextInput>)textView{
    if ([textView isKindOfClass:[UITextView class]]) {
        [(UITextView *)textView setInputView:self];
    }
    else if ([textView isKindOfClass:[UITextField class]]) {
        [(UITextField *)textView setInputView:self];
    }
    _textView = textView;
    if (!_dataDidLoad){
        [_emojiPageView reloadData];;
        _dataDidLoad = YES;
    }
}

#pragma mark - emoji delegate

- (NSInteger)countOfEmojiPageSection{
    return _emojiData.count;
}

- (NSArray *)emojisForSection:(NSInteger)section{
    return [_emojiData[section] emojis];
}

- (NSString *)titleForSection:(NSInteger)section{
    return [_emojiData[section] title];
}

- (void)emojiDidClicked:(NSString *)emoji{
    [self insertEmoji:emoji];
}

- (void)didScrollToSection:(NSInteger)section{
    [_toolBar setShowType:section];
}


@end

