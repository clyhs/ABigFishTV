//
//  ABFImageMenu.h
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/12.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABFImageMenu : UIView

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *url;

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,strong) NSString *imageName;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName imageWidth:(CGFloat) width;

@end
