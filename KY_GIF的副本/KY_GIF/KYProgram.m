//
//  KYProgram.m
//  KY_GIF
//
//  Created by wangkaiyu on 2018/11/2.
//  Copyright © 2018年 wangkaiyu. All rights reserved.
//

#import "KYProgram.h"

@interface KYProgram(){
    GLuint _program;
}

@end

@implementation KYProgram


-(instancetype)initWithvertShaders:(NSURL *)vertShaderURL fragShaderURL:(NSURL *)fragShaderURL
{
    self = [super init];
    if (self) {
        _program = [self loadShaders:(NSURL *)vertShaderURL fragShaderURL:(NSURL *)fragShaderURL];
        self.uPosition = [self glGetAttribLocation:@"vPosition"];
        self.uTexCoord = [self glGetAttribLocation:@"TexCoordIn"];
        self.uSampler = [self glGetUniformLocation:@"ourTexture"];
        
    }
    return self;
}

-(void)use{
    glUseProgram(_program);
}

-(void)destory{
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

-(BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s",log);
        free(log);
    }
#endif
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    return YES;
}

- (GLuint)loadShaders:(NSURL *)vertShaderURL fragShaderURL:(NSURL *)fragShaderURL
{
    GLuint vertShader, fragShader;
    
    GLuint program = glCreateProgram();
    
    // Create and compile the vertex shader.
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER URL:vertShaderURL]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER URL:fragShaderURL]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);
    
    // Link the program.
    if (![self linkProgram:program]) {
        NSLog(@"Failed to link program: %d", program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program) {
            glDeleteProgram(program);
            program = 0;
        }
        
        return program;
    }
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return program;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type URL:(NSURL *)URL
{
    NSError *error;
    NSString *sourceString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
    if (sourceString == nil) {
        NSLog(@"Failed to load vertex shader: %@", [error localizedDescription]);
        return NO;
    }
    
    GLint status;
    const GLchar *source;
    source = (GLchar *)[sourceString UTF8String];
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}
- (GLint)glGetAttribLocation:(NSString *)name
{
    return glGetAttribLocation(_program, [name UTF8String]);
}

- (GLint)glGetUniformLocation:(NSString *)name
{
    return glGetUniformLocation(_program, [name UTF8String]);
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLenght, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLenght);
    if (logLenght > 0) {
        GLchar *log = (GLchar *)malloc(logLenght);
        glGetProgramInfoLog(prog, logLenght, &logLenght, log);
        NSLog(@"Program validate log:\n%s",log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    return YES;
}

-(void)dealloc{
    NSLog(@"MGProgram dealloc");
    [self destory];
}

@end
