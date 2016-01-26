//
//  ZLBDataManager.m
//  VideoPlayer_LBZhang
//
//  Created by tarena on 16/1/3.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ZLBDataManager.h"
#import "ZLBCategory.h"
#import "ZLBClassVos.h"
@implementation ZLBDataManager

+(NSArray *)parseNSArray:(NSArray *)arraylist{
    NSMutableArray *Arr = [NSMutableArray array];
    for (NSDictionary *dic in arraylist) {
        ZLBCategory *cate = [ZLBCategory new];
        [cate setValuesForKeysWithDictionary:dic];
        [Arr addObject:cate];
    }
    return [Arr copy];
}
+(NSArray *)parseClassByType:(NSInteger)type withNSArray:(NSArray *)arr{
    ZLBCategory *cate = arr[type];
    NSArray *vos = cate.vos;
    NSMutableArray *Arr = [NSMutableArray array];
    for (NSDictionary *dic in vos) {
        ZLBClassVos *vos = [ZLBClassVos new];
        [vos setValuesForKeysWithDictionary:dic];
        [Arr addObject:vos];
    }
    return [Arr copy];
}

@end
