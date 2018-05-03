//
//  FFRecommentController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicViewController.h"
#import "FFRecommentCarouselView.h"

@interface FFRecommentController : FFBasicViewController<UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, FFRecommentCarouselViewDelegate>

/**轮播图*/
@property (nonatomic, strong) FFRecommentCarouselView *carouselView;
/**头部视图*/

@property (nonatomic, strong) NSArray *collectionArray;
@property (nonatomic, strong) NSArray *collectionImage;
@property (nonatomic, strong) UICollectionView *collectionView;

//
@property (nonatomic, strong) NSMutableArray<UIViewController *> *childControllers;

@end
