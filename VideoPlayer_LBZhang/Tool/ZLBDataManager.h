//
//  ZLBDataManager.h
//  VideoPlayer_LBZhang
//
//  Created by tarena on 16/1/3.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLBDataManager : NSObject

+(NSArray *)parseNSArray:(NSArray *)arraylist;
+(NSArray *)parseClassByType:(NSInteger)type withNSArray:(NSArray *)arr;
@end
