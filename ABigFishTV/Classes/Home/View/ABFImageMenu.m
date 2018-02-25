//
//  ABFImageMenu.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/12.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFImageMenu.h"

@implementation ABFImageMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName imageWidth:(CGFloat)width{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-width/2, 15, width, width)];
        //imageView.backgroundColor = [UIColor blackColor];
        imageView.layer.shadowColor = LINE_BG.CGColor;//shadowColor阴影颜色
        imageView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        imageView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        imageView.layer.shadowRadius = 2;
        imageView.image = [UIImage imageNamed:imageName];
        [self addSubview:imageView];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+width, frame.size.width, 20)];
        titleLable.text = title;
        titleLable.textColor = [UIColor darkGrayColor];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont fontWithName:FONTNAME size:14];
        [self addSubview:titleLable];
        
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addImageView];
        [self addTitleLab];
    }
    return self;
}

-(void)addImageView{
    
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-width/2, 15, width, width)];
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.layer.shadowColor = LINE_BG.CGColor;//shadowColor阴影颜色
    imageView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    imageView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    imageView.layer.shadowRadius = 2;
    //imageView.image = [UIImage imageNamed:imageName];
    [self addSubview:imageView];
    _imageView = imageView;

}

-(void)addTitleLab{

    //UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+width, frame.size.width, 20)];
    UILabel *titleLable = [[UILabel alloc] init];
    //titleLable.text = title;
    titleLable.textColor = [UIColor darkGrayColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont fontWithName:FONTNAME size:14];
    [self addSubview:titleLable];
    _titleLab = titleLable;
}

-(void)setTitle:(NSString *)title{
    _titleLab.text = title;
}

-(void)setWidth:(CGFloat)width{
    _width = width;
}

-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    _imageView.image = [UIImage imageNamed:imageName];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = CGRectMake(self.frame.size.width/2-self.width/2, 15, self.width, self.width );
    _titleLab.frame = CGRectMake(0, 20+self.width, self.frame.size.width, 20);
}


@end
