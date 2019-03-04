//
//  YView.m
//  纹理stb
//
//  Created by wangkaiyu on 2019/3/4.
//  Copyright © 2019 wangkaiyu. All rights reserved.
//

#import "YView.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import "./utils.h"
#include <iostream>

#define STB_IMAGE_IMPLEMENTATION
#import "./stb_image.h"

@interface YView(){
    CAEAGLLayer *_layer;
    EAGLContext *_cont;
    GLuint _framebuffer;
    GLuint  _renderBuffer;
    GLuint  _programY;
    GLuint _positionY;
    GLuint _texCoord;
    GLuint  _ourTextureSlot;
}

@end

@implementation YView

+(Class)layerclass{
    return [CAEAGLLayer class];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setuplayer];
        [self setContext];
        [self setupRenderBuffer];
//        [self setupFrameBuffer];
//        [self setProgram];
//        [self render];
    }
    return self;
        
}

-(void)setuplayer{
    _layer = (CAEAGLLayer*) self.layer;
    _layer.opaque = YES;
}

-(void)setContext{
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES3;
    _cont = [[EAGLContext alloc]initWithAPI:api];
    [EAGLContext setCurrentContext:_cont];
}

-(void)setupRenderBuffer
{
    glGenRenderbuffers(1, &(_renderBuffer));
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [_cont renderbufferStorage:GL_RENDERBUFFER fromDrawable:_layer];
}


-(void)setupFrameBuffer{
    glGenBuffers(1, &_framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
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
    _texCoord = glGetAttribLocation(_programY, "texCoord");
    _ourTextureSlot = glGetUniformLocation(_programY, "tex");
}

-(void)render{
    glClearColor(1.0, 0.2, 0.2, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    
    GLfloat points[] = {
        0.0,1.0,
        0.0,-1.0,
        1.0,0.0,
        -1.0,0.0
    };
    GLfloat texcoord[] = {
        0.0,1.0,
        0.0,-1.0,
        1.0,0.0,
        -1.0,0.0
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
    glBufferData(GL_ARRAY_BUFFER, sizeof(texcoord), texcoord, GL_STATIC_DRAW);
    glVertexAttribPointer(_texCoord, 2, GL_FLOAT, GL_FALSE, 2*sizeof(float), (void*)0);
    glEnableVertexAttribArray(_texCoord);
    // ---------
    GLuint texture1;
    glGenTextures(1, &texture1);
    glBindTexture(GL_TEXTURE_2D, texture1);
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
    const char *path = [[[NSBundle mainBundle]pathForResource:@"test1Ret" ofType:@".jpg"] UTF8String];
    unsigned char *data = stbi_load(path, &width, &height, &nrChannels, 0);
    if (data)
    {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, data);
        glGenerateMipmap(GL_TEXTURE_2D);
    }
    else
    {
        std::cout << "Failed to load texture" << std::endl;
    }
    stbi_image_free(data);
  

    glActiveTexture(GL_TEXTURE0);  //激活纹理
    glBindTexture(GL_TEXTURE_2D, texture1); // 绑定纹理id
    glUniform1i(_ourTextureSlot, 0);
    
    glUseProgram(_programY);
    glBindVertexArray(VAO);
    glDrawArrays(GL_TRIANGLES, 0, 4);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    [_cont presentRenderbuffer:_renderBuffer];
}

@end
