//
//  KYFbo.h
//  KY_GIF
//
//  Created by wangkaiyu on 2018/10/30.
//  Copyright © 2018年 wangkaiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>
#import <AVFoundation/AVFoundation.h>

@interface KYFbo : NSObject

- (instancetype)initDefault_Width:(int)width height:(int)height;

- (void)bind;
-(void)setupFrameBuffer;
- (GLuint)getTextureResult;

- (void)unbind;
@end
