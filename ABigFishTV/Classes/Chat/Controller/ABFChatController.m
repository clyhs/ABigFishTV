//
//  ABFChatController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/11/26.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFChatController.h"
#import "ABFChatToolBar.h"
#import "AppDelegate.h"
#import "BRPlaceholderTextView.h"
#import "ABFImageCollectionCell.h"
#import <PPNetworkHelper.h>
#import "ABFResultInfo.h"
#import "MBProgressHUD.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZLocationManager.h"
#import "STEmojiKeyboard.h"
#import "JHUD.h"


@interface ABFChatController ()<UITextViewDelegate,ABFChatToolBarDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate >{
    float noteTextHeight;
    NSMutableArray *_selectedAssets;
    NSMutableArray *_selectedPhotos;
    BOOL _isSelectOriginalPhoto;
}
@property (nonatomic)         JHUD                  *hudView;
@property (nonatomic, strong) UIScrollView          *mainScrollView;
@property (nonatomic, strong) BRPlaceholderTextView *noteTextView;
//背景
@property (nonatomic, strong) UIView                *noteTextBackgroudView;
//文字个数提示label
@property (nonatomic, strong) UILabel               *textNumberLabel;
//图片
@property (nonatomic,strong)  UIImageView           *photoImageView;
@property (nonatomic,strong)  UIView                *lineView;

@property (strong, nonatomic) STEmojiKeyboard       *keyboard;

@property (nonatomic, weak)   ABFChatToolBar        *toolBar;
@property (nonatomic, strong) UIBarButtonItem       *rightItem;
@property (nonatomic, assign) BOOL                  isEmojiKeyboard;

//@property (nonatomic, strong) NSMutableArray *images;
@property (strong, nonatomic) CLLocation            *location;
@property (nonatomic,strong) UIImagePickerController *imagePickerVc;

@end

@implementation ABFChatController

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        //_imagePickerVc.title=@"test";
        if (iOS7Later) {
            _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        }
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
            
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

- (NSMutableArray *)selectedPhotos
{
    if (_selectedPhotos == nil) {
        _selectedPhotos = [NSMutableArray array];
    }
    
    return _selectedPhotos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _selectedAssets = [NSMutableArray array];
    self.isEmojiKeyboard = NO;
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
    /*
    emojiKeyboardView = [[AGEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216) dataSource:self];
    emojiKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    emojiKeyboardView.delegate = self;*/
    _keyboard = [STEmojiKeyboard keyboard];
    // 设置导航条
    [self setUpNavgationBar];
    
    [self createUI];
    
    [self setUpToolBar];
    
    [self addCollectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegate APP].allowRotation = false;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBarTintColor:RGB_255(250, 250, 250)];
    self.navigationController.navigationBar.translucent = NO;
    [self.tabBarController.tabBar setHidden:YES];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
}

- (void)setUpNavgationBar
{
    self.title = @"微话题";
    // left
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:0 target:self action:@selector(dismiss)];
    // right
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"发表" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [btn sizeToFit];
    // 监听按钮点击
    [btn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    rightItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = rightItem;
    _rightItem = rightItem;
}

- (void)createUI{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.navigationController.navigationBar.frame.size.height-statusBar.frame.size.height)];
    _mainScrollView.contentSize =CGSizeMake(kScreenWidth, kScreenHeight);
    _mainScrollView.bounces =YES;
    _mainScrollView.showsVerticalScrollIndicator = false;
    _mainScrollView.backgroundColor = LINE_BG;
    [self.view addSubview:_mainScrollView];
    [_mainScrollView setDelegate:self];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = LINE_BG;
    [self.mainScrollView addSubview:self.lineView];
    
    _noteTextView = [[BRPlaceholderTextView alloc]init];
    _noteTextView.keyboardType = UIKeyboardTypeDefault;
    //文字样式
    [_noteTextView setFont:[UIFont systemFontOfSize:14]];
    _noteTextView.maxTextLength = 200;
    [_noteTextView setTextColor:[UIColor blackColor]];
    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont systemFontOfSize:14];
    _noteTextView.placeholder= @"    发表微话题...";
    self.noteTextView.returnKeyType = UIReturnKeyDone;
    [self.noteTextView setPlaceholderColor:[UIColor lightGrayColor]];
    [self.noteTextView setPlaceholderOpacity:1];
    _noteTextView.textContainerInset = UIEdgeInsetsMake(5, 15, 5, 15);
    
    
    
    
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _textNumberLabel.backgroundColor = [UIColor whiteColor];
    _textNumberLabel.text = [NSString stringWithFormat:@"0/%d    ",200];
    
    
    
    [_mainScrollView addSubview:_noteTextView];
    [_mainScrollView addSubview:_textNumberLabel];
    
    [self updateViewsFrame];
}

- (void)setUpToolBar
{
    CGFloat h = 35;
    CGFloat y = self.mainScrollView.height - h ;
    ABFChatToolBar *toolBar = [[ABFChatToolBar alloc] initWithFrame:CGRectMake(0, y, self.mainScrollView.width, h)];
    toolBar.backgroundColor = [UIColor whiteColor];
    _toolBar = toolBar;
    toolBar.delegate = self;
    [self.view addSubview:toolBar];
}

- (void)updateViewsFrame{

    if (!noteTextHeight) {
        noteTextHeight = 100;
    }
    
    //_noteTextBackgroudView.frame = CGRectMake(0, 0, kScreenWidth, 200);
    //文本编辑框
    _noteTextView.frame = CGRectMake(0, 0, kScreenWidth, noteTextHeight);
    _lineView.frame = CGRectMake(0, self.noteTextView.frame.origin.y+self.noteTextView.frame.size.height, kScreenWidth, 0.5);
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15      , kScreenWidth-10, 15);
    
    /*
    if(!_collectionFrameY){
        _collectionFrameY = self.noteTextView.frame.origin.y+150+20;
    }*/
    [self updatePickerViewFrameY:self.noteTextView.frame.origin.y + self.noteTextView.frame.size.height];
     
}

- (void)updatePickerViewFrameY:(CGFloat)Y{
    
    _collectionFrameY = Y;
    //_collectionView.frame = CGRectMake(0, Y+1, kScreenWidth, (((float)kScreenHeight-64.0) /3.0 +20.0)+20.0);
    _collectionView.frame = CGRectMake(0, Y+1, kScreenWidth, (kScreenWidth/3)*((int)(self.selectedPhotos.count/3+1)) + 20);
    //* ((int)(self.selectedPhotos.count)/3 +1)
}


-(void)addCollectionView{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    
    [self.mainScrollView addSubview:self.collectionView];
    
    
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor =LINE_BG;
    
    [_collectionView registerClass:[ABFImageCollectionCell class] forCellWithReuseIdentifier:@"myCell"];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedPhotos.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ABFImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"myCell" forIndexPath:indexPath];
    
    if (indexPath.row == self.selectedPhotos.count) {
        [cell.profilePhoto setImage:[UIImage imageNamed:@"plus"]];
        cell.closeButton.hidden = YES;
        
    }else{
        [cell.profilePhoto setImage:self.selectedPhotos[indexPath.item]];
        cell.closeButton.hidden = NO;
    }
    cell.profilePhoto.tag = [indexPath item];
    
    //添加图片cell点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    singleTap.numberOfTapsRequired = 1;
    cell.profilePhoto .userInteractionEnabled = YES;
    [cell.profilePhoto  addGestureRecognizer:singleTap];
    
    cell.closeButton.tag = [indexPath item];
    [cell.closeButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    [self changeCollectionViewHeight];
    return cell;
}
#pragma mark <UICollectionViewDelegate>
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-64) /3 ,(kScreenWidth-64) /3);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 8, 20, 8);
}

- (void)changeCollectionViewHeight{
    
    if(_collectionFrameY){
        _collectionView.frame = CGRectMake(0, _collectionFrameY, kScreenWidth, (((float)kScreenWidth-64.0) /3.0 +20.0)+20.0);
    }else{
        _collectionView.frame = CGRectMake(0, 0, kScreenWidth, (((float)kScreenWidth-64.0) /3.0 +20.0)+20.0);
    }
    //* ((int)(self.selectedPhotos.count)/3 +1)
    
    [self pickerViewFrameChanged];
}

- (void)pickerViewFrameChanged{
    [self updateViewsFrame];
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //当前输入字数
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_noteTextView.text.length,200];
    if (_noteTextView.text.length > 200) {
        _textNumberLabel.textColor = [UIColor redColor];
    }else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    [self textChanged];
    return YES;
}

//文本框每次输入文字都会调用  -> 更改文字个数提示框
- (void)textViewDidChangeSelection:(UITextView *)textView{
    //
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_noteTextView.text.length,200];
    if (_noteTextView.text.length > 200) {
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    [self textChanged];
}

/**
 *  文本高度自适应
 */
-(void)textChanged{
    
    CGRect orgRect = self.noteTextView.frame;//获取原始UITextView的frame
    
    //获取尺寸
    CGSize size = [self.noteTextView sizeThatFits:CGSizeMake(self.noteTextView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height=size.height+10;//获取自适应文本内容高度
    
    
    //如果文本框没字了恢复初始尺寸
    if (orgRect.size.height > 100) {
        noteTextHeight = orgRect.size.height;
    }else{
        noteTextHeight = 100;
    }
    if (_noteTextView.text.length) { // 有内容
        _rightItem.enabled = YES;
    }else{
        _rightItem.enabled = NO;
    }
    [self updateViewsFrame];
}


#pragma mark - 图片cell点击事件
//点击图片看大图
- (void) tapProfileImage:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
    
    UIImageView *tableGridImage = (UIImageView*)gestureRecognizer.view;
    NSInteger index = tableGridImage.tag;
    
    if (index == (self.selectedPhotos.count)) {
        [self.view endEditing:YES];
        //添加新图片
        [self addNewImg];
    }else{
    }
}

#pragma mark - 选择图片
- (void)addNewImg{
    NSLog(@"addnewimages");

    __weak typeof(self)weakSelf = self;
    
    TZImagePickerController *pickerController = [[TZImagePickerController alloc]initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    pickerController.allowCrop = NO;
    pickerController.title = @"图库";
    [pickerController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        //self.images= photo.mutableCopy;
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        _isSelectOriginalPhoto = isSelectOriginalPhoto;
        //NSLog(@"photo == %@, assets == %@",photo,assets);
        [weakSelf.collectionView reloadData];
    }];
    [self presentViewController:pickerController animated:YES completion:nil];
     
}

- (void)deletePhoto:(UIButton *)sender{
    
    [self.selectedPhotos removeObjectAtIndex:sender.tag];
    
    
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:sender.tag inSection:0]]];
    
    for (NSInteger item = sender.tag; item <= self.selectedPhotos.count; item++) {
        ABFImageCollectionCell *cell = (ABFImageCollectionCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
        cell.closeButton.tag--;
        cell.profilePhoto.tag--;
    }
    
    [self changeCollectionViewHeight];
}

//#pragma mark - 选择图片完成的时候调用
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    // 获取选中的图片
//    UIImage *image = info[UIImagePickerControllerOriginalImage];
//    
//    [self.selectedPhotos addObject:image];
//    //_photosView.image = image;
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    _rightItem.enabled = YES;
//    [self.collectionView reloadData];
//}


- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 键盘的Frame改变的时候调用
- (void)keyboardFrameChange:(NSNotification *)note
{
    
    // 获取键盘弹出的动画时间
    CGFloat durtion = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 获取键盘的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"y=%f",frame.origin.y);
    NSLog(@"h=%f",self.view.height);
    if (frame.origin.y == self.view.height) { // 没有弹出键盘
        [UIView animateWithDuration:durtion animations:^{
            _toolBar.transform =  CGAffineTransformIdentity;
        }];
    }else{ // 弹出键盘
        // 工具条往上移动258
        [UIView animateWithDuration:durtion animations:^{
            
            _toolBar.transform = CGAffineTransformMakeTranslation(0, -frame.size.height);
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)submitClick:(id)sender{
    NSLog(@"...");
    NSString *fullUrl = [BaseUrl stringByAppendingString:ChatAddUrl];
    if([AppDelegate APP].user){
    
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:[NSString stringWithFormat:@"%ld",[AppDelegate APP].user.id] forKey:@"user_id"];
        [params setObject:[NSString stringWithFormat:@"%d",1] forKey:@"type_id"];
       
        NSString *context = [self.noteTextView.text stringByReplacingEmojiUnicodeWithCheatCodes];
        NSLog(@"context=%@",context);
        [params setObject:context forKey:@"context"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableArray<NSString *> *fileNames = [NSMutableArray new];
        NSMutableArray<NSString *> *names = [NSMutableArray new];
        if(self.selectedPhotos.count>0){
            for(int i=0;i<self.selectedPhotos.count;i++){
                [fileNames addObject:@"headIcon.png"];
                [names addObject:[NSString stringWithFormat:@"file_%d",i+1]];
            }
        }
        self.hudView.messageLabel.text = @"数据加载中...";
        [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
        [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
        [PPNetworkHelper setResponseSerializer:PPResponseSerializerHTTP];
        
        
        
        [PPNetworkHelper uploadImagesWithURL2:fullUrl parameters:params name:names images:[self.selectedPhotos mutableCopy] fileNames:[fileNames mutableCopy] imageScale:1.0f imageType:@"png" progress:^(NSProgress *progress) {
            NSLog(@"%lf",1.0*progress.completedUnitCount/progress.totalUnitCount);
        } success:^(id responseObject) {
            ABFResultInfo *result = [ABFResultInfo mj_objectWithKeyValues:responseObject];
            NSLog(@"desc=%@",result.desc);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismiss];
        } failure:^(NSError *error) {
            NSLog(@"error = %@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        /*
        [[ABFHttpManager manager]POST:fullUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if(self.selectedPhotos.count>0){
                for(int i=0;i<self.selectedPhotos.count;i++){
                    NSData *imageData = UIImagePNGRepresentation(self.selectedPhotos[i]);
                    [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file_%d",i+1] fileName:@"headIcon.png" mimeType:@"image/png"];
                }
            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"upload success");
            ABFResultInfo *result = [ABFResultInfo mj_objectWithKeyValues:responseObject];
            NSLog(@"desc=%@",result.desc);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismiss];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];*/
    }
    
}

-(void)chatToolBar:(ABFChatToolBar *)toolBar didClickBtn:(NSInteger)index{

    if(index == 0){
        
        __weak typeof(self)weakSelf = self;
        
        TZImagePickerController *pickerController = [[TZImagePickerController alloc]initWithMaxImagesCount:3 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
        pickerController.allowCrop = NO;
        //pickerController.title = @"图库";
        [pickerController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photo, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos= photo.mutableCopy;
            
            NSLog(@"photo == %@, assets == %@",photo,assets);
            [weakSelf.collectionView reloadData];
        }];
        [self presentViewController:pickerController animated:YES completion:nil];
    }else if(index == 1){
        [self takePhoto];
    }else if(index == 4){
        NSLog(@"emoji");
        self.isEmojiKeyboard = !self.isEmojiKeyboard;
        if(self.isEmojiKeyboard){
            [_keyboard setTextView:self.noteTextView];
        }else{
            self.noteTextView.inputView = nil;
        }
        [self.noteTextView reloadInputViews];
        [self.noteTextView becomeFirstResponder];
        
    }
    
}

-(void)onClickImage:(id)sender{

}

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:NO completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
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
