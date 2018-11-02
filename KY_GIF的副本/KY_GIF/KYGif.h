//
//  KYGif.h
//  KY_GIF
//
//  Created by wangkaiyu on 2018/11/2.
//  Copyright © 2018年 wangkaiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KYGif : NSObject

- (instancetype)initWithGifPath:(NSString *)path;

- (NSMutableArray *)getTimesArray;

- (NSMutableArray *)getTextureArray;

- (void)durationForGifData;


@end
