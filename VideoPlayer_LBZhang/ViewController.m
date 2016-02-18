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
#define VERTICAL_BOTTOM_HEIGHT 80
#define ZERO 0

#define PLAYVIEW_WIDTH [UIScreen mainScreen].bounds.size.width
#define PLAYVIEW_HEIGHT self.playViewHeight

//#define PLAYVIEW_HEIGHT
@interface ViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *playVC;

@property (strong, nonatomic) IBOutlet UIView *firstView;
//view
@property (weak, nonatomic) IBOutlet UIView *topView;
//@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (weak, nonatomic) IBOutlet UIView *buttomView;

//topView 中的
@property (weak, nonatomic) IBOutlet UILabel *topPastTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *topProgressSlider;
@property (weak, nonatomic) IBOutlet UILabel *topRemainLable;
@property (weak, nonatomic) IBOutlet UIButton *complemetionBtn;
//bottomView 中的
@property (weak, nonatomic) IBOutlet UISlider *bottomSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

//用来保存竖屏是View的高度.
@property (nonatomic, assign) float playViewHeight;

//点击
@property (nonatomic, assign) BOOL isFirstTap;
//第一次播放
@property (nonatomic, assign) BOOL isFirstPlay;
//AVPlayer
@property (nonatomic, strong)AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) BOOL isPlayOrParse;
//保存该视频资源的总时长，快进或快退的时候要用
@property (nonatomic, assign) CGFloat totalMovieDuration;
//
@property (nonatomic, strong) id playbackObserver;
@end

@implementation ViewController

#pragma mark - 懒加载
- (AVPlayer *)player {
    if (!_player) {
        if (self.movieURL) {
            AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.movieURL];
            _player = [AVPlayer playerWithPlayerItem:item];
            //音量
            _player.volume = 0.5;
          
        }
    }
    return _player;
}
- (void)dealloc {
    NSLog(@"dealloc");
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //  添加进度观察
    [self addProgressObserver];
    [self addObserverToPlayerItem:self.player.currentItem];
    [self addNotificationCenters];
}
-(void)viewWillDisappear:(BOOL)animated{
    //当退出播放界面时,销毁对象
    //这个remove 是对应的addProgressObserver中的 addPeriodicTimeObserverForInterval 比较特殊.
    [self.player removeTimeObserver:self.playbackObserver];
    //移除playItem上的观察者(销毁对象)
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;
    //移除观察者
    [self removeNotificationCenters];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏但是不消失  点击无效
    self.navigationController.navigationBarHidden = YES;
    //初始化 没有播放过 就是NO
    self.isFirstPlay = NO;
    self.playViewHeight = self.playVC.bounds.size.height;
    //5540385469401b10912f7a24-6
   // self.movieURL = [[NSBundle mainBundle] URLForResource:@"mv" withExtension:@".mp4"];
    //self.view.backgroundColor = [UIColor whiteColor];
    self.firstView.backgroundColor = [UIColor whiteColor];
    
    //播放页面添加轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAllSubViews:)];
    [self.playVC addGestureRecognizer:tap];
    tap.delegate = self;
}
- (void)addNotificationCenters {
    //  注册观察者用来观察，是否播放完毕
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //  注册观察者来观察屏幕的旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}
-(void)removeNotificationCenters{
    //  移除观察者,使用观察者模式的时候,记得在不使用的时候,进行移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}
#pragma mark 是否横屏
//  观察UIApplicationDidChangeStatusBarOrientationNotification这个属性
- (void)statusBarOrientationChange:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if (self.isFirstPlay == NO) {//如果没有播放  播放的时候才允许横竖屏
//        return;
//    }
    if (orientation == UIInterfaceOrientationLandscapeRight) {//往右转 横屏
         //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        //   设置Layer的frame  全屏
        [self setPlayerLayerFrame2];
        //  设置第一次点击  控制栏会出现
        self.isFirstTap = YES;
        //返回按钮隐藏  横屏状态下不让返回
        self.complemetionBtn.hidden = YES;
    }
    if (orientation == UIInterfaceOrientationLandscapeLeft) {//横屏
       // self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [self setPlayerLayerFrame2];
        self.isFirstTap = YES;
         self.complemetionBtn.hidden = YES;
    }
    if (orientation == UIInterfaceOrientationPortrait) {//竖屏
        //设置Layer的frame 跟原先的一样
        [self setPlayerLayerFrame];
        //设置第一次点击  控制栏会出现
        self.isFirstTap = YES;
        //返回按钮显示
         self.complemetionBtn.hidden = NO;
    }
    
}
#pragma mark 动画出现或隐藏 top-right-bottom
-(void)dismissAllSubViews:(UITapGestureRecognizer *)tap{
    [self setTopRightBottmFrame];
}
//竖屏
-(void)setTopRightBottmFrame{
    __weak typeof (self) myself = self;
    if (!self.isFirstTap) {//第一次点击,那些内容还在
        [UIView animateWithDuration:.2f animations:^{
            myself.topView.hidden = YES;
            myself.buttomView.hidden = YES;
        }];
        self.isFirstTap = YES;
    } else {//非第一次点击,内容已经隐藏了
        [UIView animateWithDuration:.2f animations:^{
            myself.topView.hidden = NO;
            myself.buttomView.hidden = NO;
        }];
        self.isFirstTap = NO;
    }
}
#pragma mark - 更新播放进度
//      依靠AVPlayer的- (id)addPeriodicTimeObserverForInterval:(CMTime)interval queue:(dispatch_queue_t)queue usingBlock:(void (^)(CMTime time))block方法获得播放进度，这个方法会在设定的时间间隔内定时更新播放进度，通过time参数通知客户端。相信有了这些视频信息播放进度就不成问题了，事实上通过这些信息就算是平时看到的其他播放器的缓冲进度显示以及拖动播放的功能也可以顺利的实现。
-(void)addProgressObserver{
  
    __weak typeof(self) myself = self;
      AVPlayerItem *playerItem = myself.player.currentItem;
    //设置每秒执行一次
    self.playbackObserver =  [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //获取当前进度
        float current = CMTimeGetSeconds(time);
        //获取全部资源的大小
        float total = CMTimeGetSeconds([playerItem duration]);
        //计算出进度
        if (current) {
            [myself.topProgressSlider setValue:(current / total) animated:NO];
            NSDate *d = [NSDate dateWithTimeIntervalSince1970:current];
            //剩余
            float remainSeconds = total - current;
            NSDate *remainDate = [NSDate dateWithTimeIntervalSince1970:remainSeconds];
            //这句不加   就不会隐藏  因为每秒都会因为 label  而显示 view
            if (myself.isFirstTap) {
                //注意在block中 小心循环引用
                [myself setTopRightBottomViewShowToHidden];
            } else {
                [myself setTopRightBottomViewHiddenToShow];
            }
            myself.topPastTimeLabel.text = [myself getTimeByDate:d byProgress:current];
            myself.topRemainLable.text = [myself getTimeByDate:remainDate byProgress:remainSeconds];
        }
    }];
    
}
//从隐藏到显示
- (void)setTopRightBottomViewHiddenToShow {
    _topView.hidden = NO;
    //_rightView.hidden = NO;
    _buttomView.hidden = NO;
    _isFirstTap = NO;
}
//从显示到隐藏
- (void)setTopRightBottomViewShowToHidden {
    _topView.hidden = YES;
    //_rightView.hidden = YES;
    _buttomView.hidden = YES;
    _isFirstTap = YES;
}
- (NSString *)getTimeByDate:(NSDate *)date byProgress:(float)current {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (current / 3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"00:mm:ss"];
    }
    return [formatter stringFromDate:date];
}
//      这个方法，用来取得播放进度，播放进度就没有其他播放器那么简单了。在系统播放器中通常是使用通知来获得播放器的状态，媒体加载状态等，但是无论是AVPlayer还是AVPlayerItem（AVPlayer有一个属性currentItem是AVPlayerItem类型，表示当前播放的视频对象）都无法获得这些信息。当然AVPlayerItem是有通知的，但是对于获得播放状态和加载状态有用的通知只有一个：播放完成通知AVPlayerItemDidPlayToEndTimeNotification。在播放视频时，特别是播放网络视频往往需要知道视频加载情况、缓冲情况、播放情况，这些信息可以通过KVO监控AVPlayerItem的status、loadedTimeRanges属性来获得当AVPlayerItem的status属性为AVPlayerStatusReadyToPlay是说明正在播放，只有处于这个状态时才能获得视频时长等信息；当loadedTimeRanges的改变时（每缓冲一部分数据就会更新此属性）可以获得本次缓冲加载的视频范围（包含起始时间、本次加载时长），这样一来就可以实时获得缓冲情况。

- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem {
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem {
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}
//  观察者的方法, 会在加载好后触发, 可以在这个方法中, 保存总文件的大小, 用于后面的进度的实现
//只要暂停后  一开始  就会调用这个方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    //设置 slider 的值
    float current = (float)(self.totalMovieDuration * self.topProgressSlider.value);
    // 剩余
    float remainSeconds = self.totalMovieDuration - current;
    self.topProgressSlider.value = (current / (current + remainSeconds));
    
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"正在播放...,视频总长度: %.2f",CMTimeGetSeconds(playerItem.duration));
            CMTime totalTime = playerItem.duration;
            self.totalMovieDuration = (CGFloat)totalTime.value / totalTime.timescale;
        }
     }
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = playerItem.loadedTimeRanges;
        //  本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //  缓冲总长度
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        NSLog(@"共缓冲%.2f", totalBuffer);
    }
}

//设置 layer 的 frame
//竖屏
- (void)setPlayerLayerFrame {
    CGRect frame = self.view.bounds;
    frame.origin.x = ZERO;
    frame.origin.y = ZERO;
    frame.size.width = PLAYVIEW_WIDTH;
    frame.size.height = self.playViewHeight;
    // _playVC.frame = frame;
    _playerLayer.frame = frame;
}
//横屏
-(void)setPlayerLayerFrame2{
    CGRect frame = self.view.bounds;
    frame.origin.x = ZERO;
    frame.origin.y = ZERO;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = SCREEN_HEIGHT;
    //_playVC.frame = frame;
    _playerLayer.frame = frame;
   // NSLog(@"%f,%f",self.playVC.frame.size.width,self.playVC.frame.size.height);
}
#pragma mark Play
- (IBAction)playMovie:(id)sender {
    
    
    //创建显示层
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    //设置layer 第一次播放时设置就够了, 其余不用设置
    if (self.isFirstPlay == NO) {
        [self setPlayerLayerFrame];
        //这是视频的填充模式,默认为 AVLayerVideoGravityResizeAspect
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        //插到 view 层上面,没有用 addSubLayer
        [self.playVC.layer insertSublayer:_playerLayer atIndex:0];
      
    }
      [self setPlayOrParse];
   
    //播放过了这个属性就赋值为YES
    self.isFirstPlay = YES;
}

    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizerDelegate Method 方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //  不让子视图响应点击事件
    if( CGRectContainsPoint(self.topView.frame, [gestureRecognizer locationInView:self.view]) ||CGRectContainsPoint(self.buttomView.frame, [gestureRecognizer locationInView:self.view])) {
        return NO;
    } else{
        return YES;
    };
}
#pragma mark 播放结束后的代理回调
- (void)moviePlayDidEnd:(NSNotification *)notify
{
    //  LettopRightBottomViewShow
    [self setTopRightBottomViewHiddenToShow];
    [self setMovieParse];
    //  让这个视频循环播放...
    
}
#pragma mark 播放或暂停
- (void)setPlayOrParse {
    if(!self.isPlayOrParse) {//点击之后播放 isPlayOrParse = YES 表示正在播放
        [self setMoviePlay];
        self.isPlayOrParse = YES;
    } else {//点击之后暂停
        [self setMovieParse];
        self.isPlayOrParse = NO;
    }
}

- (void)setMovieParse {
    [self.player pause];
    //  因为用的是xib,不设置的话图片会重合
     _playButton.imageView.image = nil;
    [ _playButton setImage:[UIImage imageNamed:@"播放器_播放"] forState: UIControlStateNormal];
   
}

- (void)setMoviePlay {
    [self.player play];
    //  因为用的是xib,不设置的话图片会重合
     _playButton.imageView.image = nil;
    [ _playButton setImage:[UIImage imageNamed:@"播放器_暂停"] forState: UIControlStateNormal];
}
#pragma mark - 拖动进度条
- (IBAction)topSliderAction:(UISlider *)sender {
    [self setMovieParse];
    //  当前
    float current = (float)(self.totalMovieDuration * sender.value);
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:current];
    // 剩余
    float remainSeconds = self.totalMovieDuration - current;
    NSDate *remainDate = [NSDate dateWithTimeIntervalSince1970:remainSeconds];
    
    _topPastTimeLabel.text = [self getTimeByDate:currentDate byProgress:current];
    _topRemainLable.text = [self getTimeByDate:remainDate byProgress:remainSeconds];
      CMTime currentTime = CMTimeMake(current, 1);
    //  给avplayer设置进度
    [self.player seekToTime:currentTime completionHandler:^(BOOL finished) {
        if (self.topProgressSlider.state == 0) {
            [self setMoviePlay];
        }
    }];
    
}
- (IBAction)changeVolumeAction:(UISlider *)sender {
    self.player.volume = sender.value;
}
- (IBAction)complementAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
