//
//  HomeClassifyController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFClassifyController : UIViewController

@property (nonatomic, strong) NSString *platform;

- (void)refrehTableView;
- (void)initDataSource;

- (void)setPlatform:(NSString *)platform;



@end
