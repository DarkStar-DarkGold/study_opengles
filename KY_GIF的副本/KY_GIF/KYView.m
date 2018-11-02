//
//  KYView.m
//  KY_GIF
//
//  Created by wangkaiyu on 2018/10/29.
//  Copyright © 2018年 wangkaiyu. All rights reserved.
//

#import "KYView.h"
#import <OpenGLES/ES2/gl.h>
#import "KYFbo.h"
#import "KYGif.h"
#import "KYProgram.h"
#import "KYshape.h"

@interface KYView ()
{
    CAEAGLLayer *_eaglLayer;
    EAGLContext *_context;
    GLuint _renderBuffer;
    GLuint _frameBuffer;
    
//    GLuint _programHandle;
//    GLuint _positionSlot;
//    GLuint _texCoordSlot;
//    GLuint _ourTextureSlot;

    GLuint _textureID;
    GLuint _textureID2;
    
    KYFbo *_fbo;

    int i;
    float sleep;
    int c;
    float sleep2;
    
    int _width;
    int _height;
    
    KYGif *_kyGif;
    KYGif *_kyGif2;
    
    KYProgram *_kyprog;
    KYshape *_shape;
    
}

@end

@implementation KYView

-(void)loadtex
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"girl" ofType:@"gif"];
    _kyGif = [[KYGif alloc] initWithGifPath:path];

    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"tim2" ofType:@"gif"];
    _kyGif2 = [[KYGif alloc] initWithGifPath:path2];
}

+(Class)layerClass{
    return [CAEAGLLayer class];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
//        self.contentScaleFactor = [[UIScreen mainScreen] nativeScale]; //nativeScale:2.608696   scale:3.000000
        printf("%f---",self.contentScaleFactor);
        _shape = [[KYshape alloc] init];
        [self setupLayer];
        [self setContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self setupProgram];

        [self loadtex];
        [self setupDisplayLink];
        int width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].nativeScale;
        int height = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].nativeScale;
        _fbo = [[KYFbo alloc] initDefault_Width:width height:height];    }
    return self;
}

- (void)setupLayer
{
    _eaglLayer = (CAEAGLLayer*) self.layer;
    // 设为不透明
    _eaglLayer.opaque = YES;
    // 设置描绘属性 不维持选渲染内容以及颜色格式为rgbab
    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat,nil];
}
// 设置上下文
- (void)setContext {
    // 指定api
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
    }
    
    // 设置当前上下文
    [EAGLContext setCurrentContext:_context];
}
// 设置渲染缓存 分配空间
-(void)setupRenderBuffer{
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    // 为其分配空间
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_height);

    // 绑定fbo和rbo
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
}

// 设置帧缓存并renderbuffer绑定
-(void)setupFrameBuffer{
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    // 绑定fbo和rbo
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
}

// 设置program 加载shader
// render clear viewport 穿数据 mvp draw
- (void)setupProgram
{
//    NSString * vertexshaderPath = [[NSBundle mainBundle]pathForResource:@"VS" ofType:@"glsl"];
//    NSString * fragmentshaderPath = [[NSBundle mainBundle]pathForResource:@"FS" ofType:@"glsl"];
    NSURL *vertShaderURL = [[NSBundle mainBundle] URLForResource:@"VS" withExtension:@"glsl"];
    NSURL *fragShaderURL = [[NSBundle mainBundle] URLForResource:@"FS" withExtension:@"glsl"];

    _kyprog = [[KYProgram alloc] initWithvertShaders:vertShaderURL fragShaderURL:fragShaderURL];
//    _programHandle = [ESutil loadProgram:vertexshaderPath withFragmentShaderFilepath:fragmentshaderPath];
//    glUseProgram(_programHandle);
    [_kyprog use];
    
//    _positionSlot = glGetAttribLocation(_programHandle, "vPosition");
//    glEnableVertexAttribArray(_kyprog.uPosition);  // ++
    // 纹理
//    _texCoordSlot   = glGetAttribLocation(_programHandle, "TexCoordIn");
    
//    glEnableVertexAttribArray(_kyprog.uTexCoord); // ++
//    _ourTextureSlot = glGetUniformLocation(_programHandle, "ourTexture");
    
//    _textureID = [KYTexture getTextureImage:[UIImage imageNamed:@"timg.jpg"]];

}


// Add new method before init
- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)render:(CADisplayLink*)displayLink
{
    [_fbo bind];
    if(i>=[[_kyGif getTextureArray] count]-1){
        i = 0;
    }
    else{
        float t = [[_kyGif getTimesArray][i] floatValue];
        sleep += (1.0/60.0);
        if (sleep > t){
            i++;
            NSNumber *num = [_kyGif getTextureArray][i];
            _textureID = [num intValue];
            sleep = 0;
        }
        
    }

//    GLfloat vertices[] = {
//        //   x    y    z
//        -1.0,  0.0, 0.0,  //左上
//        1.0,  0.0, 0.0,  //右上
//        -1.0, -1.0, 0.0,  //左下
//        1.0, -1.0, 0.0,  //右下
//    };
//
//    //    }; // -1图片颠倒的第三种方法  前两种 见 FragmentShader
//    //4个顶点对应纹理坐标
//    GLfloat textureCoord[] = {
//        0, 1,
//        1, 1,
//        0, 0,
//        1, 0,
//    };
    
//    glActiveTexture(GL_TEXTURE0);  //激活纹理
//    glBindTexture(GL_TEXTURE_2D, _textureID); // 绑定纹理id
//    glUniform1i(_kyprog.uSampler, 0);
    
    [_shape onDraw:_kyprog texture:_textureID];
//
//    glVertexAttribPointer(_kyprog.uPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices);
//    glVertexAttribPointer(_kyprog.uTexCoord, 2, GL_FLOAT, GL_FALSE, 0, textureCoord);
    

    
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    // --------------------2------------------
    if(c >= [[_kyGif2 getTextureArray] count]-1){
        c = 0;
    }
    else{

        float tt = [[_kyGif2 getTimesArray][c] floatValue];
        sleep2 += (1.0/60.0);   // 浮点数要加0
        if (sleep2 > tt) {
            c ++;
            NSNumber *num2 = [_kyGif2 getTextureArray][c];
            _textureID2 =  [num2 intValue];
            sleep2 = 0.0;
        }
    }
    [_shape onUpDraw:_kyprog texture:_textureID2];
//
//    //        printf("%d ---",i);
//    GLfloat vertices2[] = {
//        //   x    y    z
//    -1.0,  1.0, 0.0,  //左上
//    1.0,  1.0, 0.0,  //右上
//    -1.0, -1.0, 0.0,  //左下
//    1.0, 0.0, 0.0,  //右下
//    };
//
//    GLfloat textureCoord2[] = {
//        0, 1,
//        1, 1,
//        0, 0,
//        1, 0,
//
//    };
//    glVertexAttribPointer(_kyprog.uPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices2);
//    glVertexAttribPointer(_kyprog.uTexCoord, 2, GL_FLOAT, GL_FALSE, 0, textureCoord2);
////
//        //使用纹理单元
//    glActiveTexture(GL_TEXTURE0);  //激活纹理
//    glBindTexture(GL_TEXTURE_2D, _textureID2); // 绑定纹理id
//    glUniform1i(_kyprog.uSampler, 0);
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    [_fbo unbind];
    
//==============================================================================
    glClearColor(0.3, 0.5, 0.8, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//    glEnable(GL_DEPTH_TEST);  //添加
    glViewport(0, 0, _width , _height); // 1080 1920

    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);

//    GLfloat vertices3[] = {
//        //   x    y    z
//        -1.0,  -1.0, 0.0,  //左上
//        1.0,  -1.0, 0.0,  //右上
//        -1.0, 1.0, 0.0,  //左下
//        1.0, 1.0, 0.0,  //右下
//    };
//
//    GLfloat textureCoord3[] = {
//        0, 1,
//        1, 1,
//        0, 0,
//        1, 0,
//
//    };
//    glVertexAttribPointer(_kyprog.uPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices3);
//    glVertexAttribPointer(_kyprog.uTexCoord, 2, GL_FLOAT, GL_FALSE, 0, textureCoord3);
    //
//    glActiveTexture(GL_TEXTURE0);  //激活纹理
//    glBindTexture(GL_TEXTURE_2D, [_fbo getTextureResult]); // 绑定纹理id
//    glUniform1i(_kyprog.uSampler, 0);
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    [_shape onDraw:_kyprog texture:[_fbo getTextureResult]];
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer); // 主屏的渲染缓存
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}





@end
