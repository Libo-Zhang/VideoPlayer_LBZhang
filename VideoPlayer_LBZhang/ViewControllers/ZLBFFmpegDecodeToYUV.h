//
//  ZLBFFmpegDecodeToYUV.h
//  VideoPlayer_LBZhang
//
//  Created by LB_Zhang on 16/2/16.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
extern "C" {
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
    
#include <libswscale/swscale.h>
}
@interface ZLBFFmpegDecodeToYUV : UIViewController

@end
