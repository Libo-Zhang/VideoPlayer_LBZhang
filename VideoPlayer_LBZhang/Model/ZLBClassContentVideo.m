//
//  ZLBClassContentVideo.m
//  VideoPlayer_LBZhang
//
//  Created by LB_Zhang on 16/2/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ZLBClassContentVideo.h"

@implementation ZLBClassContentVideo
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"repovideourlmp4"]) {
        self.repovideourlmp4 = value;
    }
}
@end
