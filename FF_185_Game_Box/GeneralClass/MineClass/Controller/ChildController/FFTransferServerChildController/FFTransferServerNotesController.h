//
//  FFTransferServerNotesController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/10.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFTransferServerNotesController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *showArray;

- (void)initUserInterface;

- (void)initDataSource;

- (void)getData;


- (NSString *)plistPath;


@end
