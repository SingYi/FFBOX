//
//  FFDetailPackageModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/4/3.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFDetailPackageModel : NSObject



/** card id */
@property (nonatomic, strong) NSString *card;
/** down load url */
@property (nonatomic, strong) NSString *download_url;
/** end time */
@property (nonatomic, strong) NSString *end_time;
/** start time */
@property (nonatomic, strong) NSString *start_time;
/**  game id */
@property (nonatomic, strong) NSString *game_id;
/** game name */
@property (nonatomic, strong) NSString *game_name;
/** game size */
@property (nonatomic, strong) NSString *game_size;
/** package id */
@property (nonatomic, strong) NSString *package_id;
/** logo url */
@property (nonatomic, strong) NSString *logo;
/** package abstract */
@property (nonatomic, strong) NSString *pack_abstract;
/** package counts */
@property (nonatomic, strong) NSString *pack_counts;
/** package method */
@property (nonatomic, strong) NSString *pack_method;
/** package name */
@property (nonatomic, strong) NSString *pack_name;
/** package notice */
@property (nonatomic, strong) NSString *pack_notice;
/** package used counts */
@property (nonatomic, strong) NSString *pack_used_counts;
/** game content */
@property (nonatomic, strong) NSString *game_content;
/** game  android_pack*/
@property (nonatomic, strong) NSString *android_pack;

+ (instancetype)sharedModel;

- (void)setInfoWithDictionary:(NSDictionary *)dict;





@end










