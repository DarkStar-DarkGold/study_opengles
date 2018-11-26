//
//  YView.m
//  1
//
//  Created by wangkaiyu on 2018/11/25.
//  Copyright © 2018 wangkaiyu. All rights reserved.
//

#import "YView.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface YView()
{
    CAEAGLLayer *_layer;
    EAGLContext *_cont;
    GLuint _renderBuffer;
    GLuint _framebuffer;
}

@end


@implementation YView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(Class)layerClass{
    return  [CAEAGLLayer class];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self render];
        
    }
    return self;
}
-(void)setupLayer
{
    _layer = (CAEAGLLayer*) self.layer;
    _layer.opaque = YES;
    _layer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil]; //
}


-(void)setupContext{
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _cont = [[EAGLContext alloc] initWithAPI:api];
    if (!_cont) {
        NSLog(@"Failed to initialize OpenGlES 2.0 context!");
    }
    [EAGLContext setCurrentContext:_cont];
}

-(void)setupRenderBuffer
{
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    // 为其r分配空间
    [_cont renderbufferStorage:GL_RENDERBUFFER fromDrawable:_layer];
}

-(void)setupFrameBuffer
{
    glGenFramebuffers(1, &_framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
}

-(void)render
{
    glClearColor(0.3, 0.5, 0.8, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    [_cont presentRenderbuffer:_renderBuffer];
}
    
@end
