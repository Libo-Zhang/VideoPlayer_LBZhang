//
//  ZLBMainViewController.m
//  VideoPlayer_LBZhang
//
//  Created by tarena on 16/1/3.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ZLBMainViewController.h"
#import "ZLBTopImagesCollectionReusableView.h"
#import "MJRefresh.h"
#import "MJChiBaoZiHeader.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "ZLBDataManager.h"
#import "ZLBCell.h"
#import "ZLBCategory.h"
#import "ViewController.h"
#import "AFNetworking.h"
#import "ZLBContent.h"
#import "ZLBWebViewViewController.h"
#import "judgeDevices.h"
@interface ZLBMainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (nonatomic, strong) NSMutableArray *cateGory;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;


@end

@implementation ZLBMainViewController

- (NSMutableArray *)cateGory {
    if(_cateGory == nil) {
        _cateGory = [[NSMutableArray alloc] init];
    }
    return _cateGory;
}
//添加通知
-(void)addObservers{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observer:) name:@"topImageViewTap" object:nil];
}
-(void)observer:(NSNotification*) notification{
    NSDictionary *dic = notification.userInfo;
    if ([dic objectForKey:@"vc"]) {
        id vc = dic[@"vc"];
        [self presentViewController:vc animated:YES completion:nil];
    }
    if ([dic objectForKey:@"webVC"]) {
        id vc = dic[@"webVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//移除通知
-(void)removeObservers{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(void)dealloc{
    [self removeObservers];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //开启侧滑
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    //根据不同的设备  设置不同的layout 适配
    [self settingLayoutByDevices];
    //添加观察者.
    [self addObservers];

    self.CollectionView.dataSource = self;
    self.CollectionView.delegate = self;
    [self.CollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.CollectionView registerClass:[ZLBTopImagesCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TopView"];
    [self.CollectionView registerNib:[UINib nibWithNibName:@"ZLBCell" bundle:nil] forCellWithReuseIdentifier:@"Course"];
    //刷新
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.CollectionView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    [self.CollectionView.mj_header beginRefreshing];

}
-(void)loadNewData{
    NSString *strUrl = @"http://c.open.163.com/mobile/recommend/v1.do?mt=iphone";
   // NSString *strUrl2 = @"http://www.raywenderlich.com/demos/weather_sample/weather.php?format=json";
    //AFHTTPSessionManager *manager2 = [[AFHTTPSessionManager alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
   [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
       NSLog(@"成功");
       self.cateGory = [[ZLBDataManager parseNSArray:responseObject] mutableCopy];
       [self.CollectionView.mj_header endRefreshing];
       [self.CollectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请求失败";
        hud.margin = 10;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];
        [self.CollectionView.mj_header endRefreshing];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - collectionViewDataSource
//有几个section
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    ZLBCategory *cate = self.cateGory[section];
    return cate.vos.count;
}
//每个section有几个Cell
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.cateGory.count;
}
//每个Cell的具体情况
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZLBCell *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:@"Course" forIndexPath:indexPath];
    NSArray *courses = [ZLBDataManager parseClassByType:indexPath.section withNSArray:self.cateGory];
    ZLBClassVos *course = courses[indexPath.item];
    cell2.classVos = course;
    return cell2;
}
#pragma mark - UICollectionViewDelegate
//UICollectionReusableView 每个分区开头的View
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            ZLBTopImagesCollectionReusableView *topView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TopView" forIndexPath:indexPath];
            topView.backgroundColor = [UIColor lightGrayColor];
            topView.category = self.cateGory;
            //topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, topImageViewHeight2);
            return topView;
        }
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        ZLBCategory *cateGory = self.cateGory[indexPath.section];
        UILabel *label = (UILabel *)[reusableview viewWithTag:1];
        if (label == nil) {
            label = [UILabel new];
            label.frame = CGRectMake(20, -5, SCREEN_WIDTH, 50);
            label.tag = 1;
        }
        label.text = cateGory.name;
        [reusableview addSubview:label];
        
       // UIImage *image = [self createRoundImageWithImageName];
        UIImage *image = [UIImage imageNamed:@"line"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
       
        //imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.frame = CGRectMake(20, 30, SCREEN_WIDTH - 40, 5);
        [reusableview addSubview:imageView];
    }
    return reusableview;
    
}
//每个UICollectionReusableView的size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, topImageViewHeight2);
    }else{
        return CGSizeMake(SCREEN_WIDTH, 50);
    }
}
#pragma mark 点击Cell
//点击cell事件，跳转到播放页面
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *courses = [ZLBDataManager parseClassByType:indexPath.section withNSArray:self.cateGory];
    ZLBClassVos *course = courses[indexPath.item];
    //http://so.open.163.com/movie/MBCP3VMPL/getMovies4Ipad.htm
    //MBCP3VMPL 是contentId
    if (![course.contentId isEqualToString:@""]) {//如果contentId 有值,里面有MP4的接口,就进入播放界面
         NSString *contentUrlStr = [NSString stringWithFormat:@"http://so.open.163.com/movie/%@/getMovies4Ipad.htm",course.contentId];
        NSLog(@"ssss%@",contentUrlStr);
        ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"playVC"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        //接着获得content的json数据
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
        [manager GET:contentUrlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            ZLBContent *content = [ZLBDataManager parseClassContent:(NSDictionary *)responseObject];
            NSArray *videoList = [ZLBDataManager parseVideoFromContent:content];
            ZLBClassContentVideo *video = videoList.firstObject;
            NSURL *url = [NSURL URLWithString:video.repovideourlmp4];
            vc.movieURL = url;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
          
           // self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            [self.navigationController pushViewController:vc animated:YES];
           // [self presentViewController:vc animated:YES completion:nil];
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"");
        }];
    }else{//如果没有MP4的接口 就用webView
        ZLBWebViewViewController *webVC = [ZLBWebViewViewController new];
        NSURL *url = [NSURL URLWithString:course.contentUrl];
        webVC.url = url;
        [webVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}
//画线 本来是想画条线上去的,后来显示不了(不知道为什么,就没用了 ,直接用了图片)
-(UIImage *)createRoundImageWithImageName{
    //获取上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(200, 200), NO, 0);
    //贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 20)];
    [path addLineToPoint:CGPointMake(200, 20)];
    //3. 设置颜色
    [[UIColor redColor] setStroke];
    [[UIColor greenColor] setFill];
    //4. 根据设置绘制图形
    [path stroke];
    [path fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
    
}
//设置Layout 根据设备的不同 ,这里简化了 直接用了百分比
-(void)settingLayoutByDevices{
   // NSString *str = [judgeDevices getCurrentDeviceModel];
//    if([str isEqualToString:@"iPhone 6 (A1549/A1586)"]){
//        self.flowLayout.itemSize = CGSizeMake(LAYOUT_WIDTH, 200);
//        self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
//        self.flowLayout.minimumInteritemSpacing = 10;
//        NSLog(@"%f,%f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
//    }
    //设置Layout的size
    self.flowLayout.itemSize = CGSizeMake(LAYOUT_WIDTH, 170);
    //上下左右距离
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    //最小间隔
    self.flowLayout.minimumInteritemSpacing = 10;
    //NSLog(@"%f,%f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
}





@end
