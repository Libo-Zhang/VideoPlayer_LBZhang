//
//  OtherViewController.m
//  VideoPlayer_LBZhang
//
//  Created by LB_Zhang on 16/2/22.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "OtherViewController.h"
#import "ZLBFFmpegDecodeToYUV.h"
#import "ZLBOpenGLESRenderYUVImage.h"
@interface OtherViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textField.text = @"http://localhost/";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)play:(id)sender {
    
//    if([self.textField.text hasSuffix:@"yuv"]){
//        ZLBOpenGLESRenderYUVImage *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@""];
//        
//    }else{
    
    
    ZLBFFmpegDecodeToYUV *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"play"];
    vc.url = self.textField.text;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
//    }
    //[self.navigationController pushViewController:vc animated:YES];
    
}
//取消textField的第一响应
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
