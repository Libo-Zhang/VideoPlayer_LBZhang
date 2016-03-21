//
//  LocalPlayVC.m
//  VideoPlayer_LBZhang
//
//  Created by LB_Zhang on 16/3/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "LocalPlayVC.h"
#import "ViewController.h"
@interface LocalPlayVC ()
@property (weak, nonatomic) IBOutlet UITextField *textfield;

@end

@implementation LocalPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textfield.text = @"http://localhost/1.mp4";
}
- (IBAction)play:(UIButton *)sender {
    ViewController *v = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"playVC" ];
    v.movieURL = [NSURL URLWithString:self.textfield.text];
    [self.navigationController pushViewController:v animated:YES];
    
    
    
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
