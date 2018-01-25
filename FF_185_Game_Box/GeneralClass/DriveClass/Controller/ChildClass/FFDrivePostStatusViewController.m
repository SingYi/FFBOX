//
//  FFDrivePostStatusViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/16.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDrivePostStatusViewController.h"
#import "ZLPhotoActionSheet.h"
#import "FFPostStatusImageCell.h"
#import <Photos/Photos.h>
#import "UIAlertController+FFAlertController.h"

#define CELL_IDE @"FFPostStatusImageCell"

@interface FFDrivePostStatusViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *remindLabel;

@property (nonatomic, strong) UIView *imageContentView;

@property (nonatomic, strong) ZLPhotoActionSheet *actionSheet;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) UIBarButtonItem *sendButton;

@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;


@property (nonatomic, assign) BOOL isOriginal;

@end

@implementation FFDrivePostStatusViewController {
    CGRect textViewFrame;
    CGRect imageContentViewFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"发布状态";
    [self.view addSubview:self.remindLabel];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.collectionView];
    self.navigationItem.rightBarButtonItem = self.sendButton;
}

- (void)initDataSource {
    textViewFrame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 120);
    imageContentViewFrame = CGRectMake(0, CGRectGetMaxY(textViewFrame) + 8, kSCREEN_WIDTH, kSCREEN_WIDTH / 4 + 10);
}


- (void)selectIamge {

}

#pragma mark - responds
- (void)respondsToTap:(UITapGestureRecognizer *)sender {
    [self.textView resignFirstResponder];
}

- (void)respondsToSendButton {
    if (self.textView.text.length == 0 && self.imagesArray.count == 0) {
        [UIAlertController showAlertMessage:@"请输入要发送的状态\n或者选择要发送的图片" dismissTime:0.7 dismissBlock:nil];
    } else {

    }
}

#pragma mark - collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imagesArray.count < 4) {
        return self.imagesArray.count + 1;
    } else {
        return self.imagesArray.count;
    }

    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FFPostStatusImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDE forIndexPath:indexPath];

    if (indexPath.row + 1 > self.imagesArray.count) {
//        cell.backgroundColor = [UIColor blackColor];
        cell.type = addImage;
    } else {
        cell.type = showImage;
//        cell.backgroundColor = [UIColor whiteColor];
        cell.imageView.image = self.imagesArray[indexPath.row];
        PHAsset *asset = self.lastSelectAssets[indexPath.row];
        cell.playImageView.hidden = !(asset.mediaType == PHAssetMediaTypeVideo);
    }

//    cell.type = addImage;

    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    syLog(@"????????");
    FFPostStatusImageCell *cell = (FFPostStatusImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.type == addImage) {
        [self.actionSheet showPhotoLibrary];
    } else {
//        [self.actionSheet previewSelectedPhotos:self.lastSelectPhotos assets:self.lastSelectAssets index:indexPath.row isOriginal:self.isOriginal];
        [self.actionSheet previewSelectedPhotos:self.lastSelectPhotos assets:self.lastSelectAssets index:indexPath.row isOriginal:self.isOriginal];
    }
}

#pragma makr - text view delegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.remindLabel.hidden = YES;
    } else {
        self.remindLabel.hidden = NO;
    }
}

#pragma mark - getter
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:textViewFrame];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor clearColor];

    }
    return _textView;
}

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT + 8, 20, 20)];
        _remindLabel.text = @"  发表动态...";
        _remindLabel.font = [UIFont systemFontOfSize:15];
        _remindLabel.textColor = [UIColor lightGrayColor];
        [_remindLabel sizeToFit];
    }
    return _remindLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((kSCREEN_WIDTH - 12) / 4, (kSCREEN_WIDTH - 12) / 4);
        layout.minimumInteritemSpacing = 1.5;
        layout.minimumLineSpacing = 1.5;
        layout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
        _collectionView = [[UICollectionView alloc] initWithFrame:imageContentViewFrame collectionViewLayout:layout];
        [_collectionView registerClass:[FFPostStatusImageCell class] forCellWithReuseIdentifier:CELL_IDE];
        _collectionView.backgroundColor = [UIColor whiteColor];

        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}



- (ZLPhotoActionSheet *)actionSheet {
    if (!_actionSheet) {
        _actionSheet = [[ZLPhotoActionSheet alloc] init];
        
        _actionSheet.sender = self;

        _actionSheet.configuration.sortAscending = 0;
        _actionSheet.configuration.allowSelectImage = YES;
        _actionSheet.configuration.allowSelectGif = YES;
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
        _actionSheet.configuration.maxSelectCount = 4;


        //设置允许选择的视频最大时长
        _actionSheet.configuration.maxVideoDuration = 1;
        //设置照片cell弧度
        _actionSheet.configuration.cellCornerRadio = 4;
        //单选模式是否显示选择按钮
        //    actionSheet.configuration.showSelectBtn = YES;
        //是否在选择图片后直接进入编辑界面
//        actionSheet.configuration.editAfterSelectThumbnailImage = self.editAfterSelectImageSwitch.isOn;
        //是否保存编辑后的图片
        //    actionSheet.configuration.saveNewImageAfterEdit = NO;
        //设置编辑比例
        //    actionSheet.configuration.clipRatios = @[GetClipRatio(7, 1)];
        //是否在已选择照片上显示遮罩层
//        actionSheet.configuration.showSelectedMask = self.maskSwitch.isOn;
        //颜色，状态栏样式
//            actionSheet.configuration.selectedMaskColor = [UIColor purpleColor];
        _actionSheet.configuration.navBarColor = NAVGATION_BAR_COLOR;
        //    actionSheet.configuration.navTitleColor = [UIColor blackColor];
//        _actionSheet.configuration.bottomBtnsNormalTitleColor = [UIColor blueColor];
//        _actionSheet.configuration.bottomBtnsDisableBgColor = [UIColor whiteColor];
        _actionSheet.configuration.bottomViewBgColor = NAVGATION_BAR_COLOR;
        //    actionSheet.configuration.statusBarStyle = UIStatusBarStyleDefault;
        //是否允许框架解析图片
        _actionSheet.configuration.shouldAnialysisAsset = YES;
        //框架语言
        _actionSheet.configuration.languageType = ZLLanguageChineseSimplified;

        //是否使用系统相机
        _actionSheet.configuration.useSystemCamera = YES;
        _actionSheet.configuration.sessionPreset = ZLCaptureSessionPreset1920x1080;
//        _actionSheet.configuration.exportVideoType = ZLExportVideoTypeMp4;
        _actionSheet.configuration.allowRecordVideo = NO;

        zl_weakify(self);
        [self.actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            zl_strongify(weakSelf);
            strongSelf.imagesArray = images;
            strongSelf.isOriginal = isOriginal;
            strongSelf.lastSelectAssets = assets.mutableCopy;
            strongSelf.lastSelectPhotos = images.mutableCopy;
            [strongSelf.collectionView reloadData];

        }];

//        [self.actionSheet previewPhotos:@[@"gif"] index:0 hideToolBar:NO complete:^(NSArray * _Nonnull photos) {
////            zl_strongify(weakSelf);
//            syLog(@"photots = %@",photos);
//        }];

        self.actionSheet.cancleBlock = ^{
            //        NSLog(@"取消选择图片");
        };
    }
    return _actionSheet;
}

- (UIBarButtonItem *)sendButton {
    if (!_sendButton) {
        _sendButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToSendButton)];
    }
    return _sendButton;
}


@end




















