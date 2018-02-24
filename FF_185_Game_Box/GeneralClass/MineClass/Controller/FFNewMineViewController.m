//
//  FFNewMineViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/24.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFNewMineViewController.h"

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
#import "FFLotteryViewController.h"

#import "FFDriveMineViewController.h"       //点击头像后的页面

#import "UINavigationController+Cloudox.h"
#import "UIViewController+Cloudox.h"

#import "FFFlashBackView.h"

#define BOX_ORANG_COLOR RGBCOLOR(251, 158, 52)
#define BUTTON_TAG 10086
#define CurrentUser [FFUserModel currentUser]
#define NotLogIn if (_uid == nil || _uid.length == 0) {\
BOX_MESSAGE(@"尚未登录");\
break;\
}\

@interface FFNewMineViewController () <FFmineHeaderViewDelegate, FFRestNickNameDelegate, FFMineCoinViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>


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
/** 金币抽奖 */
@property (nonatomic, strong) FFLotteryViewController *lotteryViewController;

/** 原头像 */
@property (nonatomic, strong) UIImage *oriAvatarImage;

#pragma mark - ============================= new =============================
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSArray *> *showArray;
@property (nonatomic, strong) NSMutableDictionary *infoDict;
@property (nonatomic, assign) BOOL is185;



@end

@implementation FFNewMineViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserReigsterThanLogin) name:@"UserReigsterThanLogin" object:nil];

//        [self ]
    }
    return self;
}


- (void)UserReigsterThanLogin {
    syLog(@"?????");
    [self setInterface];
    [self setCoin];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
    [self UserReigsterThanLogin];
    self.navBarBgAlpha = @"0.0";
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
    self.is185 = [[FFUserModel channel] isEqualToString:@"185"];
    [self initDataSource];
    [self initUserInterface];
}


- (void)initUserInterface {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = NAVGATION_BAR_COLOR;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.navigationItem.title = @"";
    self.view.backgroundColor = BACKGROUND_COLOR;

    [self.view addSubview:self.tableHeaderView];
    [self.view addSubview:self.tableView];
}

- (void)initDataSource {
    [self setInterface];
}

- (void)setInterface {
    NSDictionary *dict = [FFUserModel getUserDict];
    _uid = [FFUserModel getUID];

    [self.coinView setIsVip:[NSString stringWithFormat:@"%@",dict[@"is_vip"]].boolValue];
    syLog(@"view will appear = %@",dict);
    if (dict == nil || _uid == nil) {
        [self.headerView hideNickNameAndVip];
        [self.headerView setLoginFrame:NO];
    } else {
        [self.headerView setLoginFrame:YES];
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
        [self.tableView.mj_header endRefreshing];
        return;
    } else {
        [FFUserModel userCoinWithCompletion:^(NSDictionary *content, BOOL success) {
            if (success) {
                syLog(@"coin ======= %@",content);
                NSDictionary *dict = content[@"data"];
                [self setUserCenterInfo:dict];
            }
            [self.tableView.mj_header endRefreshing];
        }];
    }
}

- (void)setUserCenterInfo:(NSDictionary *)dict {
    //金币
    self.coinView.goldCoinNumber = dict[@"coin"];
    //平台币
    self.coinView.platformCoinNumber = dict[@"platform_money"];
    //邀请奖励
    self.coinView.inviteIncomeNumber = dict[@"recom_bonus"];
    //vip
    self.headerView.isVip = [NSString stringWithFormat:@"%@",dict[@"is_vip"]].boolValue;
    //设置显示每日签到奖励
    [self setSignResult:dict[@"sign_day_bonus"]];
    //设置每日评论
    [self setCommentResult:dict[@"pl_coin"]];
    //好友推荐
    [self setInviteFriendResult:dict[@"recom_top"]];
    //金币兑换
    [self setChangeCoinResult:dict[@"platform_coin_ratio"]];
    //金币抽奖
    [self setLotteryResult:dict[@"deplete_coin"]];
    //绑定手机
    [self setBindPhoneResult:dict[@"mobile"]];
    [self.tableView reloadData];

}

/** 设置签到奖励 */
- (void)setSignResult:(NSDictionary *)dict {
    NSMutableDictionary *signDict = [self.infoDict[@"FFSignInViewController"] mutableCopy];
    NSString *string = [NSString stringWithFormat:@"签到+%@金币,VIP额外+%@金币",dict[@"normal"],dict[@"vip_extra"]];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];

    NSRange range1 = [string rangeOfString:[NSString stringWithFormat:@"%@",dict[@"normal"]]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:BOX_ORANG_COLOR range:range1];
    range1 = [string rangeOfString:[NSString stringWithFormat:@"%@",dict[@"vip_extra"]]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:BOX_ORANG_COLOR range:range1];


    [signDict setObject:[NSString stringWithFormat:@"签到+%@金币,VIP额外+%@金币",dict[@"normal"],dict[@"vip_extra"]] forKey:@"subTitle"];
    [signDict setObject:attributeString forKey:@"attributeString"];

    [self.infoDict setObject:signDict forKey:@"FFSignInViewController"];


//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
}

/** 每日评论 */
- (void)setCommentResult:(NSString *)str {
    NSMutableDictionary *signDict = [self.infoDict[self.showArray[1][1]] mutableCopy];
    NSString *string = [NSString stringWithFormat:@"每日首次评论奖励%@金币",str];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];

    NSRange range1 = [string rangeOfString:str];
    [attributeString addAttribute:NSForegroundColorAttributeName value:BOX_ORANG_COLOR range:range1];
    [signDict setObject:attributeString forKey:@"attributeString"];
    [signDict setObject:[NSString stringWithFormat:@"每日首次评论奖励%@金币",str] forKey:@"subTitle"];
    [self.infoDict setObject:signDict forKey:self.showArray[1][1]];
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
}

/** 好友推荐 */
- (void)setInviteFriendResult:(NSString *)str {
    NSMutableDictionary *signDict = [self.infoDict[self.showArray[1][2]] mutableCopy];
    NSString *string = [NSString stringWithFormat:@"最高奖励%@金币/人",str];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range1 = [string rangeOfString:str];
    [attributeString addAttribute:NSForegroundColorAttributeName value:BOX_ORANG_COLOR range:range1];
    [signDict setObject:attributeString forKey:@"attributeString"];
    [signDict setObject:[NSString stringWithFormat:@"最高奖励%@金币/人",str] forKey:@"subTitle"];
    [self.infoDict setObject:signDict forKey:self.showArray[1][2]];
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
}

/** 金币兑换 */
- (void)setChangeCoinResult:(NSString *)str {
    NSMutableDictionary *signDict = [self.infoDict[self.showArray[2][0]] mutableCopy];
    NSString *string = [NSString stringWithFormat:@"%@金币=1平台币,10平台币=1RMB",str];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range1 = [string rangeOfString:str];
    [attributeString addAttribute:NSForegroundColorAttributeName value:BOX_ORANG_COLOR range:range1];
    [attributeString addAttribute:NSForegroundColorAttributeName value:BOX_ORANG_COLOR range:NSMakeRange(string.length - 10, 2)];
    [signDict setObject:attributeString forKey:@"attributeString"];
    [signDict setObject:[NSString stringWithFormat:@"%@金币=1平台币",str] forKey:@"subTitle"];
    [self.infoDict setObject:signDict forKey:self.showArray[2][0]];
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:(UITableViewRowAnimationNone)];
}

/** 金币抽奖 */
- (void)setLotteryResult:(NSString *)str {
    NSMutableDictionary *signDict = [self.infoDict[self.showArray[2][1]] mutableCopy];
    NSString *string = [NSString stringWithFormat:@"%@金币/每次",str];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range1 = [string rangeOfString:str];
    [attributeString addAttribute:NSForegroundColorAttributeName value:BOX_ORANG_COLOR range:range1];
    [signDict setObject:attributeString forKey:@"attributeString"];
    [signDict setObject:[NSString stringWithFormat:@"%@金币/每次",str] forKey:@"subTitle"];
    [self.infoDict setObject:signDict forKey:self.showArray[2][1]];
}

/** 绑定手机 */
- (void)setBindPhoneResult:(NSString *)str {
    NSMutableDictionary *signDict = [self.infoDict[self.showArray[6][1]] mutableCopy];
    if (str.length != 11) {
        [signDict setObject:@"绑定手机" forKey:@"title"];
    } else {
        [signDict setObject:@"解绑手机" forKey:@"title"];
    }
    [self.infoDict setObject:signDict forKey:self.showArray[6][1]];
}

- (void)refreshNewData {
    [self setCoin];
}



#pragma mark - header view delegate
- (void)FFMineHeaderView:(FFMineHeaderView *)view respondsToAvatarButton:(id)info {
    syLog(@"头像");
    if (_uid == nil) {
        HIDE_TABBAR;
        [self.navigationController pushViewController:[FFLoginViewController new] animated:YES];
        SHOW_TABBAR;
    } else {
//        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//            switch (status) {
//                case PHAuthorizationStatusAuthorized:
//                    [self openPhoto];
//                    syLog(@"PHAuthorizationStatusAuthorized");
//                    break;
//                case PHAuthorizationStatusDenied:
//                    syLog(@"PHAuthorizationStatusDenied");
//                    break;
//                case PHAuthorizationStatusNotDetermined:
//                    syLog(@"PHAuthorizationStatusNotDetermined");
//                    break;
//                case PHAuthorizationStatusRestricted:
//                    syLog(@"PHAuthorizationStatusRestricted");
//                    break;
//            }
//        }];
        
//        syLog(@"click icon with uid == %@", uid);
        FFDriveMineViewController *vc = [FFDriveMineViewController new];
        //    vc.iconImage = iconImage;
        //    vc.model = cell.model;
        vc.uid = _uid;
        HIDE_TABBAR;
        HIDE_PARNENT_TABBAR;
        [self.navigationController pushViewController:vc animated:YES];
        SHOW_TABBAR;
        SHOW_PARNENT_TABBAR;
    }
}

- (void)openPhoto {
    UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
    pickerView.delegate = self;
    pickerView.allowsEditing = YES;

//    pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:pickerView animated:YES completion:nil];
//    return;

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

- (void)FFMineCoinView:(FFMineCoinView *)view clickOpenVipButton:(id)info {
    if (SSKEYCHAIN_UID) {
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
    } else {
        HIDE_TABBAR;
        [self.navigationController pushViewController:[FFLoginViewController new] animated:YES];
        SHOW_TABBAR;
    }
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

#pragma mark - table View delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMineCell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"NewMineCell"];
    }

    NSDictionary *dict = self.infoDict[self.showArray[indexPath.section][indexPath.row]];
    cell.textLabel.text = dict[@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    if (indexPath.section == 0) {

    } else {
        if (dict[@"attributeString"]) {
            cell.detailTextLabel.attributedText = dict[@"attributeString"];
        } else {
            cell.detailTextLabel.text = dict[@"subTitle"];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        }
    }


    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (dict[@"subimage"]) {
        cell.imageView.image = [UIImage imageNamed:dict[@"subimage"]];
    } else {
        cell.imageView.image = nil;
        syLog(@"no image === T@%@",dict);
    }

    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, cell.frame.size.height - 1, kSCREEN_WIDTH, 1);
    layer.backgroundColor = BACKGROUND_COLOR.CGColor;
    [cell.contentView.layer addSublayer:layer];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 12;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BACKGROUND_COLOR;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BACKGROUND_COLOR;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        [FFFlashBackView show];
    } else {
        if (SSKEYCHAIN_UID == nil) {
            BOX_MESSAGE(@"尚未登录");
            return;
        }

        if ([(self.showArray[indexPath.section][indexPath.row]) isEqualToString:@"FFLotteryViewController"]) {

            HIDE_TABBAR;
            HIDE_PARNENT_TABBAR;
            [self.navigationController pushViewController:self.lotteryViewController animated:YES];
            SHOW_TABBAR;
            SHOW_PARNENT_TABBAR;

            return;
        }

        Class pushClass = NSClassFromString(self.showArray[indexPath.section][indexPath.row]);
        if (pushClass) {
            id vc = [[pushClass alloc] init];
            if (vc) {
                HIDE_TABBAR;
                HIDE_PARNENT_TABBAR;
                [self.navigationController pushViewController:vc animated:YES];
                SHOW_TABBAR;
                SHOW_PARNENT_TABBAR;
            }
        }
    }
}

#pragma mark - getter
- (FFMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.4)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (FFMineCoinView *)coinView {
    if (!_coinView) {
        _coinView = [[FFMineCoinView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kSCREEN_WIDTH, kSCREEN_WIDTH * 0.15)];
        _coinView.delegate = self;

        CALayer *upLayer = [[CALayer alloc] init];
        upLayer.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 2);
        upLayer.backgroundColor = BACKGROUND_COLOR.CGColor;
        [_coinView.layer addSublayer:upLayer];

        CALayer *downLayer = [[CALayer alloc] init];
        downLayer.frame = CGRectMake(0, _coinView.frame.size.height - 2, kSCREEN_WIDTH, 2);
        downLayer.backgroundColor = BACKGROUND_COLOR.CGColor;
        [_coinView.layer addSublayer:downLayer];
    }
    return _coinView;
}

/** 设置 */
- (FFSettingViewController *)settingViewController {
    if (!_settingViewController) {
        _settingViewController = [[FFSettingViewController alloc] init];
    }
    return _settingViewController;
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
- (FFPlatformDetailViewController *)platformDetailViewController{
    if (!_platformDetailViewController) {
        _platformDetailViewController = [[FFPlatformDetailViewController alloc] init];
    }
    return _platformDetailViewController;
}

/** 抽奖 */
- (FFLotteryViewController *)lotteryViewController {
    if (!_lotteryViewController) {
        _lotteryViewController = [[FFLotteryViewController alloc] init];
    }
    return _lotteryViewController;
}

#pragma mark - new getter
- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.headerView.frame.size.height + self.coinView.frame.size.height)];
        [_tableHeaderView addSubview:self.headerView];
        [_tableHeaderView addSubview:self.coinView];
    }
    return _tableHeaderView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableHeaderView.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - self.tabBarController.tabBar.frame.size.height - CGRectGetMaxY(self.tableHeaderView.frame))  style:(UITableViewStylePlain)];

        _tableView.dataSource = self;
        _tableView.delegate = self;

        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
        }
        
        _tableView.mj_header = [FFViewFactory customRefreshHeaderWithTableView:_tableView WithTarget:self];

        //下拉刷新
        [_tableView.mj_header setRefreshingAction:@selector(refreshNewData)];
//        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)showArray {
    if (!_showArray) {
        if (self.is185) {
            _showArray = [@[@[@"FFResignViewController"],
                            @[@"FFSignInViewController",@"FFEvervDayComment",@"FFInviteFriendViewController"],
                            @[@"FFExchangeCoinController",@"FFLotteryViewController",@"FFGoldDetailViewController",
                              @"FFPlatformDetailViewController"],
                           @[@"FFRRebateViewController",@"FFTransferServerViewController"],
                           @[@"FFMyPackageViewController",@"FFMyCollectionViewController",@"FFRActivityViewController"],
                           @[@"FFMyNewsViewController",@"FFCustomerServiceViewController"],
                           @[@"FFChangePasswordViewController",@"FFBindMobileViewController",@"FFAboutViewController"]] mutableCopy];
        } else {
            _showArray = [@[@[@"FFSignInViewController",@"FFEvervDayComment",@"FFInviteFriendViewController"],
                           @[@"FFExchangeCoinController",@"FFLotteryViewController",@"FFGoldDetailViewController",
                             @"FFPlatformDetailViewController"],
                           @[@"FFRRebateViewController",@"FFTransferServerViewController"],
                           @[@"FFMyPackageViewController",@"FFMyCollectionViewController",@"FFRActivityViewController"],
                           @[@"FFMyNewsViewController",@"FFCustomerServiceViewController"],
                           @[@"FFChangePasswordViewController",@"FFBindMobileViewController"]] mutableCopy];
        }
    }
    return _showArray;
}

- (NSDictionary *)infoDict {
    if (!_infoDict) {
        _infoDict = [@{@"FFResignViewController":       @{@"title":@"闪退修复"},
                       @"FFSignInViewController":       @{@"title":@"签到",@"subTitle":@"+5金币,坚持有惊喜",
                                                          @"subimage":@"Mine_subimage_sign"},
                      @"FFEvervDayComment":             @{@"title":@"每日评论",@"subTitle":@"+3到10金币,每日一次",
                                                          @"subimage":@"Mine_subimage_comment"},
                      @"FFInviteFriendViewController":  @{@"title":@"邀请好友",@"subTitle":@"最高奖励2000金币/人",
                                                          @"subimage":@"Mine_subimage_invite"},

                      @"FFExchangeCoinController":      @{@"title":@"金币兑换",
                                                          @"subimage":@"Mine_subimage_changecoin"},
                      @"FFLotteryViewController":       @{@"title":@"金币抽奖",
                                                          @"subimage":@"Mine_subimage_lottery"},
                      @"FFGoldDetailViewController":    @{@"title":@"金币明细",
                                                          @"subimage":@"Mine_subimage_coindetail"},
                       @"FFPlatformDetailViewController":@{@"title":@"平台币明细",@"subTitle":@"平台币可在游戏中消费",
                                                           @"subimage":@"Mine_subimage_coindetail"},

                      @"FFRRebateViewController":       @{@"title":@"返利申请",@"subTitle":@"充值有奖,元宝/钻石返还",
                                                          @"subimage":@"Mine_subimage_rebateapply"},
                      @"FFTransferServerViewController":@{@"title":@"转游申请",
                                                          @"subimage":@"Mine_subimage_transfergame"},

                      @"FFMyPackageViewController":     @{@"title":@"我的礼包",
                                                          @"subimage":@"Mine_subimage_mypackage",},
                      @"FFMyCollectionViewController":  @{@"title":@"我的收藏",
                                                          @"subimage":@"Mine_subimage_mycollection"},
                      @"FFRActivityViewController":     @{@"title":@"活动中心",
                                                          @"subimage":@"Mine_subimage_activity"},

                      @"FFMyNewsViewController":        @{@"title":@"我的消息",
                                                          @"subimage":@"Mine_subimage_mynews"},
                      @"FFCustomerServiceViewController":@{@"title":@"客服中心",@"subTitle":@"寻求帮助,问题反馈",@"subimage":@"Mine_subimage_customercenter"},

                      @"FFChangePasswordViewController":@{@"title":@"修改密码",
                                                          @"subimage":@"Mine_subimage_changepassword"},
                      @"FFBindMobileViewController":    @{@"title":@"绑定手机",
                                                          @"subimage":@"Mine_subimage_bindinphone"},
                      @"FFAboutViewController":         @{@"title":@"关于我们",
                                                          @"subimage":@"Mine_subimage_aboutus"},

                      @"FFUnBindMobileViewController":   @{@"title":@"解绑手机",
                                                               @"subimage":@"Mine_subimage_bindinphone"},

                      } mutableCopy];
    }
    return _infoDict;
}


@end

