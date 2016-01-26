//
//  TestViewController.m
//  VideoPlayer_LBZhang
//
//  Created by tarena on 16/1/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TestViewController.h"
#import "ZLBYUV.h"
#import <AVFoundation/AVFoundation.h>
@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"silent_qcif" ofType:@"yuv"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    CMTime time ;
//    CVPixelBufferRef pixelBuffer = [ZLBYUV yuvPixelBufferWithData:data presentationTime:time width:100 heigth:100];
//    
//    CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer];
//    //UIImage *image= [UIImage imageWithCIImage:ciImage];//:newImage scale:1.0  orientation:UIImageOrientationRight];
//    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
//    CGImageRef videoImage = [temporaryContext
//                             createCGImage:ciImage
//                             fromRect:CGRectMake(0, 0,
//                                                 CVPixelBufferGetWidth(pixelBuffer),
//                                                 CVPixelBufferGetHeight(pixelBuffer))];
//    
//    UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
//    CGImageRelease(videoImage);
//    self.imageview.image = uiImage;
   // [self.view performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    
   
    
    
    
}
-(void)setImage:(UIImage *)image{
    
    self.imageview.image = image;
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
