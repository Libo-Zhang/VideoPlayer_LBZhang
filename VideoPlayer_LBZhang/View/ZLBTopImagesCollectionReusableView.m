//
//  ZLBTopImagesCollectionReusableView.m
//  VideoPlayer_LBZhang
//
//  Created by tarena on 16/1/3.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ZLBTopImagesCollectionReusableView.h"
#import "ZLBClassVos.h"
#import "UIImageView+WebCache.h"
#import "ZLBDataManager.h"
#import "ViewController.h"
#import "ZLBWebViewViewController.h"
#import "AFNetworking.h"
@interface ZLBTopImagesCollectionReusableView ()
@property (nonatomic, strong)UIScrollView *scroll;
@end
@implementation ZLBTopImagesCollectionReusableView
-(instancetype)init{
    if(self = [super init]){
       // self.scroll.hidden = NO;
    }
    return self;
}
-(void)setCategory:(NSMutableArray *)category{
    _category = category;
    self.scroll.hidden = NO;
}
- (UIScrollView *)scroll {
	if(_scroll == nil) {
		_scroll = [[UIScrollView alloc] init];
        [self addSubview:_scroll];
        ZLBCategory *cate = self.category[0];
        NSInteger count = cate.vos.count;
        _scroll.frame = CGRectMake(0, 0, self.superview.frame.size.width, topImageViewHeight);
        _scroll.contentSize = CGSizeMake(self.superview.frame.size.width * count, topImageViewHeight);
        _scroll.pagingEnabled = YES;
        _scroll.showsHorizontalScrollIndicator = NO;
        NSArray *tempList = [ZLBDataManager parseClassByType:0 withNSArray:self.category];
        for (int i = 0; i < tempList.count; i ++) {
            ZLBClassVos *vos = tempList[i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i *  self.superview.frame.size.width, 0, self.superview.frame.size.width, topImageViewHeight)];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [imageView addGestureRecognizer:tap];
            [_scroll addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:vos.picUrl] placeholderImage:[UIImage imageNamed:@""]];
            
        }
        
        
	}
	return _scroll;
}
-(void)tap:(UIGestureRecognizer*)gesure{
    int x = gesure.view.frame.origin.x / self.superview.frame.size.width;
    NSLog(@"hahahahah%d",x);
     NSArray *tempList = [ZLBDataManager parseClassByType:0 withNSArray:self.category];
     ZLBClassVos *vos = tempList[x];
    
    if (![vos.contentId isEqualToString:@""]) {//如果contentId 有值,里面有MP4的接口,就进入播放界面
        NSString *contentUrlStr = [NSString stringWithFormat:@"http://so.open.163.com/movie/%@/getMovies4Ipad.htm",vos.contentId];
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
            NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
            mudic[@"vc"] = vc;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"topImageViewTap" object:nil userInfo:mudic];
           // [ presentViewController:vc animated:YES completion:nil];
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"");
        }];
    }else{//如果没有MP4的接口 就用webView
        ZLBWebViewViewController *webVC = [ZLBWebViewViewController new];
        NSURL *url = [NSURL URLWithString:vos.contentUrl];
        webVC.url = url;
        NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
        mudic[@"webVC"] = webVC;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"topImageViewTap" object:nil userInfo:mudic];
      //  [self.navigationController pushViewController:webVC animated:YES];
    }

    
    
    
}

@end
