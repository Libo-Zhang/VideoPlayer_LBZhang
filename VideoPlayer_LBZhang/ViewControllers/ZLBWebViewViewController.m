//
//  ZLBWebViewViewController.m
//  VideoPlayer_LBZhang
//
//  Created by LB_Zhang on 16/2/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ZLBWebViewViewController.h"
#import "MBProgressHUD.h"
@import WebKit;
@interface ZLBWebViewViewController ()
//WKWebView  iOS8之后使用,
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation ZLBWebViewViewController

//WKWebView的懒加载
-(WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
        _webView.allowsBackForwardNavigationGestures = YES;
     
       
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.hidden = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = item;
    // Do any additional setup after loading the view.
}
-(void)backAction{
    
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
