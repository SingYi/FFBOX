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
#import "UIAlertController+FFAlertController.h"
#import "SYKeychain.h"
#import "MBProgressHUD.h"
#import "ZLPhotoActionSheet.h"
#import <Photos/Photos.h>

#import "FFDriveModel.h"
#import "FFUserModel.h"
#import "FFDriveUserModel.h"

#define CELL_IDE @"DetailMineInfoCell"
#define STR_NIL_RETURN if (str == nil || [str isKindOfClass:[NSNull class]]) {\
return;\
}


typedef enum : NSUInteger {
    modifyNickName,
    modifyIntroduction,
    modifyBirthday,
    modifySex,
    modifyQQ,
    modifyEmail,
    modifyLocation
} ModifyType;


@interface FFModifyInfomationViewController : UIViewController

@property (nonatomic, strong) void(^FFEnterCallBackBlock)(NSString * content);
@property (nonatomic, assign) ModifyType type;
@property (nonatomic, strong) NSString *OriginalContent;

+ (instancetype)ControllerWithType:(ModifyType)type;

- (void)showPickerViewWithType:(ModifyType)type;

@end



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

@property (nonatomic, strong) FFModifyInfomationViewController *modifyController;
@property (nonatomic, strong) NSString *modifyContent;

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation FFDetailMineInfoTableViewController {
    BOOL selectButton;
    BOOL isRefres;
    ModifyType modifyType;
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
    [self refreshData];
}

- (void)refreshData {
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

    [self.tableView reloadData];
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
    NSString *timeString = [NSString stringWithFormat:@"%@",str];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeString.integerValue];
    self.creatTimeLabel.text = [formatter stringFromDate:date];
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
    modifyType = modifyNickName;
    self.modifyController.OriginalContent = self.nickNameLabel.text;
    self.modifyController.type = modifyNickName;
    [self.navigationController pushViewController:self.modifyController animated:YES];
}

- (void)reSetDescription {
    syLog(@"重置   简介");
    modifyType = modifyIntroduction;
    self.modifyController.OriginalContent = self.contentLabel.text;
    self.modifyController.type = modifyIntroduction;
    [self.navigationController pushViewController:self.modifyController animated:YES];
}

- (void)reSetSex {
    syLog(@"重置   性别");
    modifyType = modifySex;
}

- (void)reSetBirthDay {
    syLog(@"重置   生日");
    modifyType = modifyBirthday;
    [self showModifyWindow:self.birthdayLabel.text Type:modifyBirthday];
}

- (void)reSetQQ {
    syLog(@"重置    QQ");
    [self pushModifyWith:self.QQLabel.text Type:modifyQQ];
}

- (void)pushModifyWith:(NSString *)text Type:(ModifyType)type {
    modifyType = type;
    self.modifyController.OriginalContent = text;
    self.modifyController.type = type;
    [self.navigationController pushViewController:self.modifyController animated:YES];
}

- (void)showModifyWindow:(NSString *)text Type:(ModifyType)type {
    modifyType = type;
    self.modifyController.OriginalContent = text;
    self.modifyController.type = type;
    [self.modifyController showPickerViewWithType:type];
}

- (void)reSetEmail {
    syLog(@"重置    邮箱");
    modifyType = modifyEmail;
    self.modifyController.OriginalContent = self.EmailLabel.text;
    self.modifyController.type = modifyEmail;
    [self.navigationController pushViewController:self.modifyController animated:YES];
}

- (void)reSetLocation {
    modifyType = modifyLocation;
    syLog(@"重置   所在地");
}

- (void)setModifyContent:(NSString *)modifyContent {
    _modifyContent = modifyContent;
    NSString *type;
    switch (modifyType) {
        case modifyNickName: type = @"nick_name"; break;
        case modifyIntroduction: type = @"desc"; break;
        case modifySex: type = @"sex"; break;
        case modifyBirthday: type = @"birth"; break;
        case modifyQQ: type = @"qq"; break;
        case modifyEmail: type = @"email"; break;
        case modifyLocation: type = @"address"; break;
        default:
            break;
    }

    [self userModifyWith:@{type:modifyContent}];
}

- (void)userModifyWith:(NSDictionary *)dict {
    syLog(@"修改  dict == %@",dict);
    [FFDriveModel userEditInfoMationWIthDict:dict Complete:^(NSDictionary *content, BOOL success) {
        syLog(@"edit call back === %@",content);
        if (success) {
            [self refreshData];
        }
    }];
}


- (void)setImagesArray:(NSArray *)imagesArray {
    self.iconImage.image = imagesArray.firstObject;
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
        [_actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
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

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.62)];
        _datePicker.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
        _datePicker.datePickerMode = UIDatePickerModeDate;
//        _datePicker.date = [NSDate dateWithTimeIntervalSince1970:0];
        _datePicker.backgroundColor = [UIColor whiteColor];
    }
    return _datePicker;
}


- (FFModifyInfomationViewController *)modifyController {
    if (!_modifyController) {
        _modifyController = [[FFModifyInfomationViewController alloc] init];
    }
    WeakSelf;
    [_modifyController setFFEnterCallBackBlock:^(NSString *content) {
        weakSelf.modifyContent = content;
    }];
    return _modifyController;
}

@end



@interface FFModifyInfomationViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIBarButtonItem *completeButton;
@property (nonatomic, assign) NSUInteger maxStringCount;
@property (nonatomic, strong) UIWindow *showWindow;

@end

@implementation FFModifyInfomationViewController


+ (instancetype)ControllerWithType:(ModifyType)type {
    FFModifyInfomationViewController *controller = [[FFModifyInfomationViewController alloc] init];

    return controller;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.completeButton;
}

- (void)showPickerViewWithType:(ModifyType)type {
    self.view.backgroundColor = [UIColor clearColor];
    [self.showWindow makeKeyAndVisible];
}

#pragma mark - responds
- (void)respondsToCompleteButton {
    NSString *content = (self.type == modifyIntroduction) ? self.textView.text : self.textFiled.text;
    if (content.length < 1) {
        [UIAlertController showAlertMessage:@"请输入要修改的信息" dismissTime:0.7 dismissBlock:nil];
        return;
    }

    if ([content isEqualToString:self.OriginalContent]) {

        return;
    }

    [self.navigationController popViewControllerAnimated:YES];
    if (self.FFEnterCallBackBlock) {
        self.FFEnterCallBackBlock(content);
    }
}

- (void)respondsToCancelWindow {
    [self.showWindow resignKeyWindow];
    self.showWindow = nil;
}


#pragma mark - setter
- (void)setType:(ModifyType)type {
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    _type = type;
    switch (type) {
        case modifyNickName: {
            self.textFiled.text = self.OriginalContent;
            self.textFiled.placeholder = @"请输入昵称 : ";
            self.navigationItem.title = @"修改昵称";
            self.maxStringCount = 12;
        }
            break;
        case modifyQQ: {
            self.textFiled.text = self.OriginalContent;
            self.textFiled.placeholder = @"请输入QQ : ";
            self.navigationItem.title = @"修改QQ";
            self.maxStringCount = 12;
        }
            break;
        case modifyEmail: {
            self.textFiled.text = self.OriginalContent;
            self.textFiled.placeholder = @"请输入Email : ";
            self.navigationItem.title = @"修改Email";
            self.maxStringCount = 20;
        }
            break;
        case modifyIntroduction: {
            self.textView.text = self.OriginalContent;
            self.navigationItem.title = @"修改简介";
            self.maxStringCount = 30;
        }
            break;
        default:
            break;
    }
    (type == modifyIntroduction) ? [self addTextView] : [self addTextFiledView];
}




- (void)addTextFiledView {
    [self.textView removeFromSuperview];
    [self.view addSubview:self.textFiled];
    [self.textFiled becomeFirstResponder];
}

- (void)addTextView {
    [self.textFiled removeFromSuperview];
    [self.view addSubview:self.textView];
    [self.textView becomeFirstResponder];
}

- (void)setOriginalContent:(NSString *)OriginalContent {
    _OriginalContent = @"";
    if (OriginalContent != nil) {
        _OriginalContent = OriginalContent;
    }

    syLog(@"_OriginalContent  -=== %@",_OriginalContent);
    self.textFiled.text = _OriginalContent;
    self.textView.text = _OriginalContent;
}

#pragma mark - textfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self respondsToCompleteButton];
    return YES;
}

//限制用户名和密码长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 1 && string.length == 0) {
        return YES;
    } else if (textField.text.length >= 12) {
        textField.text = [textField.text substringToIndex:12];
        return NO;
    }
    return YES;
}

#pragma mark - text view delegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 30) {
        textView.text = [textView.text substringToIndex:30];
    }
}

#pragma mark - getter
- (UITextField *)textFiled {
    if (!_textFiled) {
        _textFiled = [[UITextField alloc] init];
        _textFiled.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _textFiled.center = CGPointMake(kSCREEN_WIDTH / 2, 120);
        _textFiled.borderStyle = UITextBorderStyleRoundedRect;
        _textFiled.delegate = self;
    }
    return _textFiled;
}

-(UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 88, kSCREEN_WIDTH - 10, 160)];
        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _textView.layer.borderWidth = 1;
        _textView.layer.cornerRadius = 4;
        _textView.layer.masksToBounds = YES;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
    }
    return _textView;
}

- (UIBarButtonItem *)completeButton {
    if (!_completeButton) {
        _completeButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToCompleteButton)];
    }
    return _completeButton;
}

- (UIWindow *)showWindow {
    if (!_showWindow) {
        _showWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _showWindow.rootViewController = self;
        _showWindow.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToCancelWindow)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_showWindow addGestureRecognizer:tap];
    }
    return _showWindow;
}









@end




























