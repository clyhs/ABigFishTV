//
//  ABFPhotoViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/22.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFPhotoViewController.h"
#import "ABFChatInfo.h"
#import "ABFInfo.h"
#import "ABFNavigationBarView.h"

@interface ABFPhotoViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *photoScrollView;
@property(nonatomic,assign) NSInteger count;
@property(nonatomic,strong) ABFNavigationBarView *naviView;
@property(nonatomic,strong) UILabel *contentlab;
@property(nonatomic,strong) UILabel *photoLab;
@property(nonatomic,assign) NSInteger currentIndex;

@end

@implementation ABFPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self setContntLabUI];
    [self setScrollViewUI];
    [self setImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [self addNavigationBarView];
    
}

- (void)addNavigationBarView{
    
    //self.title = @"图集";
    
    ABFNavigationBarView *naviView = [[ABFNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    //naviView.title = self.title;
    naviView.backgroundColor = [UIColor blackColor];
    [naviView setLeftBtnImageName:@"icon_lightback"];
    naviView.backBtn.backgroundColor = [UIColor blackColor];
    naviView.backBtn.alpha = 0.5;
    naviView.backBtn.layer.masksToBounds = YES;
    naviView.backBtn.layer.cornerRadius = 15;
    naviView.backBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    naviView.backBtn.layer.borderWidth = 0;
    [self.view addSubview:naviView];
    _naviView = naviView;
    
    _photoLab = [[UILabel alloc] init];
    _photoLab.frame = CGRectMake(kScreenWidth-80, 28, 60, 20);
    _photoLab.font = [UIFont systemFontOfSize:18];
    _photoLab.textAlignment = NSTextAlignmentRight;
    _photoLab.textColor = [UIColor whiteColor];
    _photoLab.text = [NSString stringWithFormat:@"(1/%ld)",self.model.images.count];
    [naviView addSubview:_photoLab];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}

-(void)setContntLabUI{
    
    _contentlab = [[UILabel alloc] init];
    _contentlab.backgroundColor = [UIColor clearColor];
    _contentlab.frame = CGRectMake(10, 64, kScreenWidth-20, self.model.contextHeight2);
    NSLog(@"%f",self.model.contextHeight2);
    _contentlab.numberOfLines = 0;
    _contentlab.font = [UIFont systemFontOfSize:18];
    _contentlab.textColor = [UIColor whiteColor];
    _contentlab.text = self.model.context;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.model.context];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 0;//缩进
    style.firstLineHeadIndent = 0;
    style.lineSpacing = 6;//行距
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    _contentlab.attributedText = text;
    [self.view addSubview:_contentlab];

}


-(void)setScrollViewUI{
    NSArray *images = [ABFInfo mj_keyValuesArrayWithObjectArray:self.model.images];
    NSUInteger count = images.count;
    _photoScrollView = [[UIScrollView alloc] init];
    _photoScrollView.frame = CGRectMake(0, 0, kScreenWidth, 400);
    _photoScrollView.contentOffset = CGPointZero;
    _photoScrollView.contentSize = CGSizeMake(kScreenWidth * count, 0);
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.delegate = self;
    _photoScrollView.pagingEnabled = YES;
    [self.view addSubview:_photoScrollView];

}

- (void)setImageView
{
    NSArray *images = [ABFInfo mj_keyValuesArrayWithObjectArray:self.model.images];
    NSUInteger count = images.count;
    for (int i = 0; i < count; i++) {
        UIImageView *photoImgView = [[UIImageView alloc]init];
        photoImgView.frame = CGRectMake(self.photoScrollView.frame.size.width*i, 64, self.photoScrollView.frame.size.width, self.photoScrollView.frame.size.height);
        // 图片的显示格式为合适大小
        photoImgView.contentMode= UIViewContentModeScaleAspectFit;
        
        [self.photoScrollView addSubview:photoImgView];
    }
    [self setImgWithIndex:0];
    
    
}

/** 滚动完毕时调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = self.photoScrollView.contentOffset.x / self.photoScrollView.frame.size.width;
    self.currentIndex = index +1;
    // 添加图片
    [self setImgWithIndex:index];
    //NSLog(@"index=%ld",index);
    _photoLab.text = [NSString stringWithFormat:@"(%ld/%ld)",self.currentIndex,self.model.images.count];
    
    // 添加文字
    // NSString *countNum = [NSString stringWithFormat:@"%d/%ld",index+1,self.photoSet.photos.count];
    //self.countLabel.text = countNum;
    
    // 添加内容
    //[self setContentWithIndex:index];
}

/** 懒加载添加图片！这里才是设置图片 */
- (void)setImgWithIndex:(int)i
{
    UIImageView *photoImgView = nil;
    //self.currentIndex = i;
    
    photoImgView = self.photoScrollView.subviews[i];
    
    
    NSArray *images = [ABFInfo mj_keyValuesArrayWithObjectArray:self.model.images];
    ABFInfo *info = images[i];
    
    NSURL *purl = [NSURL URLWithString:info.url];
    NSLog(@"url=%@",purl);
    // 如果这个相框里还没有照片才添加
    if (photoImgView.image == nil) {
        //        [photoImgView sd_setImageWithURL:purl placeholderImage:[UIImage imageNamed:@"photoview_image_default_white"]];
        
        [photoImgView sd_setImageWithURL:purl placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            UIColor *color = [self mostColor:photoImgView.image];
            self.photoScrollView.backgroundColor = color;
        }];
    }
}

static void RGBtoHSV( float r, float g, float b, float *h, float *s,float *v)
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}

-(UIColor*)mostColor:(UIImage*)image{
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    
    //先把图片缩小
    CGSize thumbSize=CGSizeMake(40, 40);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    NSArray *MaxColor=nil;
    // NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    float maxScore=0;
    for (int x=0; x<thumbSize.width*thumbSize.height; x++) {
        
        int offset = 4*x;
        
        int red = data[offset];
        int green = data[offset+1];
        int blue = data[offset+2];
        int alpha =  data[offset+3];
        
        if (alpha<25)continue;
        
        float h,s,v;
        RGBtoHSV(red, green, blue, &h, &s, &v);
        
        float y = MIN(abs(red*2104+green*4130+blue*802+4096+131072)>>13, 235);
        y= (y-16)/(235-16);
        if (y>0.9) continue;
        
        float score = (s+0.1)*x;
        if (score>maxScore) {
            maxScore = score;
        }
        MaxColor=@[@(red),@(green),@(blue),@(alpha)];
        //[cls addObject:clr];
    }
    CGContextRelease(context);
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:(0.2)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
