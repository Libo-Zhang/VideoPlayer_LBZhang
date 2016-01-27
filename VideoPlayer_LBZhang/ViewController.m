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
#define TOPVIEW_HEIGHT 64
#define RIGHT_WIDTH 50
#define ROTATOR_BOTTOM_HEIGHT 50
#define VERTICAL_BOTTOM_HEIGHT 90
#define ZERO 0
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UIGestureRecognizerDelegate>
//view
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (weak, nonatomic) IBOutlet UIView *buttomView;

//topView 中的
@property (weak, nonatomic) IBOutlet UILabel *topPastTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *topProgressSlider;
@property (weak, nonatomic) IBOutlet UILabel *topRemainLable;

//bottomView 中的
@property (weak, nonatomic) IBOutlet UISlider *bottomSlider;


@property (weak, nonatomic) IBOutlet UIButton *playButton;


//第一次点击
@property (nonatomic, assign) BOOL isFirstTap;
//AVPlayer
@property (nonatomic, strong)AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) BOOL isPlayOrParse;
//  保存该视频资源的总时长，快进或快退的时候要用
@property (nonatomic, assign) CGFloat totalMovieDuration;

@end

@implementation ViewController

#pragma mark - 懒加载
- (AVPlayer *)player {
    if (!_player) {
        if (self.movieURL) {
            AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.movieURL];
            self.player = [AVPlayer playerWithPlayerItem:item];
            //  添加进度观察
           // [self addProgressObserver];
            //[self addObserverToPlayerItem:item];
        }
    }
    return _player;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieURL = [[NSBundle mainBundle] URLForResource:@"mv" withExtension:@".mp4"];
    self.view.backgroundColor = [UIColor blackColor];
    
    //播放页面添加轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAllSubViews:)];
    [self.view addGestureRecognizer:tap];
    tap.delegate =self;
    
    [self addNotificationCenters];
    
    //创建显示层
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self setPlayerLayerFrame];
    //这是视频的填充模式,默认为 AVLayerVideoGravityResizeAspect
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //插到 view 层上面,没有用 addSubLayer
    [self.view.layer insertSublayer:_playerLayer atIndex:0];

    
    
}
- (void)addNotificationCenters {
    //  注册观察者用来观察，是否播放完毕
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //  注册观察者来观察屏幕的旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeRight) {
        [self setPlayerLayerFrame];
        self.isFirstTap = YES;
       // [self setTopRightBottmFrame];
    }
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        [self setPlayerLayerFrame];
        self.isFirstTap = YES;
         // [self setTopRightBottmFrame];
    }
    if (orientation == UIInterfaceOrientationPortrait) {
        [self setPlayerLayerFrame];
        self.isFirstTap = YES;
        //  [self setTopRightBottmFrame];
    }
    
}
#pragma mark 动画出现或隐藏 top-right-bottom
-(void)dismissAllSubViews:(UITapGestureRecognizer *)tap{
    [self setTopRightBottmFrame];
}
-(void)setTopRightBottmFrame{
    __weak typeof (self) myself = self;
    if (!self.isFirstTap) {
        [UIView animateWithDuration:.2f animations:^{
            myself.topView.frame = CGRectMake(myself.topView.frame.origin.x, -TOPVIEW_HEIGHT, myself.topView.frame.size.width, myself.topView.frame.size.height);
            myself.rightView.frame = CGRectMake(SCREEN_WIDTH, myself.rightView.frame.origin.y, myself.rightView.frame.size.width, myself.rightView.frame.size.height);
            myself.buttomView.frame = CGRectMake(myself.buttomView.frame.origin.x, SCREEN_HEIGHT, myself.buttomView.frame.size.width, myself.buttomView.frame.size.height);
         
        }];
        self.isFirstTap = YES;
    } else {
        [UIView animateWithDuration:.2f animations:^{
            myself.topView.frame = CGRectMake(myself.topView.frame.origin.x, ZERO, myself.topView.frame.size.width, myself.topView.frame.size.height);
            myself.rightView.frame = CGRectMake(SCREEN_WIDTH - RIGHT_WIDTH, myself.rightView.frame.origin.y, myself.rightView.frame.size.width, myself.rightView.frame.size.height);
            myself.buttomView.frame = CGRectMake(myself.buttomView.frame.origin.x, SCREEN_HEIGHT - VERTICAL_BOTTOM_HEIGHT, myself.buttomView.frame.size.width, myself.buttomView.frame.size.height);
           
        }];
        self.isFirstTap = NO;
    }

}
- (void)setPlayerLayerFrame {
    CGRect frame = self.view.bounds;
    frame.origin.x = ZERO;
    frame.origin.y = ZERO;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = SCREEN_HEIGHT;
    _playerLayer.frame = frame;
}
#pragma mark Play
- (IBAction)playMovie:(id)sender {
    [self.player play];
    _playButton.imageView.image = nil;
 
    [_playButton setImage:[UIImage imageNamed:@"播放器_暂停"] forState: UIControlStateNormal];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//

@end
