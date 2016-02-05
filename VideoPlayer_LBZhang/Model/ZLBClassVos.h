//
//  ZLBClassVos.h
//  VideoPlayer_LBZhang
//
//  Created by tarena on 16/1/3.
//  Copyright © 2016年 tarena. All rights reserved.
//
/**
 "vos": [
 {
 "id": 10138085,
 "gmtCreate": 1451544215398,
 "gmtModified": 1451780206977,
 "type": 1,
 "contentType": 0,
 "categoryid": null,
 "contentUrl": "",
 "contentId": "MBB7ONECF",
 "title": "谁是生存规则的制定者",
 "picUrl": "http://img1.ph.126.net/w3SlJX9YmQVYoXpP4m-Q8g==/6631199707097221357.jpg",
 "tag": null,
 "tagColor": null,
 "tagColorBg": null,
 "top": 69,
 "subtitle": "聚焦当代印度社会黑暗面",
 "description": "阿米尔·汗：真相访谈",
 "picUrl2": null,
 "picUrl3": null,
 "sharedesc": null,
 "shareimg": null
 }
 */


#import <Foundation/Foundation.h>

@interface ZLBClassVos : NSObject
@property (nonatomic) NSInteger id;
@property (nonatomic) NSInteger type;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *desc;

//contentID 里面放的是html,有MP4的地址 http://so.open.163.com/movie/MBCP3VMPL/getMovies4Ipad.htm
@property (nonatomic, strong) NSString *contentId;
//有些内容没有contentID,就有contentUrl
@property (nonatomic, strong) NSString *contentUrl;

@end
