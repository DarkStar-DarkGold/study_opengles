//
//  YView.m
//  3
//
//  Created by wangkaiyu on 2018/11/26.
//  Copyright © 2018 wangkaiyu. All rights reserved.
//

#import "YView.h"
//#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES3/gl.h>
#import "utils.h"
#import <GLKit/GLKit.h>
#define STB_IMAGE_IMPLEMENTATION
#import "./stb_image.h"
//#import <OpenGLES/ES2/glext.h>

@interface YView()
{
    CAEAGLLayer *_layer;
    EAGLContext *_cont;
    GLuint _renderBuffer;
    GLuint _frameBuffer;
    
    GLuint _programY;
    GLuint _positionY;
    GLuint _colorY;
    GLuint _texc;
    GLuint _tex1;



}

@end


@implementation YView

+(Class)layerClass
{
    return [CAEAGLLayer class];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self setProgram];
        [self render];
    }
    return self;
}

-(void)setupLayer
{
    _layer = (CAEAGLLayer*)self.layer;
    _layer.opaque = YES;
}

-(void)setupContext
{
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES3;
    _cont = [[EAGLContext alloc] initWithAPI:api];
    
    [EAGLContext setCurrentContext:_cont];
}

-(void)setupRenderBuffer
{
    glGenRenderbuffers(1, &(_renderBuffer));
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [_cont renderbufferStorage:GL_RENDERBUFFER fromDrawable:_layer];
}

-(void)setupFrameBuffer
{
    glGenFramebuffers(1, &(_frameBuffer));
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
}

-(void)setProgram
{
    NSString *ver = [[NSBundle mainBundle] pathForResource:@"ver" ofType:@"glsl"];
    NSString *frag = [[NSBundle mainBundle] pathForResource:@"frag" ofType:@"glsl"];
    
    GLuint vershader = [utils loadShader:GL_VERTEX_SHADER withpath:ver];
    GLuint fragshader = [utils loadShader:GL_FRAGMENT_SHADER withpath:frag];
    
    _programY = glCreateProgram();
    glAttachShader(_programY, vershader);
    glAttachShader(_programY, fragshader);
    glLinkProgram(_programY);
    glUseProgram(_programY);
    _positionY = glGetAttribLocation(_programY, "Yposition");
    _texc = glGetAttribLocation(_programY, "tec");
    _colorY = glGetUniformLocation(_programY, "tex");
}

-(void)render{
    glClearColor(1.0, 0.3, 0.3, 0.4);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    GLfloat points[] = {  // opengles 以屏幕中心为原点。
         -1.0f,0.0f,
        0.0f,1.0f,
        0.0f,-1.0f,
        1.0f,0.0f
       
        
        
    };
    GLfloat color[] = {  // opengles 以屏幕中心为原点。
        -1.0f,0.0f,
        0.0f,1.0f,
        0.0f,-1.0f,
        1.0f,0.0f,
       
    };
    GLuint VAO;
    GLuint VBO;
    GLuint VBO2;

    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(points), points, GL_STATIC_DRAW);
    
    glVertexAttribPointer(_positionY, 2, GL_FLOAT, GL_FALSE, 2*sizeof(float), (void*)0);
    glEnableVertexAttribArray(_positionY);
    glGenBuffers(1, &VBO2);
    glBindBuffer(GL_ARRAY_BUFFER, VBO2);
    glBufferData(GL_ARRAY_BUFFER, sizeof(color), color, GL_STATIC_DRAW);
    glVertexAttribPointer(_texc, 2, GL_FLOAT, GL_FALSE, 2*sizeof(float), (void*)0);
    glEnableVertexAttribArray(_texc);

    
    glGenTextures(1, &_tex1);
    glBindTexture(GL_TEXTURE_2D, _tex1);
    // set the texture wrapping parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);    // set texture wrapping to GL_REPEAT (default wrapping method)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    // set texture filtering parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // load image, create texture and generate mipmaps
    int width, height, nrChannels;
    stbi_set_flip_vertically_on_load(true); // tell stb_image.h to flip loaded texture's on the y-axis.
    // The FileSystem::getPath(...) is part of the GitHub repository so we can find files on any IDE/platform; replace it with your own image path.
    const char *path = [[[NSBundle mainBundle]pathForResource:@"test2Ret" ofType:@".jpg"] UTF8String];
    unsigned char *data = stbi_load(path, &width, &height, &nrChannels, 0);
    if (data)
    {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, data);
        glGenerateMipmap(GL_TEXTURE_2D);
    }

    stbi_image_free(data);
    
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE0, _tex1);
    glUniform1i(_colorY, 0);

    glUseProgram(_programY);
    glBindVertexArray(VAO);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    //    glDrawArrays(GL_LINES, 0, 4);  // 十字 不连接
    //    glDrawArrays(GL_LINE_LOOP, 0, 4);  // 头尾相连
    //    glDrawArrays(GL_LINE_STRIP, 0, 4);  // 头尾不相连
    //    glDrawArrays(GL_TRIANGLES, 0, 4);  // 够三个点才回链接
    //    glDrawArrays(GL_TRIANGLE_FAN, 0, 5);  // 以第一个点为中心点
    //     glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);  // 头尾不相连。123 234
    
    [_cont presentRenderbuffer:_renderBuffer];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

