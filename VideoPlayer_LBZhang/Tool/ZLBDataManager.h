//
//  ZLBDataManager.h
//  VideoPlayer_LBZhang
//
//  Created by tarena on 16/1/3.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLBContent.h"
#import "ZLBClassContentVideo.h"
@interface ZLBDataManager : NSObject
/** 返回的数组是解析好的ZLBCategory  */
+(NSArray *)parseNSArray:(NSArray *)arraylist;
/** 返回的数组是ZLBClassVos */
+(NSArray *)parseClassByType:(NSInteger)type withNSArray:(NSArray *)arr;

/** 返回的是ZLBClassContent*/
+(ZLBContent *)parseClassContent:(NSDictionary *)dictionary;

/** 返回的数组是ZLBClassContentVideo  ,from ZLBClassContent*/
+(NSArray *)parseVideoFromContent:(ZLBContent *)content;


@end
