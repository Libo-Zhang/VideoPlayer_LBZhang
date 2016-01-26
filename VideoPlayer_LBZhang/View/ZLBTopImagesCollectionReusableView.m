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
        _scroll.frame = CGRectMake(0, 0, self.superview.frame.size.width, 100);
        _scroll.contentSize = CGSizeMake(self.superview.frame.size.width * count, 100);
        _scroll.pagingEnabled = YES;
        _scroll.showsHorizontalScrollIndicator = NO;
        NSArray *tempList = [ZLBDataManager parseClassByType:0 withNSArray:self.category];
        for (int i = 0; i < tempList.count; i ++) {
            ZLBClassVos *vos = tempList[i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i *  self.superview.frame.size.width, 0, self.superview.frame.size.width, 100)];
            [_scroll addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:vos.picUrl] placeholderImage:[UIImage imageNamed:@""]];
            
        }
        
        
	}
	return _scroll;
}

@end
