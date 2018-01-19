//
//  FFDriveModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/8.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveModel.h"
#import "FFMapModel.h"
#import "SYKeychain.h"
#import "AFHTTPSessionManager.h"

@implementation FFDriveModel

/** 发状态 */
+ (void)postDynamicWith:(NSString *)content Images:(NSArray *)imgs Complete:(CompleteBlock)completion {

    if ((content == nil || content.length == 0) && (imgs.count == 0)) {
        return;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:content forKey:@"content"];
    NSLog(@"dict == %@",dict);
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"content"])) forKey:@"sign"];
    if (imgs.count > 0) {
        [dict setObject:imgs forKey:@"imgs"];
    }

    [FFBasicModel postRequestWithURL:[FFMapModel map].PUBLISH_DYNAMICS params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}


#pragma mark - ======================= 上传头像 =======================
/** 发动态 */
+ (void)userUploadPortraitWithContent:(NSString *)content
                                Image:(NSArray<UIImage *> *)images
                           Completion:(CompleteBlock)completion
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         @"text/txt",
                                                         nil];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:content forKey:@"content"];
    NSLog(@"dict == %@",dict);
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"content"])) forKey:@"sign"];


    NSURLSessionDataTask *task = [manager POST:[FFMapModel map].PUBLISH_DYNAMICS parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {

        //上传的多张照片
        for (int i = 0; i < images.count; i++) {
            UIImage *image = images[i];
            NSData *imageData = UIImagePNGRepresentation(image);
//
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];

//            NSLog(@"di %ld zhang",i);
//        NSData *imageData = [NSKeyedArchiver archivedDataWithRootObject:images];
            [formData appendPartWithFileData:imageData name:@"imgs[]" fileName:fileName mimeType:@""];

//            NSLog(@"%d   form data %@",i,formData);
        }


//        NSLog(@"form data %@",formData);

    } progress:^(NSProgress *_Nonnull uploadProgress) {
//        NSLog(@"%@",uploadProgress);

    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        if (completion) {
            completion(responseObject, YES);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil, NO);
        }
    }];

    [task resume];

}


/** get dynamic */
+ (void)getDynamicWithType:(DynamicType)type Page:(NSString *)page Complete:(CompleteBlock)completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    if (SSKEYCHAIN_UID) {
        [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    }
    [dict setObject:[NSString stringWithFormat:@"%lu",(NSUInteger)type] forKey:@"type"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:(BOX_SIGN(dict, (@[@"type",@"page"]))) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].GET_DYNAMICS params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];

}

/** like or dislike */
+ (void)userLikeOrDislikeWithDynamicsID:(NSString *)dynamics_id type:(LikeOrDislike)type Complete:(CompleteBlock)completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    if (SSKEYCHAIN_UID != nil && SSKEYCHAIN_UID.length != 0) {
        [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    } else {
        if (completion) {
            completion(@{@"status":@"没有登录"},NO);
        }
        return;
    }
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:dynamics_id forKey:@"dynamics_id"];
    [dict setObject:[NSString stringWithFormat:@"%lu",(NSUInteger)type] forKey:@"type"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"dynamics_id",@"type"]))) forKey:@"sign"];


    syLog(@"send like or dis like === %@",dict);
    [FFBasicModel postRequestWithURL:[FFMapModel map].DYNAMICS_LIKE params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];

}

/** comment  */
+ (void)userComeentListWithDynamicsID:(NSString *)dynamicsID type:(CommentType)type page:(NSString *)page Complete:(CompleteBlock)completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    if (SSKEYCHAIN_UID != nil && SSKEYCHAIN_UID.length != 0) {
        [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    } else {
        [dict setObject:@"0" forKey:@"uid"];
    }
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:dynamicsID forKey:@"dynamics_id"];
    [dict setObject:[NSString stringWithFormat:@"%lu",(NSUInteger)type] forKey:@"type"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"dynamics_id",@"type",@"page"]))) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].COMMENT_LIST params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}







@end
