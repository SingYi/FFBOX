//
//  DetialTableHeader.m
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFCustomLayout : UICollectionViewLayout

- (instancetype)init;

@property (nonatomic) CGSize itemSize;

@property (nonatomic) NSInteger visibleCount;

@property (nonatomic) UICollectionViewScrollDirection scrollDirection;


@end
