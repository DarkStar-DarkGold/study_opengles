//
//  KYGif.m
//  KY_GIF
//
//  Created by wangkaiyu on 2018/11/2.
//  Copyright © 2018年 wangkaiyu. All rights reserved.
//

#import "KYGif.h"
#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>


@interface KYGif(){
    NSString * _path; // 类。 下划线
    NSMutableArray *_textures;
    NSMutableArray *_times;
    
}

@end

// 驼峰处理法
@implementation KYGif

- (instancetype)initWithGifPath:(NSString *)path{
    self = [super init];
    if (self){
        _path = path;
        [self durationForGifData];
    }
    return self;
}

- (void)durationForGifData{
    //    [NSdata dataWithContentsOfFile:path options:nil error:nil]
    //将GIF图片转换成对应的图片源
    NSData *data = [NSData dataWithContentsOfFile:_path options:nil error:nil];
        
    CGImageSourceRef gifSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    //获取其中图片源个数，即由多少帧图片组成
    size_t frameCout = CGImageSourceGetCount(gifSource);
    //定义数组存储拆分出来的图片
    NSMutableArray* frames = [[NSMutableArray alloc] init];
    NSTimeInterval totalDuration = 0;
    NSMutableArray* times = [[NSMutableArray alloc] init];
    
    for (size_t i=0; i<frameCout; i++) {
        //从GIF图片中取出源图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        //将图片源转换成UIimageView能使用的图片源
        UIImage* imageName = [UIImage imageWithCGImage:imageRef];
        GLuint texID = [self getTextureImage:imageName];

        //将图片加入数组中
        [frames addObject:[NSNumber numberWithInt:texID]];
        NSTimeInterval duration = [self gifImageDeleyTime:gifSource index:i];
        NSNumber *otime = [NSNumber numberWithFloat:duration];
        
        [times addObject:otime];
        
        totalDuration += duration;
        
        CGImageRelease(imageRef);
    }
    _textures = frames;
    _times = times;
    
}
    
- (NSTimeInterval)gifImageDeleyTime:(CGImageSourceRef)imageSource index:(NSInteger)index {
    NSTimeInterval duration = 0;
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, NULL);
    if (imageProperties) {
        CFDictionaryRef gifProperties;
        BOOL result = CFDictionaryGetValueIfPresent(imageProperties, kCGImagePropertyGIFDictionary, (const void **)&gifProperties);
        if (result) {
            const void *durationValue;
            if (CFDictionaryGetValueIfPresent(gifProperties, kCGImagePropertyGIFUnclampedDelayTime, &durationValue)) {
                duration = [(__bridge NSNumber *)durationValue doubleValue];
                if (duration < 0) {
                    if (CFDictionaryGetValueIfPresent(gifProperties, kCGImagePropertyGIFDelayTime, &durationValue)) {
                        duration = [(__bridge NSNumber *)durationValue doubleValue];
                    }
                }
            }
        }
    }
    
    return duration;
}


- (GLuint)getTextureImage:(UIImage *)image {
    
    // 获取UIImage并转换成CGImage
    CGImageRef spriteImage = [image CGImage];
    
    if(!spriteImage) {
        return -1;
    }
    
    CFDataRef rawdata = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    
    float *pixels = (float *)CFDataGetBytePtr(rawdata);
    
    int width = image.size.width;
    int height = image.size.height;
    
    GLuint texName;
    glGenTextures(1, &texName); //创建
    glBindTexture(GL_TEXTURE_2D, texName); // 绑定
    
    // 加载图像并上传纹理数据
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
    
    // 加载图像数据, 并上传纹理
    //    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
    
    //设置纹理过滤模式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    //设置纹理循环模式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    // 解绑纹理对象(在本文这里解不解绑都一样，因为后面还是要绑定)
    glBindTexture(GL_TEXTURE_2D, 0);
    // 释放分配的内存空间
    free(pixels);
    pixels = nil;
    
    return texName;
}

- (NSMutableArray *)getTextureArray   // get就是返回对象 所以不要进行一系列操作。最后赋值给去哪句变量即可
{
    return _textures;
}

- (NSMutableArray *)getTimesArray
{
    return _times;
}





@end
