//
//  ViewController.m
//  VideoPlayer_LBZhang
//
//  Created by tarena on 15/12/31.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ABSMovieDecoder.h"
@interface ViewController ()
@property (nonatomic, strong)AVPlayer *player;

@end

@implementation ViewController

//- (AVPlayer *)player {
//    if(_player == nil) {
//        _player = [[AVPlayer alloc] init];
//        NSURL *musicUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"霍尊-卷珠帘(Live版)" ofType:@"mp3"]];
//        NSURL *url = [NSURL fileURLWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"5540385469401b10912f7a24-6.mp4"]];
//        
//        NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"ScreenFlow" withExtension:@".mp4" subdirectory:@"video.bundle"];
//  
//        NSURL *url3 = [[NSBundle mainBundle] URLForResource:@"mv" withExtension:@".mp4" subdirectory:@"video.bundle"];
//        //5540385469401b10912f7a24-6
//        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url3];
//        _player = [AVPlayer playerWithPlayerItem:item];
//        
//        
//    }
//    return _player;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
//
//    ABSMovieDecoder *absm = [ABSMovieDecoder new];
//    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"5540385469401b10912f7a24-6.mp4"];
//     NSURL *url = [NSURL fileURLWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"5540385469401b10912f7a24-6.mp4"]];
//    
//    NSString *path3 = [[NSBundle mainBundle]pathForResource:@"mv" ofType:@".mp4" inDirectory:@"video.bundle"];
//    NSURL *url3 = [[NSBundle mainBundle] URLForResource:@"mv" withExtension:@".mp4" subdirectory:@"video.bundle"];
//    
//    NSString *path2 = [[NSBundle mainBundle]pathForResource:@"silent_qcif" ofType:@"yuv"];
//    NSURL *url2 = [NSURL fileURLWithPath:path2];
//    
//    
//    
//   NSArray *images = [absm transformViedoPathToSampBufferRef:url2];
//    NSLog(@"视频解档完成");
//    // 得到媒体的资源
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:path3] options:nil];
//    // 通过动画来播放我们的图片
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
//    // asset.duration.value/asset.duration.timescale 得到视频的真实时间
//    animation.duration = asset.duration.value/asset.duration.timescale;
//    animation.values = images;
//    animation.repeatCount = MAXFLOAT;
//    [self.view.layer addAnimation:animation forKey:nil];
//     //确保内存能及时释放掉
//    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj) {
//            obj = nil;
//        }
//    }];
//   // [self.player play];
   
 
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//

@end
