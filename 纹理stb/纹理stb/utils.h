//
//  utils.h
//  纹理stb
//
//  Created by wangkaiyu on 2019/3/4.
//  Copyright © 2019 wangkaiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>

NS_ASSUME_NONNULL_BEGIN

@interface utils : NSObject

+(GLuint)loadShader:(GLenum)type withstring:(NSString*)shaderString;
+(GLuint)loadShader:(GLenum)type withpath:(NSString *)shaderpath;
@end

NS_ASSUME_NONNULL_END
