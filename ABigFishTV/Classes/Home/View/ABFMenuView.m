//
//  ABFMenuView.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/10/12.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFMenuView.h"
#import "ABFImageMenu.h"


@implementation ABFMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame menuArray:(NSMutableArray *)menuArray{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        self.backgroundColor = [UIColor whiteColor];
        
        
    
    }
    
    return self;

}

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if(self){
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    
    return self;
}

-(void)setMenuArray:(NSMutableArray *)menuArray{
    _menuArray = menuArray;
    for(int i = 0; i < 8; i++){
        
        if (i < 4) {
            
            CGRect frame = CGRectMake(i*kScreenWidth/4, 0, kScreenWidth/4, 80);
            NSString *title = [menuArray[i] objectForKey:@"name"];
            NSString *imageName = [menuArray[i] objectForKey:@"image"];
            NSString *url = [menuArray[i] objectForKey:@"url"];
            
            ABFImageMenu *menu = [[ABFImageMenu alloc] initWithFrame:frame title:title imageName:imageName imageWidth:34];
            
            
            menu.tag = i;
            menu.title = title;
            menu.url = url;
            [self addSubview:menu];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapMenu:)];
            [menu addGestureRecognizer:tap];
            
        }else if(i<8){
            
            CGRect frame = CGRectMake((i-4)*kScreenWidth/4, 80, kScreenWidth/4, 80);
            NSString *title = [menuArray[i] objectForKey:@"name"];
            NSString *imageName = [menuArray[i] objectForKey:@"image"];
            NSString *url = [menuArray[i] objectForKey:@"url"];
            ABFImageMenu *menu = [[ABFImageMenu alloc] initWithFrame:frame title:title imageName:imageName imageWidth:34];
            menu.tag = i;
            menu.title = title;
            menu.url = url;
            
            [self addSubview:menu];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapMenu:)];
            [menu addGestureRecognizer:tap];
        }
        
        
    }
}

-(void)OnTapMenu:(id)sender{
    //NSLog(@"tag:%ld",sender.view.tag);
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    
    ABFImageMenu *menu = (ABFImageMenu *)tap.view;
    NSString *title = [self.menuArray[menu.tag] objectForKey:@"name"];
    NSLog(@"tag:%@",title);
    
    if ([self.delegate respondsToSelector:@selector(pushVC:name:url:)]) {
        [self.delegate pushVC:sender name:title url:menu.url];
    }
    
    
    
}


@end
