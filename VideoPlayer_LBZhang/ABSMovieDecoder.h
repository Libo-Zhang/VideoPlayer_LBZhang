//
//  ABSMovieDecoder.h
//  VideoPlayer_LBZhang
//
//  Created by tarena on 16/1/2.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ABSMovieDecoder : NSObject
- (NSArray *)transformViedoPathToSampBufferRef:(NSURL *)videoUrl;
+ (CGImageRef)imageFromSampleBufferRef:(CMSampleBufferRef)sampleBufferRef;
@end
