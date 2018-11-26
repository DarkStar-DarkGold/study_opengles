//
//  utils.h
//  2
//
//  Created by wangkaiyu on 2018/11/25.
//  Copyright © 2018 wangkaiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>

NS_ASSUME_NONNULL_BEGIN

@interface utils : NSObject

+(GLuint)loadShader:(GLenum)type withString:(NSString *)shaderString;

+(GLuint)loadShader:(GLenum)type withpath:(NSString *)shaderpath;
@end

NS_ASSUME_NONNULL_END
