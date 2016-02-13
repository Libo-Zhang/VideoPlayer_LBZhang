//
//  ZLBNavController.m
//  VideoPlayer_LBZhang
//
//  Created by LB_Zhang on 16/2/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ZLBNavController.h"

@interface ZLBNavController ()<UIGestureRecognizerDelegate>

@end

@implementation ZLBNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}


@end
