//
//  ABSMovieDecoder.m
//  VideoPlayer_LBZhang
//
//  Created by tarena on 16/1/2.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ABSMovieDecoder.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreFoundation/CoreFoundation.h>

@interface ABSMovieDecoder ()
@property (nonatomic, strong)NSString *videoImagesPath;
@property (nonatomic, strong)NSFileHandle *fileHandle;
@end
@implementation ABSMovieDecoder
- (NSArray *)transformViedoPathToSampBufferRef:(NSURL *)videoUrl{
    //fixMemory
    NSString *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    self.videoImagesPath = [cache stringByAppendingPathComponent:@"final"];
        //第三个 nil 创建文件是默认权限(-rw-r--r--)
    [[NSFileManager defaultManager]createFileAtPath:self.videoImagesPath contents:nil attributes:nil];
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.videoImagesPath];
    
    
    
    // 获取媒体文件路径的 URL，必须用 fileURLWithPath: 来获取文件 URL
    
   // NSURL *fileUrl = [NSURL fileURLWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"5540385469401b10912f7a24-6.mp4"]];
    //NSURL *fileUrl = [NSURL fileURLWithPath:videoPath];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    NSError *error = nil;
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    //获取视频的轨迹,其实就是视频来源
    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack =[videoTracks objectAtIndex:0];
    
    //为阅读器进行配置 如果配置读取的像素,视频压缩等等,得到我们的输出端口AVAssetReaderTrackOutput轨迹,也就是我们的数据来源
    int m_pixeFormatType;
    //播放时
    m_pixeFormatType = kCVPixelFormatType_32BGRA;
    //其他用途 如视频压缩
    //    m_pixeFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange;
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:@(m_pixeFormatType) forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    AVAssetReaderTrackOutput *videoReaderOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:options];
    //为阅读器添加输出端口,并开启阅读器
    [reader addOutput:videoReaderOutput];
    [reader startReading];
    NSMutableArray *images = [NSMutableArray array];
    // 要确保nominalFrameRate>0，之前出现过android拍的0帧视频
    while ([reader status] == AVAssetReaderStatusReading && videoTrack.nominalFrameRate > 0) {
        // 读取 video sample
        CMSampleBufferRef videoBuffer = [videoReaderOutput copyNextSampleBuffer];
       // [self.delegate mMoveDecoder:self onNewVideoFrameReady:videoBuffer];
        
        // 根据需要休眠一段时间；比如上层播放视频时每帧之间是有间隔的,这里的 sampleInternal 我设置为0.001秒
        [NSThread sleepForTimeInterval:0.002];
        CGImageRef cgimage = [ABSMovieDecoder  imageFromSampleBufferRef:videoBuffer];
        if (!(__bridge id)(cgimage)) { continue; }
       // [self.fileHandle writeData:cgimage];
        [images addObject:((__bridge id)(cgimage))];
        CGImageRelease(cgimage);
    }
    return [images copy];
    
    
}
// AVFoundation 捕捉视频帧，很多时候都需要把某一帧转换成 image
+ (CGImageRef)imageFromSampleBufferRef:(CMSampleBufferRef)sampleBufferRef
{
    // 为媒体数据设置一个CMSampleBufferRef
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBufferRef);
    // 锁定 pixel buffer 的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // 得到 pixel buffer 的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // 得到 pixel buffer 的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到 pixel buffer 的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // 创建一个依赖于设备的 RGB 颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphic context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    //根据这个位图 context 中的像素创建一个 Quartz image 对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁 pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    // 释放 context 和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // 用 Quzetz image 创建一个 UIImage 对象
    // UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // 释放 Quartz image 对象
    //    CGImageRelease(quartzImage);
    return quartzImage;
}

@end
