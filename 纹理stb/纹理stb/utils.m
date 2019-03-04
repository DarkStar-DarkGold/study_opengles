//
//  utils.m
//  纹理stb
//
//  Created by wangkaiyu on 2019/3/4.
//  Copyright © 2019 wangkaiyu. All rights reserved.
//

#import "utils.h"

@implementation utils

+(GLuint)loadShader:(GLenum)type withpath:(NSString *)shaderpath
{
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderpath encoding:NSUTF8StringEncoding error:NULL];
    return [self loadShader:type withString:shaderString];
    
}

+(GLuint)loadShader:(GLenum)type withString:(NSString *)shaderString
{
    GLuint shader = glCreateShader(type);
    
    const char* shaderStringUTF8 = [shaderString UTF8String];
    glShaderSource(shader, 1, &shaderStringUTF8, NULL);
    glCompileShader(shader);
    
    return shader;
}



@end
