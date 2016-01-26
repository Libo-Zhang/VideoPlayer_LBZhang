//
//  ZLBCell.m
//  VideoPlayer_LBZhang
//
//  Created by tarena on 16/1/3.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ZLBCell.h"
#import "UIImageView+WebCache.h"
@interface ZLBCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@end
@implementation ZLBCell

- (void)awakeFromNib {
   
}
-(void)setClassVos:(ZLBClassVos *)classVos{
    _classVos = classVos;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:classVos.picUrl] placeholderImage:[UIImage imageNamed:@""]] ;
    self.title.text = classVos.title;
    self.subTitle.text = classVos.subtitle;
    self.desc.text = classVos.desc;
}

@end
