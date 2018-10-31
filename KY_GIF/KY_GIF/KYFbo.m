//
//  KYFbo.m
//  KY_GIF
//
//  Created by wangkaiyu on 2018/10/30.
//  Copyright © 2018年 wangkaiyu. All rights reserved.
//

#import "KYFbo.h"
#import <OpenGLES/ES2/glext.h>

@interface KYFbo() {
    int fbo_width;
    int fbo_height;
    GLuint _depthBuffer;
    GLuint _renderBuffer;


}
@property(nonatomic, assign)GLint defaultFBO;

@property(nonatomic, assign)GLuint fboHandle;
@property(nonatomic, assign)GLuint fboTex;




@end

@implementation KYFbo
- (instancetype)initDefault_Width:(int)width height:(int)height
{
    self = [super init];
    
    if (self) {
        fbo_width = width;
        fbo_height = height;
//        _width = width;
//        _height = height;
        [self setupFrameBuffer];
    }
    
    return self;
}

-(void)setupFrameBuffer
{
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &_defaultFBO); //绑定当前屏幕的fbo
    glGenFramebuffers(1, &_fboHandle);
    glBindFramebuffer(GL_FRAMEBUFFER, _fboHandle);
    
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    //    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA, fbo_width, fbo_height);
    glRenderbufferStorage(GL_RENDERBUFFER,GL_RGBA , fbo_width, fbo_height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
    glGenRenderbuffers(1, &_depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, fbo_width, fbo_height);
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBuffer);

    glGenTextures(1, &_fboTex);
    glBindTexture(GL_TEXTURE_2D, _fboTex);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fbo_width, fbo_height,0, GL_RGBA, GL_UNSIGNED_BYTE, NULL); //
//    glFramebufferTexture2D(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, imageID, 0);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _fboTex, 0);

    

    GLenum status;
    status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    switch(status) {
        case GL_FRAMEBUFFER_COMPLETE:
            NSLog(@"fbo complete");
            break;
            
        case GL_FRAMEBUFFER_UNSUPPORTED:
            NSLog(@"fbo unsupported");
            break;
            
        default:
            /* programming error; will fail on all hardware */
            NSLog(@"Framebuffer Error");
            break;
}

    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFBO); 
}

- (void)bind
{
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glViewport(0, 0, fbo_width, fbo_height);
    
    glBindFramebuffer(GL_FRAMEBUFFER, _fboHandle);
}

- (void)unbind
{
    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFBO);
    glBindTexture(GL_TEXTURE_2D, 0);
}

- (GLuint)getTextureResult
{
    return _fboTex;
}

-(void)dealloc
{
    
}

@end
