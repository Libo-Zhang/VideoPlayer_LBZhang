//
//  ZLBOpenGLESRenderYUVImage.m
//  VideoPlayer_LBZhang
//
//  Created by LB_Zhang on 16/2/16.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ZLBOpenGLESRenderYUVImage.h"
#include <stdio.h>

#import "OpenGLView20.h"
#import <OpenGLES/gltypes.h>
#import <OpenGLES/EAGLDrawable.h>
extern "C" {
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>
}

@interface ZLBOpenGLESRenderYUVImage ()
@end

@implementation ZLBOpenGLESRenderYUVImage
{
//    AVFormatContext	*pFormatCtx;
    int				videoindex;
//    AVCodecContext	*pCodecCtx;
//    AVCodec			*pCodec;
//    NSData *yuvData;
    OpenGLView20 * myview;
    EAGLContext * _glContext;
    GLuint _textureY;
    GLuint _textureU;
    GLuint _textureV;
    GLsizei _videoW;
    GLsizei _videoH;
}

//Shader.vsh
//attribute vec4 position; // 1
////uniform float translate;
//attribute vec2 TexCoordIn; // New
//varying vec2 TexCoordOut; // New
//
//void main(void)
//{
//    gl_Position = position; // 6
//    TexCoordOut = TexCoordIn;
//}
//
////Shader.fsh
//varying lowp vec2 TexCoordOut;

//uniform sampler2D SamplerY;
//uniform sampler2D SamplerU;
//uniform sampler2D SamplerV;

- (void)viewDidAppear:(BOOL)animated
{
//    [super viewDidAppear:animated];
//    NSString *yuvFile = [[NSBundle mainBundle] pathForResource:@"silent_qcif" ofType:@"yuv"];
//    const char *filepath= [yuvFile UTF8String];

   
    
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
