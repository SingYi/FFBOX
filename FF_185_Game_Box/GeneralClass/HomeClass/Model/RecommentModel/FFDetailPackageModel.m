//
//  FFDetailPackageModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/4/3.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDetailPackageModel.h"


static FFDetailPackageModel *model = nil;
@implementation FFDetailPackageModel

+ (instancetype)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [FFDetailPackageModel new];
        }
    });

    return model;
}


- (void)setInfoWithDictionary:(NSDictionary *)dict {
    NSMutableDictionary *mudict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mudict setValue:dict[@"id"] forKey:@"package_id"];
    [mudict removeObjectForKey:@"id"];
    [self setValuesForKeysWithDictionary:mudict];
}



@end
