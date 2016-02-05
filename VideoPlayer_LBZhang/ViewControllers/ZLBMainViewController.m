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
#import "ZLBClassContentVideo.h"
@interface ZLBMainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (nonatomic, strong) NSMutableArray *cateGory;

@end

@implementation ZLBMainViewController

- (NSMutableArray *)cateGory {
    if(_cateGory == nil) {
        _cateGory = [[NSMutableArray alloc] init];
    }
    return _cateGory;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    ZLBCategory *cate = self.cateGory[section];
    return cate.vos.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.cateGory.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZLBCell *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:@"Course" forIndexPath:indexPath];
    //ZLBCategory *cateGory = self.cateGory[indexPath.section - 1];
    NSArray *courses = [ZLBDataManager parseClassByType:indexPath.section withNSArray:self.cateGory];
    ZLBClassVos *course = courses[indexPath.item];
    cell2.classVos = course;
    return cell2;
    
    
}
#pragma mark - UICollectionViewDelegate
//
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            ZLBTopImagesCollectionReusableView *topView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TopView" forIndexPath:indexPath];
            topView.backgroundColor = [UIColor lightGrayColor];
            topView.category = self.cateGory;
            topView.frame = CGRectMake(0, 0, 320, 100);
            return topView;
        }
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        ZLBCategory *cateGory = self.cateGory[indexPath.section];
        UILabel *label = (UILabel *)[reusableview viewWithTag:1];
        if (label == nil) {
            label = [UILabel new];
            label.frame = CGRectMake(0, 0, 320, 50);
            label.tag = 1;
        }
        label.text = cateGory.name;
        [reusableview addSubview:label];
        
    }
    return reusableview;
    
}
//每个section的size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(320, 100);
    }else{
        return CGSizeMake(320, 50);
    }
}
//点击cell事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *courses = [ZLBDataManager parseClassByType:indexPath.section withNSArray:self.cateGory];
    ZLBClassVos *course = courses[indexPath.item];
    //http://so.open.163.com/movie/MBCP3VMPL/getMovies4Ipad.htm
    //MBCP3VMPL 是contentId
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
        [self presentViewController:vc animated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"");
    }];
//    NSURL *contentUrl = [NSURL URLWithString:contentUrlStr];
//    vc.movieURL = contentUrl;
//
}






@end
