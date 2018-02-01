//
//  FFDetailMineInfoTableViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/2/1.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDetailMineInfoTableViewController.h"
#import "UINavigationController+Cloudox.h"
#import "UIViewController+Cloudox.h"
#import "UIImageView+WebCache.h"
#import "FFDriveModel.h"
#import "UIAlertController+FFAlertController.h"
#import "SYKeychain.h"
#import "MBProgressHUD.h"
#import "ZLPhotoActionSheet.h"
#import <Photos/Photos.h>


#define CELL_IDE @"DetailMineInfoCell"
#define STR_NIL_RETURN if (str == nil || [str isKindOfClass:[NSNull class]]) {\
return;\
}

const NSUInteger cellTag = 10086;

@interface FFDetailMineInfoTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *QQLabel;
@property (weak, nonatomic) IBOutlet UILabel *EmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *localLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *cell0;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell1;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell2;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell3;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell4;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell5;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell6;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell7;

@property (nonatomic, strong) NSArray<UITableViewCell *> *cells;
@property (nonatomic, strong) ZLPhotoActionSheet *actionSheet;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) UIBarButtonItem *sendButton;

@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (nonatomic, assign) BOOL isOriginal;

@end

@implementation FFDetailMineInfoTableViewController {
    BOOL selectButton;
    BOOL isRefres;
}

+ (instancetype)controllerWithUid:(NSString *)uid Dict:(NSDictionary *)dict {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil];
    FFDetailMineInfoTableViewController *detail = [storyboard instantiateViewControllerWithIdentifier:@"FFDetailMineInfoTableViewController"];
    detail.uid = uid;
    detail.dict = dict;
    return detail;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
    if (!isRefres) {
        [self.uid isEqualToString:SSKEYCHAIN_UID] ? [self showAccess] : [self hideAccess];
        [self setInfoWith:self.dict];
        isRefres = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.navigationItem.title = @"个人资料";
    self.iconImage.layer.cornerRadius = self.iconImage.bounds.size.width / 2;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderColor = NAVGATION_BAR_COLOR.CGColor;
    self.iconImage.layer.borderWidth = 3;
    _cells = @[self.cell0,self.cell1,self.cell2,self.cell3,
               self.cell4,self.cell5,self.cell6,self.cell7];
}

#pragma mark - setter
/** set uid */
- (void)setUid:(NSString *)uid {
    syLog(@"设置 uid");
    NSString *string = [NSString stringWithFormat:@"%@",uid];
    _uid = string;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
    [FFDriveModel userInfomationWithUid:_uid fieldType:fieldDetail Complete:^(NSDictionary *content, BOOL success) {
        syLog(@"查询用户信息  :  %@",content);
        [hud hideAnimated:YES];
        if (success) {
            [self setInfoWith:content[@"data"]];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
    }];
}

- (void)showAccess {
    selectButton = YES;
    [_cells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }];
}

- (void)hideAccess {
    selectButton = NO;
    [_cells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.accessoryType = UITableViewCellAccessoryNone;
    }];
}

/** set dict */ 
- (void)setDict:(NSDictionary *)dict {
    _dict = dict[@"user"];
    syLog(@"detail dict == %@",dict);
}

- (void)setInfoWith:(NSDictionary *)dict {
    if (self.cell0 == nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setInfoWith:dict];
        });
        return;
    }
    _dict = dict;
    //icon
    [self setIconImageWith:dict[@"icon_url"]];
    //user name
    [self setUserName:dict[@"username"]];
    //nickName
    [self setNickName:dict[@"nick_name"]];
    //register time
    [self setCreatTime:dict[@"reg_time"]];
    //dese
    [self setcontent:dict[@"desc"]];
    //sex
    [self setSex:dict[@"sex"]];
    //birthday
    [self setbirthday:dict[@"birth"]];
    //qq
    [self setQQ:dict[@"qq"]];
    //email
    [self setEmail:dict[@"email"]];
    //local
    [self setLocal:dict[@"address"]];
}

//setImage
- (void)setIconImageWith:(NSString *)str {
    STR_NIL_RETURN;
    NSString *urlString = [NSString stringWithFormat:@"%@",str];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage new]];
}
//user name
- (void)setUserName:(NSString *)str {
    STR_NIL_RETURN;
    NSString *name = [NSString stringWithFormat:@"%@",str];
    self.userNameLabel.text = name;
}
//nickname
- (void)setNickName:(NSString *)str {
    STR_NIL_RETURN;
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@",str];
}
//register time
- (void)setCreatTime:(NSString *)str {
    STR_NIL_RETURN;
    self.creatTimeLabel.text = [NSString stringWithFormat:@"%@",str];
}
//desc
- (void)setcontent:(NSString *)str {
    STR_NIL_RETURN;
    self.contentLabel.text = [NSString stringWithFormat:@"%@",str];
}
//sex
- (void)setSex:(NSString *)str {
    STR_NIL_RETURN;
    NSString *sex = [NSString stringWithFormat:@"%@",str];
    self.sexLabel.text = (sex.integerValue == 1) ? @"男" : sex.integerValue == 2 ? @"女" : @"其他";
}
//birthday
- (void)setbirthday:(NSString *)str {
    STR_NIL_RETURN;
    NSString *birthday = [NSString stringWithFormat:@"%@",str];
    self.birthdayLabel.text = birthday;
}
//QQ
- (void)setQQ:(NSString *)str {
    STR_NIL_RETURN;
    NSString *QQ = [NSString stringWithFormat:@"%@",str];
    self.QQLabel.text = QQ;
}

//email
- (void)setEmail:(NSString *)str {
    STR_NIL_RETURN;
    NSString *email = [NSString stringWithFormat:@"%@",str];
    self.EmailLabel.text = email;
}
//location
- (void)setLocal:(NSString *)str {
    STR_NIL_RETURN;
    NSString *local = [NSString stringWithFormat:@"%@",str];
    self.localLabel.text = local;
}


#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!selectButton) {
        return;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self clickCellWithTag:cell.tag - cellTag];
}

- (void)clickCellWithTag:(NSUInteger)idx {
    switch (idx) {
        case 0: [self reSetIconImage];
            break;
        case 1: [self reSetNiceName];
            break;
        case 2: [self reSetDescription];
            break;
        case 3: [self reSetSex];
            break;
        case 4: [self reSetBirthDay];
            break;
        case 5: [self reSetQQ];
            break;
        case 6: [self reSetEmail];
            break;
        case 7: [self reSetLocation];
            break;
        default:
            break;
    }
}

#pragma mark - re set method
- (void)reSetIconImage {
    syLog(@"重置   头像");
    //设置照片最大选择数
    [self.actionSheet showPhotoLibrary];
}

- (void)reSetNiceName {
    syLog(@"重置   昵称");

    [FFDriveModel userEditInfoMationWithNickName:@"雨下整夜" sex: nil address:nil desc:nil birth:nil qq:nil email:nil Complete:^(NSDictionary *content, BOOL success) {
        syLog(@"修改 昵称 ===%@ ", content);
    }];
}

- (void)reSetDescription {
    syLog(@"重置   简介");
}

- (void)reSetSex {
    syLog(@"重置   性别");
}

- (void)reSetBirthDay {
    syLog(@"重置   生日");
}

- (void)reSetQQ {
    syLog(@"重置    QQ");
}

- (void)reSetEmail {
    syLog(@"重置    邮箱");
}

- (void)reSetLocation {
    syLog(@"重置   所在地");
}

- (void)setImagesArray:(NSArray *)imagesArray {
    self.iconImage.image = imagesArray.firstObject;
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
    [self.tableView reloadData];
}


#pragma mark - getter
- (ZLPhotoActionSheet *)actionSheet {
    if (!_actionSheet) {
        _actionSheet = [[ZLPhotoActionSheet alloc] init];

        _actionSheet.sender = self;

        _actionSheet.configuration.sortAscending = 0;
        _actionSheet.configuration.allowSelectImage = YES;
        _actionSheet.configuration.allowSelectGif = NO;
        _actionSheet.configuration.allowSelectVideo = NO;
        _actionSheet.configuration.allowSelectLivePhoto = NO;
        _actionSheet.configuration.allowForceTouch = YES;
        _actionSheet.configuration.allowSlideSelect = NO;
        _actionSheet.configuration.allowMixSelect = NO;
        _actionSheet.configuration.allowDragSelect = NO;

        //设置相册内部显示拍照按钮
        _actionSheet.configuration.allowTakePhotoInLibrary = YES;
        //设置在内部拍照按钮上实时显示相机俘获画面
        _actionSheet.configuration.showCaptureImageOnTakePhotoBtn = YES;
        //设置照片最大预览数
        _actionSheet.configuration.maxPreviewCount = 0;
        //设置照片最大选择数
        _actionSheet.configuration.maxSelectCount = 1;

        _actionSheet.configuration.navBarColor = NAVGATION_BAR_COLOR;
        //    actionSheet.configuration.navTitleColor = [UIColor blackColor];
        //        _actionSheet.configuration.bottomBtnsNormalTitleColor = [UIColor blueColor];
        //        _actionSheet.configuration.bottomBtnsDisableBgColor = [UIColor whiteColor];
        _actionSheet.configuration.bottomViewBgColor = NAVGATION_BAR_COLOR;
        //是否允许框架解析图片
        _actionSheet.configuration.shouldAnialysisAsset = YES;
        //框架语言
        _actionSheet.configuration.languageType = ZLLanguageChineseSimplified;

        //是否使用系统相机
        _actionSheet.configuration.useSystemCamera = YES;
        _actionSheet.configuration.sessionPreset = ZLCaptureSessionPreset1920x1080;
        _actionSheet.configuration.allowRecordVideo = NO;

        zl_weakify(self);
        [self.actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            zl_strongify(weakSelf);
            strongSelf.imagesArray = images;
            strongSelf.isOriginal = isOriginal;
            strongSelf.lastSelectAssets = assets.mutableCopy;
            strongSelf.lastSelectPhotos = images.mutableCopy;
        }];

        self.actionSheet.cancleBlock = ^{

        };
    }
    return _actionSheet;
}



@end
