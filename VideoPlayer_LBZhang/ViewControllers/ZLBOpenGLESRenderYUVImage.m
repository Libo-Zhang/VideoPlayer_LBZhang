//
//  ZLBOpenGLESRenderYUVImage.m
//  VideoPlayer_LBZhang
//
//  Created by LB_Zhang on 16/2/16.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ZLBOpenGLESRenderYUVImage.h"
#import "OpenGLView20.h"
@interface ZLBOpenGLESRenderYUVImage ()

@end

@implementation ZLBOpenGLESRenderYUVImage
{
    NSData *yuvData;
    OpenGLView20 * myview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *yuvFile = [[NSBundle mainBundle] pathForResource:@"jpgimage1_image_640_480" ofType:@"yuv"];
    yuvData = [NSData dataWithContentsOfFile:yuvFile];
    NSLog(@"the reader length is %lu", (unsigned long)yuvData.length);
    
    myview = [[OpenGLView20 alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.height - 40)];
    [self.view addSubview:myview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UInt8 * pFrameRGB = (UInt8*)[yuvData bytes];
    [myview setVideoSize:640 height:480];
    [myview displayYUV420pData:pFrameRGB width:640 height:480];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
