//
//  ZLBOpenGLESRenderYUVImage.m
//  VideoPlayer_LBZhang
//
//  Created by LB_Zhang on 16/2/16.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ZLBOpenGLESRenderYUVImage.h"
#include <stdio.h>
#include <string.h>
#import "OpenGLView20.h"
#import <OpenGLES/gltypes.h>
#import <OpenGLES/EAGLDrawable.h>
extern "C" {
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>
}



#define MAX_PLANES  3
typedef unsigned char   BYTE;
typedef struct _DVDVideoPicture
{
    BYTE* data[4];      // [4] = alpha channel, currently not used
    int iLineSize[4];   // [4] = alpha channel, currently not used
}DVDVideoPicture;

//YV12Image这个结构体用于保存抽取的Y U V数据
typedef struct YV12Image
{
    BYTE     *planeData[MAX_PLANES];
    int      planeSize[MAX_PLANES];
    unsigned stride[MAX_PLANES];
    unsigned width;
    unsigned height;
    unsigned flags;
    
    unsigned cshift_x; /* this is the chroma shift used */
    unsigned cshift_y;
}YV12Image;

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

-(void)viewDidLoad{

    AVFormatContext* oc;
    AVOutputFormat* fmt;
    AVStream* video_st;
    double video_pts;
    uint8_t* video_outbuf;
    uint8_t* picture_buf;
    AVFrame* picture;
    //  AVFrame* pictureRGB;
    int size;
    int ret;
    int video_outbuf_size;
    
    FILE *fin = fopen("akiyo_qcif.yuv", "rb"); //视频源文件
    
    const char* filename = "test.mpg";
    //  const char* filename;
    //  filename = argv[1];
    
    av_register_all();
    
    //  avcodec_init(); // 初始化codec库
    //  avcodec_register_all(); // 注册编码器
    
    fmt = av_guess_format(NULL, filename, NULL);
    oc = avformat_alloc_context();
    oc->oformat = fmt;
    snprintf(oc->filename, sizeof(oc->filename), "%s", filename);
    
    video_st = NULL;
    if (fmt->video_codec != CODEC_ID_NONE)
    {
        AVCodecContext* c;
        video_st = avformat_new_stream(oc, 0);
        c = video_st->codec;
        c->codec_id = fmt->video_codec;
        c->codec_type = AVMEDIA_TYPE_VIDEO;
        c->bit_rate = 400000;
        c->width = 176;
        c->height = 144;
        c->time_base.num = 1;
        c->time_base.den = 25;
        c->gop_size = 12;
        c->pix_fmt = PIX_FMT_YUV420P;
        if (c->codec_id == CODEC_ID_MPEG2VIDEO)
        {
            c->max_b_frames = 2;
        }
        if (c->codec_id == CODEC_ID_MPEG1VIDEO)
        {
            c->mb_decision = 2;
        }
        if (!strcmp(oc->oformat->name, "mp4") || !strcmp(oc->oformat->name, "mov") || !strcmp(oc->oformat->name, "3gp"))
        {
            c->flags |= CODEC_FLAG_GLOBAL_HEADER;
        }
    }
    
//    if (av_set_parameters(oc, NULL)<0)
//    {
//        return;
//    }
    
    av_dump_format(oc, 0, filename, 1);
    if (video_st)
    {
        AVCodecContext* c;
        AVCodec* codec;
        c = video_st->codec;
        codec = avcodec_find_encoder(c->codec_id);
        if (!codec)
        {
            return;
        }
        if (avcodec_open2(c, codec,NULL) < 0)
        {
            return;
        }
        if (!(oc->oformat->flags & AVFMT_RAWPICTURE))
        {
            video_outbuf_size = 200000;
            video_outbuf = (uint8_t*)av_malloc(video_outbuf_size);
        }
        picture = avcodec_alloc_frame();
        size = avpicture_get_size(c->pix_fmt, c->width, c->height);
        picture_buf = (uint8_t*)av_malloc(size);
        if (!picture_buf)
        {
            av_free(picture);
        }
        avpicture_fill((AVPicture*)picture, picture_buf, c->pix_fmt, c->width, c->height);
    }
    
    if (!(fmt->flags & AVFMT_NOFILE))
    {
//        if (url_fopen(&oc->pb, filename, URL_WRONLY) < 0)
//        {
//            return;
//        }
    }
//    av_write_header(oc);
    
    for (int i=0; i<300; i++)
    {
        if (video_st)
        {
            video_pts = (double)(video_st->pts.val * video_st->time_base.num / video_st->time_base.den);
        }
        else
        {
            video_pts = 0.0;
        }
        if (!video_st/* || video_pts >= 5.0*/)
        {
            break;
        }
        AVCodecContext* c;
        c = video_st->codec;
        size = c->width * c->height;
        
        if (fread(picture_buf, 1, size*3/2, fin) < 0)
        {
            break;
        }
        
        picture->data[0] = picture_buf;  // 亮度
        picture->data[1] = picture_buf+ size;  // 色度
        picture->data[2] = picture_buf+ size*5/4; // 色度
        
        // 如果是rgb序列，可能需要如下代码
        //      SwsContext* img_convert_ctx;
        //      img_convert_ctx = sws_getContext(c->width, c->height, PIX_FMT_RGB24, c->width, c->height, c->pix_fmt, SWS_BICUBIC, NULL, NULL, NULL);
        //      sws_scale(img_convert_ctx, pictureRGB->data, pictureRGB->linesize, 0, c->height, picture->data, picture->linesize);
        
        if (oc->oformat->flags & AVFMT_RAWPICTURE)
        {
            AVPacket pkt;
            av_init_packet(&pkt);
            //pkt.flags |= PKT_FLAG_KEY;
            pkt.stream_index = video_st->index;
            pkt.data = (uint8_t*)picture;
            pkt.size = sizeof(AVPicture);
            ret = av_write_frame(oc, &pkt);
        }
        else
        {
            int out_size = avcodec_encode_video(c, video_outbuf, video_outbuf_size, picture);
            if (out_size > 0)
            {
                AVPacket pkt;
                av_init_packet(&pkt);
                pkt.pts = av_rescale_q(c->coded_frame->pts, c->time_base, video_st->time_base);
                if (c->coded_frame->key_frame)
                {
                    //pkt.flags |= PKT_FLAG_KEY;
                }
                pkt.stream_index = video_st->index;
                pkt.data = video_outbuf;
                pkt.size = out_size;
                ret = av_write_frame(oc, &pkt);
            }
        }
    }
    
    if (video_st)
    {
        avcodec_close(video_st->codec);
        //      av_free(picture->data[0]);
        av_free(picture);
        av_free(video_outbuf);
        //      av_free(picture_buf);
    }
    av_write_trailer(oc);
    for (int i=0; i<oc->nb_streams; i++)
    {
        av_freep(&oc->streams[i]->codec);
        av_freep(&oc->streams[i]);
    }
    if (!(fmt->flags & AVFMT_NOFILE))
    {  
       // url_fclose(oc->pb);
    }  
    av_free(oc);  
}
    
}



@end
