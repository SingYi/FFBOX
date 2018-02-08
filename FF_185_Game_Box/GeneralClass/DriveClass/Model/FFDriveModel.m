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
#import <Photos/Photos.h>
#import "FFDriveUserModel.h"


@implementation FFDriveModel

/** 发状态 */
+ (void)postDynamicWith:(NSString *)content Images:(NSArray *)imgs Complete:(FFCompleteBlock)completion {

    if ((content == nil || content.length == 0) && (imgs.count == 0)) {
        return;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[self userModel].uid forKey:@"uid"];
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
                           Completion:(FFCompleteBlock)completion
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
                                                         @"image/gif",
                                                         nil];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:content forKey:@"content"];
    NSLog(@"dict == %@",dict);
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"content"])) forKey:@"sign"];


    NSURLSessionDataTask *task = [manager POST:[FFMapModel map].PUBLISH_DYNAMICS parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {

        //上传的多张照片
        for (int i = 0; i < images.count; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName;
            id image = images[i];
            if ([image isKindOfClass:[PHAsset class]]) {
                fileName = [NSString stringWithFormat:@"%@.gif", str];
                PHImageRequestOptions *options = [PHImageRequestOptions new];
                options.resizeMode = PHImageRequestOptionsResizeModeFast;
                options.synchronous = YES;
                PHCachingImageManager *manager = [PHCachingImageManager new];

                [manager requestImageDataForAsset:image options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    if ([dataUTI isEqualToString:(__bridge NSString *)kUTTypeGIF]) {
                        syLog(@"gif");
                        [formData appendPartWithFileData:imageData name:@"imgs[]" fileName:fileName mimeType:@""];
                    }
                }];
            } else {
                fileName = [NSString stringWithFormat:@"%@.png", str];
                UIImage *image = images[i];
                NSData *imageData = UIImagePNGRepresentation(image);
                [formData appendPartWithFileData:imageData name:@"imgs[]" fileName:fileName mimeType:@""];
            }
        }


    } progress:^(NSProgress *_Nonnull uploadProgress) {


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
+ (void)getDynamicWithType:(DynamicType)type Page:(NSString *)page CheckUid:(NSString *)buid Complete:(FFCompleteBlock)completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    if (SSKEYCHAIN_UID) {
        [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    }
    if (type == CheckUserDynamic && buid) {
        [dict setObject:buid forKey:@"buid"];
    }
    [dict setObject:[NSString stringWithFormat:@"%lu",(NSUInteger)type] forKey:@"type"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:(BOX_SIGN(dict, (@[@"type",@"page"]))) forKey:@"sign"];


    [FFBasicModel postRequestWithURL:[FFMapModel map].GET_DYNAMICS params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];

}

/** like or dislike */
+ (void)userLikeOrDislikeWithDynamicsID:(NSString *)dynamics_id type:(LikeOrDislike)type Complete:(FFCompleteBlock)completion {

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
+ (void)userComeentListWithDynamicsID:(NSString *)dynamicsID type:(CommentType)type page:(NSString *)page Complete:(FFCompleteBlock)completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    if (SSKEYCHAIN_UID != nil && SSKEYCHAIN_UID.length != 0) {
        [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    } else {
        [dict setObject:@"0" forKey:@"uid"];
    }
    syLog(@"comment uid === %@",dict);
    [dict setObject:Channel forKey:@"channel"];
    if (dynamicsID == nil) {
        return;
    }
    [dict setObject:dynamicsID forKey:@"dynamics_id"];
    [dict setObject:[NSString stringWithFormat:@"%lu",(NSUInteger)type] forKey:@"type"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"dynamics_id",@"type",@"page"]))) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].COMMENT_LIST params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}


/** 发布评论 */
+ (void)userSendCommentWithjDynamicsID:(NSString *)dynamicsID ToUid:(NSString *)toUid Comment:(NSString *)comment Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];

    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    (toUid != nil) ? [dict setObject:toUid forKey:@"to_uid"] : [dict setObject:@"0" forKey:@"to_uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:dynamicsID forKey:@"dynamics_id"];
    [dict setObject:comment forKey:@"content"];

    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"to_uid",@"channel",@"dynamics_id",@"content"]))) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].COMMENT params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];

}

/** 赞或者踩评论 */
+ (void)userLikeOrDislikeComment:(NSString *)comment_id Type:(LikeOrDislike)type Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:comment_id forKey:@"comment_id"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"type"];

    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"comment_id",@"type"]))) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].COMMENT_LIKE params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];

}

/** 删除评论 */
+ (void)userDeleteCommentWith:(NSString *)comment_id Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:comment_id forKey:@"comment_id"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"comment_id"]))) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].COMMENT_DEL params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 关注用户 */
+ (void)userAttentionWith:(NSString *)attentionUid Type:(AttentionType)type Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:attentionUid forKey:@"buid"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"type"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"buid",@"type"]))) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].FOLLOW_OR_CANCEL params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 分享 */
+ (void)userSharedDynamics:(NSString *)Dynamics Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:Dynamics forKey:@"id"];
    [dict setObject:(BOX_SIGN(dict, (@[@"id"]))) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].SHARE_DYNAMICS params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 关注 / 粉丝 */
+ (void)userFansAndAttettionWithUid:(NSString *)uid Page:(NSString *)page Type:(FansOrAttention)type Complete:(FFCompleteBlock)completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:uid forKey:@"uid"];
    [dict setObject:SSKEYCHAIN_UID forKey:@"visit_uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"type"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"visit_uid",@"channel",@"type",@"page"]))) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].FOLLOW_LIST params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 查询用户信息 */
+ (void)userInfomationWithUid:(NSString *)uid fieldType:(FieldType)type Complete:(FFCompleteBlock)completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
    [dict setObject:uid forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"field_type"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"field_type"]))) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].USER_DESC params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 编辑信息 */
+ (void)userEditInfoMationWithNickName:(NSString *)nick_name
                                   sex:(NSString *)sex
                               address:(NSString *)address
                                  desc:(NSString *)desc
                                 birth:(NSString *)birth
                                    qq:(NSString *)qq
                                 email:(NSString *)email
                              Complete:(FFCompleteBlock)completion
{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];

    if (!nick_name) {
        nick_name = @"";
    }
    [dict setObject:nick_name forKey:@"nick_name"];

    if (!sex) {
        sex = @"";
    }
    [dict setObject:sex forKey:@"sex"];

    if (!address) {
        address = @"";
    }
    [dict setObject:address forKey:@"address"];

    if (!desc) {
        desc = @"";
    }
    [dict setObject:desc forKey:@"desc"];

    if (!birth) {
        birth = @"";
    }
    [dict setObject:birth forKey:@"birth"];

    if (!qq) {
        qq = @"";
    }
    [dict setObject:qq forKey:@"qq"];

    if (!email) {
        email = @"";
    }
    [dict setObject:email forKey:@"email"];

    NSArray *para = @[@"uid",@"channel",@"nick_name",@"sex",@"address",@"desc",@"birth",@"qq",@"email"];
    [dict setObject:(BOX_SIGN(dict, para)) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].USER_EDIT params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

+ (void)userEditInfoMationWIthDict:(NSDictionary *)dict Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *redict = [@{@"uid":SSKEYCHAIN_UID,
                                     @"channel":Channel,
                                     @"nick_name":@"",
                                     @"sex":@"",
                                     @"address":@"",
                                     @"desc":@"",
                                     @"birth":@"",
                                     @"qq":@"",
                                     @"email":@""
                                   } mutableCopy];

    NSArray *allKeys = dict.allKeys;
    [allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [redict setObject:dict[obj] forKey:obj];
    }];

    NSArray *para = @[@"uid",@"channel",@"nick_name",@"sex",@"address",@"desc",@"birth",@"qq",@"email"];
    [redict setObject:(BOX_SIGN(redict, para)) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].USER_EDIT params:redict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}


+ (FFDriveUserModel *)userModel {
    return [FFDriveUserModel sharedModel];
}



+ (void)myNewNumbersComplete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    if (SSKEYCHAIN_UID == nil || SSKEYCHAIN_UID.length < 1) {
        if (completion) {
            completion(nil,NO);
        }
        return;
    }
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel"]))) forKey:@"sign"];
    [FFBasicModel postRequestWithURL:[FFMapModel map].USER_NEW_UP params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

+ (void)myNewsWithType:(MyNewsType)type page:(NSString *)page Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    if (SSKEYCHAIN_UID == nil || SSKEYCHAIN_UID.length < 1) {
        if (completion) {
            completion(nil,NO);
        }
        return;
    }
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"type"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"type",@"page"]))) forKey:@"sign"];

    [FFBasicModel postRequestWithURL:[FFMapModel map].USER_COMMENT_ZAN params:dict completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}





@end
