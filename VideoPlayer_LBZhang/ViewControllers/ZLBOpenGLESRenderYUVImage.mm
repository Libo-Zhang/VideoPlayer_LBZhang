//
//  ZLBOpenGLESRenderYUVImage.m
//  VideoPlayer_LBZhang
//
//  Created by LB_Zhang on 16/2/16.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ZLBOpenGLESRenderYUVImage.h"
#import "OpenGLView20.h"
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSString *yuvFile = [[NSBundle mainBundle] pathForResource:@"jpgimage1_image_640_480" ofType:@"yuv"];
//    yuvData = [NSData dataWithContentsOfFile:yuvFile];
//    NSLog(@"the reader length is %lu", (unsigned long)yuvData.length);
    
    myview = [[OpenGLView20 alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.height - 40)];
    [self.view addSubview:myview];
}
int flush_encoder(AVFormatContext *fmt_ctx,unsigned int stream_index){
    int ret;
    int got_frame;
    AVPacket enc_pkt;
    if (!(fmt_ctx->streams[stream_index]->codec->codec->capabilities &
          CODEC_CAP_DELAY))
        return 0;
    while (1) {
        enc_pkt.data = NULL;
        enc_pkt.size = 0;
        av_init_packet(&enc_pkt);
        ret = avcodec_encode_video2 (fmt_ctx->streams[stream_index]->codec, &enc_pkt,
                                     NULL, &got_frame);
        av_frame_free(NULL);
        if (ret < 0)
            break;
        if (!got_frame){
            ret=0;
            break;
        }
        printf("Flush Encoder: Succeed to encode 1 frame!\tsize:%5d\n",enc_pkt.size);
        /* mux encoded frame */
        ret = av_write_frame(fmt_ctx, &enc_pkt);
        if (ret < 0)
            break;
    }
    return ret;  
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *yuvFile = [[NSBundle mainBundle] pathForResource:@"silent_qcif" ofType:@"yuv"];
    const char *filepath= [yuvFile UTF8String];
//    UInt8 * pFrameRGB = (UInt8*)[yuvData bytes];
//    [myview setVideoSize:640 height:480];
//    [myview displayYUV420pData:pFrameRGB width:640 height:480];
    
    
    AVFormatContext* pFormatCtx;
    AVOutputFormat* fmt;
    AVStream* video_st;
    AVCodecContext* pCodecCtx;
    AVCodec* pCodec;
    AVPacket pkt;
    uint8_t* picture_buf;
    AVFrame* pFrame;
    int picture_size;
    int y_size;
    int framecnt=0;
    FILE *in_file = fopen(filepath, "rb");   //Input raw YUV data
    //FILE *in_file = fopen("../ds_480x272.yuv", "rb");   //Input raw YUV data
    int in_w=480,in_h=272;                              //Input data's width and height
    int framenum=100;                                   //Frames to encode
    //const char* out_file = "src01.h264";              //Output Filepath
    //const char* out_file = "src01.ts";
    //const char* out_file = "src01.hevc";
    //const char* out_file = "ds.h264";
    
    av_register_all();
    //Method1.
    pFormatCtx = avformat_alloc_context();
    //Guess Format
   // fmt = av_guess_format(NULL, out_file, NULL);
    pFormatCtx->oformat = fmt;
    
    //Method 2.
    //avformat_alloc_output_context2(&pFormatCtx, NULL, NULL, out_file);
    //fmt = pFormatCtx->oformat;
    
    
    //Open output URL
//    if (avio_open(&pFormatCtx->pb,out_file, AVIO_FLAG_READ_WRITE) < 0){
//        printf("Failed to open output file! \n");
//       
//    }
    
    video_st = avformat_new_stream(pFormatCtx, 0);
    video_st->time_base.num = 1;
    video_st->time_base.den = 25;
    
    if (video_st==NULL){
        
    }
    //Param that must set
    pCodecCtx = video_st->codec;
    //pCodecCtx->codec_id =AV_CODEC_ID_HEVC;
    pCodecCtx->codec_id = fmt->video_codec;
    pCodecCtx->codec_type = AVMEDIA_TYPE_VIDEO;
    pCodecCtx->pix_fmt = PIX_FMT_YUV420P;
    pCodecCtx->width = in_w;
    pCodecCtx->height = in_h;
    pCodecCtx->time_base.num = 1;
    pCodecCtx->time_base.den = 25;
    pCodecCtx->bit_rate = 400000;
    pCodecCtx->gop_size=250;
    //H264
    //pCodecCtx->me_range = 16;
    //pCodecCtx->max_qdiff = 4;
    //pCodecCtx->qcompress = 0.6;
    pCodecCtx->qmin = 10;
    pCodecCtx->qmax = 51;
    
    //Optional Param
    pCodecCtx->max_b_frames=3;
    
    // Set Option
    AVDictionary *param = 0;
    //H.264
    if(pCodecCtx->codec_id == AV_CODEC_ID_H264) {
        av_dict_set(& param, "preset", "slow", 0);
        av_dict_set(& param, "tune", "zerolatency", 0);
        //av_dict_set(& param, "profile", "main", 0);
    }
    //H.265
    if(pCodecCtx->codec_id == AV_CODEC_ID_H265){
        av_dict_set(& param, "preset", "ultrafast", 0);
        av_dict_set(& param, "tune", "zero-latency", 0);
    }
    videoindex=-1;
    for(int i=0; i<pFormatCtx->nb_streams; i++)
        if(pFormatCtx->streams[i]->codec->codec_type==AVMEDIA_TYPE_VIDEO)
        {
            videoindex=i;
            break;
        }
    if(videoindex==-1)
    {
        printf("Didn't find a video stream.\n");
        exit(1);
    }
    pCodecCtx=pFormatCtx->streams[videoindex]->codec;
    pCodec=avcodec_find_decoder(pCodecCtx->codec_id);
    if(pCodec==NULL)
    {
        printf("Codec not found.\n");
        exit(1);
    }
    //Show some Information
    //av_dump_format(pFormatCtx, 0, out_file, 1);
    pCodecCtx=pFormatCtx->streams[videoindex]->codec;
    pCodec = avcodec_find_encoder(pCodecCtx->codec_id);
    if (!pCodec){
        printf("Can not find encoder! \n");
       
    }
    if (avcodec_open2(pCodecCtx, pCodec,NULL) < 0){
        printf("Failed to open encoder! \n");
        
    }
    
    pFrame = av_frame_alloc();
    picture_size = avpicture_get_size(pCodecCtx->pix_fmt, pCodecCtx->width, pCodecCtx->height);
    picture_buf = (uint8_t *)av_malloc(picture_size);
    avpicture_fill((AVPicture *)pFrame, picture_buf, pCodecCtx->pix_fmt, pCodecCtx->width, pCodecCtx->height);
    
    //Write File Header
    //avformat_write_header(pFormatCtx,NULL);
    
    av_new_packet(&pkt,picture_size);
    
    y_size = pCodecCtx->width * pCodecCtx->height;
    
    for (int i=0; i<framenum; i++){
        //Read raw YUV data
        if (fread(picture_buf, 1, y_size*3/2, in_file) <= 0){
            printf("Failed to read raw data! \n");
           
        }else if(feof(in_file)){
            break;
        }
        pFrame->data[0] = picture_buf;              // Y
        pFrame->data[1] = picture_buf+ y_size;      // U
        pFrame->data[2] = picture_buf+ y_size*5/4;  // V
        //PTS
        pFrame->pts=i;
        int got_picture=0;
        
        //Encode
        int ret = avcodec_decode_video2(pCodecCtx, pFrame, &got_picture, &pkt);
        if(ret < 0){
            printf("Failed to encode! \n");
            
        }
        //Encode
        char *buf = (char *)malloc(pFrame->width * pFrame->height * 3 / 2);
        AVPicture *pict;
        int w, h;
        char *y, *u, *v;
        pict = (AVPicture *)pFrame;//这里的frame就是解码出来的AVFrame
        w = pFrame->width;
        h = pFrame->height;
        y = buf;
        u = y + w * h;
        v = u + w * h / 4;
        
        for (int i=0; i<h; i++)
            memcpy(y + w * i, pict->data[0] + pict->linesize[0] * i, w);
        for (int i=0; i<h/2; i++)
            memcpy(u + w / 2 * i, pict->data[1] + pict->linesize[1] * i, w / 2);
        for (int i=0; i<h/2; i++)
            memcpy(v + w / 2 * i, pict->data[2] + pict->linesize[2] * i, w / 2);
        
        [myview setVideoSize:pFrame->width height:pFrame->height];
        [myview displayYUV420pData:buf width:pFrame->width height:pFrame->height];
        free(buf);
    }
    //Flush Encoder
//    int ret = flush_encoder(pFormatCtx,0);
//    if (ret < 0) {
//        printf("Flushing encoder failed\n");
//       
//    }
    
    //Write file trailer
   // av_write_trailer(pFormatCtx);
    
    //Clean
    if (video_st){
        avcodec_close(video_st->codec);
        av_free(pFrame);
        av_free(picture_buf);
    }
    avio_close(pFormatCtx->pb);
    avformat_free_context(pFormatCtx);
    
    fclose(in_file);
    
    
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
