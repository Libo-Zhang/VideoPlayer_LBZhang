//
//  ZLBYUV.h
//  VideoPlayer_LBZhang
//
//  Created by tarena on 16/1/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
static OSType KVideoPixelFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
@interface ZLBYUV : NSObject
+ (CVPixelBufferRef)yuvPixelBufferWithData:(NSData *)dataFrame presentationTime:(CMTime)presentationTime width:(size_t)w heigth:(size_t)h;
+ (CVPixelBufferRef) copyDataFromBuffer:(const unsigned char*)buffer toYUVPixelBufferWithWidth:(size_t)w Height:(size_t)h;
@end
