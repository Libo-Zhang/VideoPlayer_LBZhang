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
//返回的数组是解析好的ZLBCategory
+(NSArray *)parseNSArray:(NSArray *)arraylist{

    //定义一个可变数组
    NSMutableArray *Arr = [NSMutableArray array];
    for (NSDictionary *dic in arraylist) {
        ZLBCategory *cate = [ZLBCategory new];
        //系统化自带的将字典转换为模型类的方法 用到了KVC
        [cate setValuesForKeysWithDictionary:dic];
        //可变数组添加
        [Arr addObject:cate];
    }
    return [Arr copy];
}
//返回的数组解析好的额ZLBClassVos
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
/** 返回的是ZLBClassContent*/
+(ZLBContent *)parseClassContent:(NSDictionary *)dictionary{
    ZLBContent *content = [[ZLBContent alloc] init];
    [content setValuesForKeysWithDictionary:dictionary];
    return content;
}
/** 返回的数组是ZLBClassContentVideo  ,from ZLBClassContent*/
+(NSArray *)parseVideoFromContent:(ZLBContent *)content{
    NSMutableArray *mutable = [NSMutableArray array];
    for (NSDictionary *dic in content.videoList) {
        ZLBClassContentVideo *video = [ZLBClassContentVideo new];
        [video setValuesForKeysWithDictionary:dic];
        [mutable addObject:video];
        
    }
    return [mutable copy];
    
    
}

@end
