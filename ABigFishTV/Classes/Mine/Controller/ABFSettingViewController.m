//
//  ABFSettingViewController.m
//  ABigFishTV
//
//  Created by 陈立宇 on 17/12/5.
//  Copyright © 2017年 陈立宇. All rights reserved.
//

#import "ABFSettingViewController.h"
#import "AppDelegate.h"
#import "ABFNavigationBarView.h"
#import "ABFMineSimpleCell.h"
#import "ABFCacheManager.h"
#import "ABFMineViewController.h"
#import <PPNetworkHelper.h>
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZLocationManager.h"

@interface ABFSettingViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    NSMutableArray *_selectedAssets;
    NSMutableArray *_selectedPhotos;
    BOOL _isSelectOriginalPhoto;
}

@property(nonatomic,strong) ABFNavigationBarView *naviView;

@property(nonatomic,strong) NSMutableArray  *menuArray;

@property(nonatomic,assign) CGFloat cacheSize;

@property(nonatomic,strong) UIView *footerView;

@property(nonatomic,weak)   UIButton *loginout;

@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@end

@implementation ABFSettingViewController

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.title=@"test";
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


- (NSMutableArray*)menuArray{
    
    if(_menuArray == nil){
        _menuArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"settings.plist" ofType:nil]];
    }
    return _menuArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self addTableView];
    [self loaddata];
    [self addTableFooterView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏
    [AppDelegate APP].allowRotation = false;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setStatusBarBackgroundColor:COMMON_COLOR];
    [self.tabBarController.tabBar setHidden:YES];
    [self addNavigationBarView];
    if ([AppDelegate APP].user) {
        _loginout.hidden = NO;
    }else{
        _loginout.hidden = YES;
    }
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    _tableView.frame = CGRectMake(0, statusBar.frame.size.height+40, kScreenWidth, kScreenHeight -(statusBar.frame.size.height+40));
    
}

- (void)addNavigationBarView{
    
    self.title = @"设置";
    [self.navigationController.navigationBar setBarTintColor:COMMON_COLOR];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(backClick:)
      forControlEvents:UIControlEventTouchUpInside];
    //leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    //leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0,0,20,20);
    //leftBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [leftBtn setImage:[UIImage imageNamed:@"icon_lightback"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;

    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
}


- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (void) addTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = LINE_BG;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    
    [self.view addSubview:tableView];
    [tableView registerClass:[ABFMineSimpleCell class] forCellReuseIdentifier:@"mycell"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    
}

-(void) addTableFooterView{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-60-statusBar.frame.size.height, kScreenWidth, 60)];
    footerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:footerView];
    //_tableView.tableFooterView = footerView;
    _footerView = footerView;
    UIButton *loginout = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginout setTitle:@"退出" forState:UIControlStateNormal];
    loginout.backgroundColor = [UIColor redColor];
    [loginout setTintColor:COMMON_COLOR];
    [loginout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginout.layer.masksToBounds = YES;
    loginout.layer.cornerRadius = 5.0;
    [loginout addTarget:self action:@selector(loginoutAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:loginout];
    //_loginBtn = loginBtn;
    _loginout = loginout;
    [loginout mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.footerView.mas_top).offset(10);
        make.centerX.equalTo(self.footerView.mas_centerX);
        make.left.equalTo(self.footerView.mas_left).offset(5);
        make.right.equalTo(self.footerView.mas_right).offset(-5);
    }];
    
    
}

-(void)loaddata{
    
    [self.tableView reloadData];
}

-(void)loginoutAction:(id)sender{
    NSLog(@"out...");
    [AppDelegate APP].user = nil;
    //ABFMineViewController *vc = [[ABFMineViewController alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
    //[self.navigationController popToViewController:vc animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate logoutAction];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.menuArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = [self.menuArray[indexPath.row] objectForKey:@"name"];
    NSString *icon  = [self.menuArray[indexPath.row] objectForKey:@"icon"];
    ABFMineSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    /*
     ABFMineSimpleCell *cell = [[ABFMineSimpleCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) title:title];*/
    [cell setTitle:title];
    if([title isEqualToString:@"清理缓存"]){
        [cell setDesc:[self getCacheSize]];
    }
    if([title isEqualToString:@"上传头像"]){
        cell.profile.hidden = NO;
        NSString *url = [AppDelegate APP].user.profile;
        [cell setProfileUrl:url];
    }
    [cell setIconName:icon];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(NSString *) getCacheSize{
    
    CGFloat cacheSize = [ABFCacheManager manager].filePath;
    NSLog(@"cache size %f",_cacheSize);
    NSString *strCacheSize = [NSString stringWithFormat:@"%f",cacheSize];
    strCacheSize = [strCacheSize substringWithRange:NSMakeRange(0, 3)];
    strCacheSize = [strCacheSize stringByAppendingString:@"M"];
    
    return strCacheSize;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    ABFMineSimpleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    NSString *title = [self.menuArray[indexPath.row] objectForKey:@"name"];
    //TZImagePickerController *pickerController=nil;
    if([title isEqualToString:@"上传头像"]){
    
        __weak typeof(self)weakSelf = self;
        
        TZImagePickerController *pickerController = [[TZImagePickerController alloc]initWithMaxImagesCount:1 columnNumber:4 delegate:weakSelf pushPhotoPickerVc:YES];
        
        pickerController.allowCrop = NO;
        pickerController.title = @"图库";
        [pickerController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photo, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos= photo.mutableCopy;
            NSData *imageData = UIImagePNGRepresentation(_selectedPhotos[0]);
            UIImage *image=[UIImage imageWithData:imageData];
            
            //NSLog(@"photo == %@, assets == %@",photo,assets);
            //[weakSelf.tableView reloadData];
            
            NSString *fullUrl = [BaseUrl stringByAppendingString:UserProfile];
            
            NSNumber *uid = [NSNumber numberWithInteger:[AppDelegate APP].user.id];
            NSDictionary *params = @{@"id":uid};
            //NSURL *url = [NSURL URLWithString:_playUrl];
            //UIImage *image = _player.getImage;
            NSMutableArray<NSString *> *fileNames = [NSMutableArray new];
            [fileNames addObject:@"headIcon.png"];
            [PPNetworkHelper uploadImagesWithURL:fullUrl parameters:params name:@"profile" images:_selectedPhotos fileNames:[fileNames mutableCopy] imageScale:1.0f imageType:@"png" progress:^(NSProgress *progress) {
                
            } success:^(id responseObject) {
                NSObject *obj = [responseObject objectForKey:@"data"];
                ABFUserInfo *model = [ABFUserInfo mj_objectWithKeyValues:obj];
                [AppDelegate APP].user.profile = model.profile;
                [cell setProfileImage:image];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            } failure:^(NSError *error) {
                 NSLog(@"error = %@",error);
            }];
            /*
            [[ABFHttpManager manager]POST:fullUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //NSURL *url = [NSURL URLWithString:_playUrl];
                NSData *imageData = UIImagePNGRepresentation(image);
                [formData appendPartWithFileData:imageData name:@"profile" fileName:@"headIcon.png" mimeType:@"image/png"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                NSObject *obj = [responseObject objectForKey:@"data"];
                ABFUserInfo *model = [ABFUserInfo mj_objectWithKeyValues:obj];
                [AppDelegate APP].user.profile = model.profile;
                [cell setProfileImage:image];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@",error);
            }];*/
            
            
            
            
            
        }];
        [self presentViewController:pickerController animated:YES completion:nil];
    }
    
}

-(void)backClick:(id)sender{
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                /*
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        
                    }];
                }];*/
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:NO completion:^(TZAlbumModel *model){
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
    [self.tableView reloadData];
    
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
