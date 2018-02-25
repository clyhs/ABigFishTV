//
//  STEmojiCollectionView.m
//  STEmojiKeyboard
//
//  Created by zhenlintie on 15/5/29.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import "STEmojiCollectionView.h"

#define kSTEmojiSize 33

@interface STEmojiView : UIImageView
@property (copy, nonatomic) NSString *emoji;
@end

@implementation STEmojiView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)setEmoji:(NSString *)emoji{
    _emoji = emoji;
    NSDictionary *att = @{NSFontAttributeName:[UIFont systemFontOfSize:kSTEmojiSize]};
    CGSize size = [emoji sizeWithAttributes:att];
    CGFloat scale = [UIScreen mainScreen].scale;
    self.frame = CGRectMake(0, 0, size.width, size.height);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGRect rect = CGRectMake(0, 0, size.width*scale, size.height*scale);
        UIGraphicsBeginImageContext(rect.size);
        [_emoji drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kSTEmojiSize*scale]}];
        UIImage *image = [UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage scale:scale orientation:UIImageOrientationUp];
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
        });
    });
}

@end

@interface STEmojiPreview : UIView
- (void)setEmoji:(NSString *)emoji;
@end

@implementation STEmojiPreview{
    UILabel *_emojiLabel;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:CGRectMake(0, 0, 102.5, 100)]){
        _emojiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 102.5, 50)];
        _emojiLabel.font = [UIFont systemFontOfSize:kSTEmojiSize];
        _emojiLabel.textAlignment = NSTextAlignmentCenter;
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageBg = [[UIImageView alloc] initWithFrame:self.bounds];
        imageBg.image = [UIImage imageNamed:@"keyboard_preview_bg.png"];
        [self addSubview:imageBg];
        
        [self addSubview:_emojiLabel];
    }
    return self;
}
- (void)setEmoji:(NSString *)emoji{
    _emojiLabel.text = emoji;
}
@end

#define kSTMinHorizontalPadding 20
#define kSTSectionPadding 10
#define kSTRowCount 5
#define kSTEPTitleHeight 25

@interface STEmojiCollectionView () <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *sectionViews;
@property (strong, nonatomic) NSMutableArray *sectionTitleViews;

@property (strong, nonatomic) STEmojiPreview *emojiPreview;

@end

@implementation STEmojiCollectionView{
    id <UIScrollViewDelegate> _scrollDelegate;
    BOOL _beginTouch,_inPreviewing, _inScolling;
    CGPoint _currentLocation;
    CGFloat _emojiWidth, _emojiHeight;
    CGFloat _horizontalPadding;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self initialized];
        _emojiPreview = [STEmojiPreview new];
        [self addSubview:_emojiPreview];
        _emojiPreview.hidden = YES;
    }
    return self;
}

- (void)initialized{
    self.showsHorizontalScrollIndicator = NO;
    self.multipleTouchEnabled = NO;
    self.exclusiveTouch = YES;
    self.clipsToBounds = NO;
    _inPreviewing = NO;
    _inScolling = NO;
    [super setDelegate:self];
    _sectionViews = [NSMutableArray new];
    _sectionTitleViews = [NSMutableArray new];
    [self prepareForLayout];
}

// 初始化布局参数
- (void)prepareForLayout{
    STEmojiView *tempEmoji = [self makeEmojiView:@"😄"];
    _emojiWidth = CGRectGetWidth(tempEmoji.frame);
    _emojiHeight = CGRectGetHeight(tempEmoji.frame);
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    int column = 0;
    CGFloat w = kSTMinHorizontalPadding;
    while (w < screenWidth){
        column++;
        w += kSTMinHorizontalPadding+_emojiWidth;
    }
    _horizontalPadding = (screenWidth-column*_emojiWidth)/(column+1);
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate{
    _scrollDelegate = delegate;
}

#pragma mark - data

- (void)resetData{
    [_sectionViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_sectionViews removeAllObjects];
    [_sectionTitleViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_sectionTitleViews removeAllObjects];
}

- (void)reloadData{
    [self resetData];
    
    CGFloat sectionLeft = 0;
    for (int section = 0; section < [_emojiDelegate countOfEmojiPageSection]; section++){
        
        UILabel *titleView = [UILabel new];
        titleView.textColor = [UIColor colorWithWhite:0.4 alpha:0.5];
        titleView.font = [UIFont boldSystemFontOfSize:15];
        titleView.text = [_emojiDelegate titleForSection:section];
        [titleView sizeToFit];
        titleView.frame = CGRectMake(sectionLeft+_horizontalPadding, 0, CGRectGetWidth(titleView.frame), kSTEPTitleHeight);
        [_sectionTitleViews addObject:titleView];
        [self addSubview:titleView];
        
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(sectionLeft, 0, 0, CGRectGetHeight(self.bounds))];
        //        sectionView.layer.borderWidth = 1;
        //        sectionView.layer.borderColor = [UIColor yellowColor].CGColor;
        sectionView.userInteractionEnabled = NO;
        [_sectionViews addObject:sectionView];
        [self addSubview:sectionView];
        
        NSArray *emojis = [_emojiDelegate emojisForSection:section];
        
        NSInteger row = kSTRowCount;
        CGFloat left = 0;
        CGFloat top = 0;
        for (int i = 0; i < emojis.count; i++){
            BOOL nextColumn = (i%row)==0;
            if (nextColumn){
                left += _horizontalPadding+((i>0)?_emojiWidth:0);
                top = 0;
            }
            STEmojiView *emojiView = [self makeEmojiView:emojis[i]];
            [emojiView setFrame:CGRectMake(left, top, _emojiWidth,_emojiHeight)];
            top += _emojiHeight;
            [sectionView addSubview:emojiView];
        }
        sectionLeft += left+_emojiWidth+_horizontalPadding;
        sectionView.frame = CGRectMake(CGRectGetMinX(sectionView.frame), kSTEPTitleHeight, sectionLeft-CGRectGetMinX(sectionView.frame), CGRectGetHeight(self.bounds)-kSTEPTitleHeight);
        //        NSLog(@"sectionV:%@",sectionView);
    }
    [self bringSubviewToFront:_emojiPreview];
    self.contentSize = CGSizeMake(sectionLeft, CGRectGetHeight(self.frame));
}

- (void)showSection:(NSInteger)section{
    UIView *sectionView = _sectionViews[section];
    [self setContentOffset:CGPointMake(CGRectGetMinX(sectionView.frame), 0)];
    _inScolling = NO;
}

- (void)showEmojiPreview{
    [self getEmojiFromCurrentLocation:^(CGPoint emojiCenterInSelf, NSString *emoji) {
        if (emoji){
            _emojiPreview.hidden = NO;
            [_emojiPreview setEmoji:emoji];
            [_emojiPreview setCenter:CGPointMake(emojiCenterInSelf.x,emojiCenterInSelf.y-(CGRectGetHeight(_emojiPreview.frame)-_emojiHeight)/2)];
        }
        else{
            _emojiPreview.hidden = YES;
        }
    }];
}

- (void)goPreview{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!_inScolling && _beginTouch){
            _inPreviewing = YES;
            self.scrollEnabled = NO;
            //            NSLog(@"已经预览锁定");
            [self showEmojiPreview];
        }
    });
}

- (void)updateTitlePosition{
    CGPoint offset = self.contentOffset;
    for (int section = 0; section<[_emojiDelegate countOfEmojiPageSection]; section++){
        UILabel *titleLabel = _sectionTitleViews[section];
        UIView *sectionView = _sectionViews[section];
        titleLabel.frame = CGRectMake(MIN(CGRectGetMaxX(sectionView.frame)-CGRectGetWidth(titleLabel.frame)-_horizontalPadding, MAX(CGRectGetMinX(sectionView.frame)+_horizontalPadding, offset.x+_horizontalPadding)), 0, CGRectGetWidth(titleLabel.frame), kSTEPTitleHeight);
    }
}

#pragma mark - get

- (STEmojiView *)makeEmojiView:(NSString *)emoji{
    STEmojiView *emojiView = [STEmojiView new];
    emojiView.emoji = emoji;
    return emojiView;
}

- (void)getEmojiFromCurrentLocation:(void(^)(CGPoint emojiCenterInSelf, NSString *emoji))handler{
    //    NSLog(@"LOCATION: %@",[NSValue valueWithCGPoint:_currentLocation]);
    if (_currentLocation.x>0 && _currentLocation.x<self.contentSize.width && _currentLocation.y>kSTEPTitleHeight && _currentLocation.y<(kSTRowCount*_emojiHeight)+kSTEPTitleHeight){
        NSInteger section = [self sectionForLocation:_currentLocation];
        UIView *sectionView = _sectionViews[section];
        [self getEmojiInBounds:sectionView.bounds
                      location:[self convertPoint:_currentLocation toView:sectionView]
                        emojis:[_emojiDelegate emojisForSection:section]
                       handler:^(CGPoint emojiCenter, NSString *emoji) {
                           if(emoji){
                               handler([self convertPoint:emojiCenter fromView:sectionView], emoji);
                           }
                           else{
                               handler(CGPointZero, nil);
                           }
                       }];
    }
    else{
        handler(CGPointZero, nil);
    }
}

- (void)getEmojiInBounds:(CGRect)bounds
                location:(CGPoint)location
                  emojis:(NSArray *)emojis
                 handler:(void(^)(CGPoint emojiCenter, NSString *emoji))handler{
    //    NSLog(@"VIEW:%@ %@",[NSValue valueWithCGRect:bounds],[NSValue valueWithCGPoint:location]);
    CGFloat w = _horizontalPadding+_emojiWidth;
    NSInteger allColumn = (NSInteger)(ceil(emojis.count/(kSTRowCount*1.0)));
    NSInteger column = (NSInteger)(MAX(location.x-_horizontalPadding/2, 0))/w + 1;
    if (column>allColumn){
        column = allColumn;
    }
    NSInteger row = (NSInteger)(location.y/_emojiHeight) + 1;
    NSInteger count = (column-1)*kSTRowCount + row - 1;
    //    NSLog(@"point: (%ld, %ld)",(long)row,(long)column);
    if (count < emojis.count){
        CGPoint emojiP = CGPointMake(column*(_emojiWidth+_horizontalPadding)-_emojiWidth/2, row*_emojiHeight-_emojiHeight/2);
        //        NSLog(@"-- %@",emojis[count]);
        handler(emojiP, emojis[count]);
    }
    else{
        handler(CGPointZero, nil);
    }
}

- (NSInteger)sectionForLocation:(CGPoint)location{
    if (location.x < 0){
        return 0;
    }
    else if (location.x > self.contentSize.width-CGRectGetWidth(self.frame)){
        return [_emojiDelegate countOfEmojiPageSection]-1;
    }
    NSInteger section = 0;
    for (;section<_sectionViews.count;section++){
        UIView *sectionView = _sectionViews[section];
        if (CGRectContainsPoint(sectionView.frame, location)){
            return section;
        }
    }
    return NSNotFound;
}

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _beginTouch = YES;
    _currentLocation = [[touches anyObject] locationInView:self];
    if (!_inScolling && !_inPreviewing){
        [self goPreview];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    _currentLocation = [[touches anyObject] locationInView:self];
    if (_inPreviewing){
        //        NSLog(@"滑动--->预览");
        [self showEmojiPreview];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchDidEnd];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchDidEnd];
}

- (void)touchDidEnd{
    if (!_inScolling){
        [self getEmojiFromCurrentLocation:^(CGPoint emojiCenterInSelf, NSString *emoji) {
            //            NSLog(@"结束点击: %@",emoji);
            if (emoji){
                if (!_inPreviewing){
                    [self showEmojiPreview];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_inPreviewing?0:0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _emojiPreview.hidden = YES;
                });
                [_emojiDelegate emojiDidClicked:emoji];
            }
        }];
    }
    _beginTouch = NO;
    _inPreviewing = NO;
    self.scrollEnabled = YES;
}

#pragma mark - scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!_inScolling){
        //        NSLog(@"开始滑动 无法预览");
    }
    _inPreviewing = NO;
    _inScolling = YES;
    [self updateTitlePosition];
    if ([_emojiDelegate respondsToSelector:@selector(didScrollToSection:)]){
        [_emojiDelegate didScrollToSection:[self sectionForLocation:CGPointMake(scrollView.contentOffset.x, kSTEPTitleHeight+10)]];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate){
        _inScolling = NO;
        //        NSLog(@"1结束滑动");
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x>=0 && scrollView.contentOffset.x<=(scrollView.contentSize.width-CGRectGetWidth(scrollView.bounds))){
        _inScolling = NO;
        //        NSLog(@"2结束滑动");
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    _inScolling = NO;
}

@end

