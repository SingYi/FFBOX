//
//  FFMineViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMineViewController.h"

#import "FFUserModel.h"
#import "SDWebImageDownloader.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

#import "FFMineHeaderView.h"
#import "FFMineCoinView.h"
#import "FFMineSelectView.h"
#import "FFResetNickNameView.h"

#import "FFLoginViewController.h"           //登录页面

#import "FFSignInViewController.h"          //每日签到
#import "FFInviteFriendViewController.h"    //邀请好友
#import "FFCustomerServiceViewController.h" //客服中心
#import "FFMyPackageViewController.h"       //我的礼包
#import "FFMyCollectionViewController.h"    //我的收藏
#import "FFTransferServerViewController.h"  //申请转游
#import "FFSettingViewController.h"         //设置页面
#import "FFChangePasswordViewController.h"  //修改密码
#import "FFAboutViewController.h"           //关于

#import "FFGoldCenterViewController.h"      //金币中心
#import "FFPlatformDetailViewController.h"  //平台币明细
#import "FFOpenVipViewController.h"         //开通 Vip
#import "FFWebViewController.h"             //网页


#define BUTTON_TAG 10086
#define CurrentUser [FFUserModel currentUser]
#define NotLogIn if (_uid == nil || _uid.length == 0) {\
                    BOX_MESSAGE(@"尚未登录");\
                    break;\
                 }\


@interface FFMineViewController () <FFmineHeaderViewDelegate, FFMineSelectViewDelegate, FFRestNickNameDelegate, FFMineCoinViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/** 用户 uid */
@property (nonatomic, strong) NSString *uid;

/** 头部视图 */
@property (nonatomic, strong) FFMineHeaderView *headerView;
/** 币 */
@property (nonatomic, strong) FFMineCoinView *coinView;
/** 选择视图 */
@property (nonatomic, strong) FFMineSelectView *selectView;

/** viewControllers */
//@property (nonatomic, strong) NSArra
/** 每日签到控制器 */
@property (nonatomic, strong) FFSignInViewController *signInViewController;
/** 邀请好友 */
@property (nonatomic, strong) FFInviteFriendViewController *inviteFriendViewController;
/** 客服中心 */
@property (nonatomic, strong) FFCustomerServiceViewController *customerServiceViewController;
/** 我的礼包 */
@property (nonatomic, strong) FFMyPackageViewController *myPackageViewController;
/** 我的收藏 */
@property (nonatomic, strong) FFMyCollectionViewController *myCollectionViewController;
/** 申请转游 */
@property (nonatomic, strong) FFTransferServerViewController *transFerServerViewController;
/** 设置 */
@property (nonatomic, strong) FFSettingViewController *settingViewController;
/** 修改密码 */
@property (nonatomic, strong) FFChangePasswordViewController *changePasswordViewController;
/** 关于 */
@property (nonatomic, strong) FFAboutViewController *aboutViewController;
/** 修改昵称 */
@property (nonatomic, strong) FFResetNickNameView *restNickNameView;
/** 金币中心 */
@property (nonatomic, strong) FFGoldCenterViewController *goldCenterViewController;
/** 平台币明细 */
@property (nonatomic, strong) FFPlatformDetailViewController *platformDetailViewController;

/** 原头像 */
@property (nonatomic, strong) UIImage *oriAvatarImage;

@end

@implementation FFMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self setInterface];
    [self setCoin];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (UIImage *)createImageWithColor:(UIColor *)color size:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return theImage;
}

- (void)initUserInterface {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = NAVGATION_BAR_COLOR;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.navigationItem.title = @"个人中心";
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.coinView];
    [self.view addSubview:self.selectView];
}

- (void)initDataSource {
    self.selectView.is185 = [[FFUserModel channel] isEqualToString:@"185"];
    [self setInterface];
}

- (void)setInterface {
    NSDictionary *dict = [FFUserModel getUserDict];
    _uid = [FFUserModel getUID];

    syLog(@"view will appear = %@",dict);
    if (dict == nil || _uid == nil) {
        [self.headerView hideNickNameAndVip];
    } else {
        [self.headerView showNickNameAndVip];
    }

    //设置头像
    [self setAvatarWith:dict[@"icon_url"]];
    //设置昵称
    self.headerView.loginTitle = dict[@"nick_name"];
    //设置金币
    [self setCoin];

    if ([FFUserModel currentUser].isLogin) {
        return;
    }

    syLog(@"login controller view will appear === %@",dict);
    //设置 USER MODEL
    [[FFUserModel currentUser] setAllPropertyWithDict:dict];
    syLog(@"model.nick_name == %@",[FFUserModel currentUser].nick_name);
    //设置 VIP
    self.headerView.isVip = [NSString stringWithFormat:@"%@",dict[@"is_vip"]].boolValue;
}

- (void)setCoin {
    NSString *username = SSKEYCHAIN_USER_NAME;
    if (username == nil || _uid == nil) {
        //金币
        self.coinView.goldCoinNumber = @"0";
        //平台币
        self.coinView.platformCoinNumber = @"0";
        //邀请奖励
        self.coinView.inviteIncomeNumber = @"0";
        //vip
        self.headerView.isVip = NO;
        return;
    } else {
        [FFUserModel userCoinWithCompletion:^(NSDictionary *content, BOOL success) {
            if (success) {
                syLog(@"%@",content);
                NSDictionary *dict = content[@"data"];
                //金币
                self.coinView.goldCoinNumber = dict[@"coin"];
                //平台币
                self.coinView.platformCoinNumber = dict[@"platform_money"];
                //邀请奖励
                self.coinView.inviteIncomeNumber = dict[@"recom_bonus"];
                //vip
                self.headerView.isVip = [NSString stringWithFormat:@"%@",dict[@"is_vip"]].boolValue;
            }
        }];
    }
}

#pragma mark - header view delegate
- (void)FFMineHeaderView:(FFMineHeaderView *)view respondsToAvatarButton:(id)info {
    syLog(@"头像");
    if (_uid == nil) {
        HIDE_TABBAR;
        [self.navigationController pushViewController:[FFLoginViewController new] animated:YES];
        SHOW_TABBAR;
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                    [self openPhoto];
                    syLog(@"PHAuthorizationStatusAuthorized");
                    break;
                case PHAuthorizationStatusDenied:
                    syLog(@"PHAuthorizationStatusDenied");
                    break;
                case PHAuthorizationStatusNotDetermined:
                    syLog(@"PHAuthorizationStatusNotDetermined");
                    break;
                case PHAuthorizationStatusRestricted:
                    syLog(@"PHAuthorizationStatusRestricted");
                    break;
            }
        }];
    }
}

- (void)openPhoto {
    UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
    pickerView.delegate = self;
    pickerView.allowsEditing = YES;

    if  ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] && [UIImagePickerController isSourceTypeAvailable : UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择图片来源" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *photoLibraryAct = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pickerView animated:YES completion:nil];
        }];
        UIAlertAction *cameraAct = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerView.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            pickerView.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;

            [self presentViewController:pickerView animated:YES completion:nil];
        }];


        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:photoLibraryAct];
        [alertController addAction:cameraAct];
        [alertController addAction:cancelAct];

        [self presentViewController:alertController animated:YES completion:nil];
    }
}



#pragma mark - pickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];

    if ([type isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage  *image = info[UIImagePickerControllerEditedImage];
        _oriAvatarImage = self.headerView.avatarImage;
        self.headerView.avatarImage = [image copy];
        [FFUserModel setAvatarData:UIImagePNGRepresentation(image)];

        /** 上传图片 */
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [FFUserModel userUploadPortraitWithImage:image Completion:^(NSDictionary *content, BOOL success) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if (success) {
                syLog(@"上传头像成功");
            } else {
                self.headerView.avatarImage = _oriAvatarImage;
                [FFUserModel setAvatarData:UIImagePNGRepresentation(_oriAvatarImage)];
                BOX_MESSAGE(@"上传头像失败");
            }
        }];
    }
    syLog(@"2");
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)FFMineHeaderView:(FFMineHeaderView *)view respondsToLoginButton:(id)info {
    if (_uid == nil) {
        HIDE_TABBAR;
        [self.navigationController pushViewController:[FFLoginViewController new] animated:YES];
        HIDE_TABBAR;
    } else {
        FFResetNickNameView *view = [FFResetNickNameView new];
        view.delegate = self;
        [self.view addSubview:view];
    }
}

- (void)FFMineHeaderView:(FFMineHeaderView *)view respondsToVipButton:(id)info {
    syLog(@"vip");
    if ([FFUserModel getUID] == nil) {
        return;
    }

    BOX_START_ANIMATION;
    [FFUserModel vipGetOptionWithCompletion:^(NSDictionary *content, BOOL success) {
        syLog(@"vip option === %@",content);
        BOX_STOP_ANIMATION;
        if (success) {
            HIDE_TABBAR;
            FFOpenVipViewController *vc = [[FFOpenVipViewController alloc] init];
            vc.vipOptionArray = content[@"data"];
            [self.navigationController pushViewController:vc animated:YES];
            SHOW_TABBAR;
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

- (void)FFMineHeaderView:(FFMineHeaderView *)view respondsToSettingButton:(id)info {
    HIDE_TABBAR;
    [self.navigationController pushViewController:self.settingViewController animated:YES];
//    [self.navigationController pushViewController:[FFGoldCenterController new] animated:YES];
    SHOW_TABBAR;
}

- (void)setAvatarWith:(NSString *)url {
    if (url == nil) {
        self.headerView.avatarImage = nil;
        return;
    }

    NSData *avatarData = [[FFUserModel getAvatarData] copy];

    if (avatarData) {
        syLog(@"set avatar");
        self.headerView.avatarImage = [UIImage imageWithData:avatarData];
    } else {
        syLog(@"download avatar");
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:(SDWebImageDownloaderLowPriority) progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (finished) {
                syLog(@"downloaded avatar");
                self.headerView.avatarImage = [UIImage imageWithData:data];
                [FFUserModel setAvatarData:data];
            }
        }];
    }
}

#pragma mark - coin view deleagte
/** 金币中心 */
- (void)FFMineCoinView:(FFMineCoinView *)view clickGoldButton:(id)info {
    if (_uid == nil || _uid.length == 0) {
        BOX_MESSAGE(@"尚未登录");
        return;
    }
    HIDE_TABBAR;
    [self.navigationController pushViewController:self.goldCenterViewController animated:YES];
    SHOW_TABBAR;
}
/** 平台币明细 */
- (void)FFMineCoinView:(FFMineCoinView *)view clickPlatformButton:(id)info {
    syLog(@"平台币明细");
    if (_uid == nil || _uid.length == 0) {
        BOX_MESSAGE(@"尚未登录");
        return;
    }
    
    HIDE_TABBAR;
    [self.navigationController pushViewController:self.platformDetailViewController animated:YES];
    SHOW_TABBAR;
}

/** 邀请好友奖励 */ 
- (void)FFMineCoinView:(FFMineCoinView *)view clickInviteButton:(id)info {
    
}

#pragma mark - rest nick name delegate
- (void)FFResetNickNameView:(FFResetNickNameView *)view clickRestButtonWithNickName:(NSString *)nickName {
    BOX_START_ANIMATION;
    [FFUserModel userModifyNicknameWithUserID:[FFUserModel currentUser].uid NickName:nickName Completion:^(NSDictionary *content, BOOL success) {
        BOX_STOP_ANIMATION;
        if (success) {
            syLog(@"?????? ===== %@", content);
            BOX_MESSAGE(content[@"msg"]);
            self.headerView.loginTitle = nickName;
            [FFUserModel currentUser].nick_name = nickName;
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

#pragma mark - select view delegate
- (void)FFmineSelectView:(FFMineSelectView *)view didSelectButtonWithIndex:(NSInteger)idx {
    self.hidesBottomBarWhenPushed = YES;
    switch (idx) {
        case 0: {
            NotLogIn;
            [self.navigationController pushViewController:self.signInViewController animated:YES];
            break;
        }
        case 1:{
            NotLogIn;
            [self.navigationController pushViewController:self.inviteFriendViewController animated:YES];
            break;
        }
        case 2: {
            [self.navigationController pushViewController:self.customerServiceViewController animated:YES];
            break;
        }
        case 3: {
            NotLogIn;
            [self.navigationController pushViewController:self.myPackageViewController animated:YES];
            break;
        }
        case 4: {
            NotLogIn;
            [self.navigationController pushViewController:self.myCollectionViewController animated:YES];
            break;
        }
        case 5: {
            NotLogIn;
            [self.navigationController pushViewController:self.transFerServerViewController animated:YES];
            break;
        }
        case 6: {
//            [self.navigationController pushViewController:self.settingViewController animated:YES];
            NotLogIn;
            [self.navigationController pushViewController:self.changePasswordViewController animated:YES];
            break;
        }
        case 7: {
            [self.navigationController pushViewController:self.aboutViewController animated:YES];
            break;
        }
        case 8: {
            break;
        }

        default:
            break;
    }
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark - getter
//- (FFMineHeaderView *)headerView {
//    if (!_headerView) {
////        _headerView = [[FFMineHeaderView alloc] init];
//        _headerView.delegate = self;
//    }
//    return _headerView;
//}

- (FFMineCoinView *)coinView {
    if (!_coinView) {
        _coinView = [[FFMineCoinView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kSCREEN_WIDTH, kSCREEN_WIDTH * 0.15)];
        _coinView.delegate = self;
    }
    return _coinView;
}

- (FFMineSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[FFMineSelectView alloc] init];
        _selectView.frame = CGRectMake(0, CGRectGetMaxY(self.coinView.frame) + 10, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.coinView.frame) - 10 - CGRectGetHeight(self.tabBarController.tabBar.frame));
        _selectView.backgroundColor = BACKGROUND_COLOR;
        _selectView.delegate = self;
    }
    return _selectView;
}

/** 签到视图 */
- (FFSignInViewController *)signInViewController {
    if (!_signInViewController) {
        _signInViewController = [[FFSignInViewController alloc] init];
    }
    return _signInViewController;
}

/** 邀请好友 */
- (FFInviteFriendViewController *)inviteFriendViewController {
    if (!_inviteFriendViewController) {
        _inviteFriendViewController = [[FFInviteFriendViewController alloc] init];
    }
    return _inviteFriendViewController;
}

/** 客服中心 */
- (FFCustomerServiceViewController *)customerServiceViewController {
    if (!_customerServiceViewController) {
        _customerServiceViewController = [[FFCustomerServiceViewController alloc] init];
    }
    return _customerServiceViewController;
}

/** 我的礼包 */
- (FFMyPackageViewController *)myPackageViewController {
    if (!_myPackageViewController) {
        _myPackageViewController = [[FFMyPackageViewController alloc] init];
    }
    return _myPackageViewController;
}

/** 我的收藏 */
- (FFMyCollectionViewController *)myCollectionViewController {
    if (!_myCollectionViewController) {
        _myCollectionViewController = [[FFMyCollectionViewController alloc] init];
    }
    return _myCollectionViewController;
}

/** 申请转游戏 */
- (FFTransferServerViewController *)transFerServerViewController {
    if (!_transFerServerViewController) {
        _transFerServerViewController = [[FFTransferServerViewController alloc] init];
    }
    return _transFerServerViewController;
}

/** 设置 */
- (FFSettingViewController *)settingViewController {
    if (!_settingViewController) {
        _settingViewController = [[FFSettingViewController alloc] init];
    }
    return _settingViewController;
}

/** 修改密码 */
- (FFChangePasswordViewController *)changePasswordViewController {
    if (!_changePasswordViewController) {
        _changePasswordViewController = [[FFChangePasswordViewController alloc] init];
    }
    return _changePasswordViewController;
}

/** 关于 */
- (FFAboutViewController *)aboutViewController {
    if (!_aboutViewController) {
        _aboutViewController = [[FFAboutViewController alloc] init];
    }
    return _aboutViewController;
}

/** 修改昵称 */
- (FFResetNickNameView *)restNickNameView {
    if (!_restNickNameView) {
        _restNickNameView = [[FFResetNickNameView alloc] init];
        _restNickNameView.delegate = self;
    }
    return _restNickNameView;
}

/** 金币中心 */
- (FFGoldCenterViewController *)goldCenterViewController {
    if (!_goldCenterViewController) {
        _goldCenterViewController = [[FFGoldCenterViewController alloc] init];

    }
    return _goldCenterViewController;
}

/** 平台币明细 */
- (FFPlatformDetailViewController *)platformDetailViewController {
    if (!_platformDetailViewController) {
        _platformDetailViewController = [[FFPlatformDetailViewController alloc] init];
    }
    return _platformDetailViewController;
}






@end





















