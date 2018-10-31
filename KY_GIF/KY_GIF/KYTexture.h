//
//  KYTexture.h
//  KY_GIF
//
//  Created by wangkaiyu on 2018/10/29.
//  Copyright © 2018年 wangkaiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface KYTexture : NSObject
/*
 *  通过UIImage的方式获取纹理对象
 */
+ (GLuint)getTextureImage:(UIImage *)image;

+ (NSMutableDictionary *)durationForGifData:(NSData *)data;

+ (NSTimeInterval)gifImageDeleyTime:(CGImageSourceRef)imageSource index:(NSInteger)index;

@end
