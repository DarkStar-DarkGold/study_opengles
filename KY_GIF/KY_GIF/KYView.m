//
//  KYView.m
//  KY_GIF
//
//  Created by wangkaiyu on 2018/10/29.
//  Copyright © 2018年 wangkaiyu. All rights reserved.
//

#import "KYView.h"
#import "ESutil.h"
#import "KYTexture.h"
#import <OpenGLES/ES2/gl.h>
#import "KYFbo.h"

@interface KYView ()
{
    CAEAGLLayer *_eaglLayer;
    EAGLContext *_context;
    GLuint _renderBuffer;
    GLuint _frameBuffer;
    
    GLuint _programHandle;
    GLuint _positionSlot;
    GLuint _texCoordSlot;
    GLuint _ourTextureSlot;
    
    NSMutableArray* tex;
    NSMutableArray* tex2;


    GLuint _textureID;
    GLuint _textureID2;
    GLuint _textureID3;


    NSArray * image1_arr;
    NSArray * time1_arr;
    NSArray * image2_arr;
    NSArray * time2_arr;

    UIImage *_image;
    UIImage *_image2;
    
    KYFbo *_fbo;

    int i;
    float sleep;
    int c;
    float sleep2;
    
    int _width2;
    int _height2;
}

@end

@implementation KYView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)loadtex
{
    tex2 = [[NSMutableArray alloc] init];
    tex = [[NSMutableArray alloc]init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"girl" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path options:nil error:nil];
    NSMutableDictionary *_data1 = [KYTexture durationForGifData:data];
    image1_arr = [_data1 objectForKey:@"key"];
    time1_arr = [_data1 objectForKey:@"key2"];
    for(int a = 0; a < [image1_arr count]; a++){
        _image = image1_arr[a];
        GLuint texID = [KYTexture getTextureImage:_image];
        NSNumber *texid = [NSNumber numberWithInt:texID];
        [tex addObject:texid];
    };
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"tim2" ofType:@"gif"];
    NSData *data2 = [NSData dataWithContentsOfFile:path2 options:nil error:nil];
    NSMutableDictionary *_data2 = [KYTexture durationForGifData:data2];
    
    image2_arr = [_data2 objectForKey:@"key"];
    time2_arr = [_data2 objectForKey:@"key2"];
    for(int z = 0;z < [image2_arr count]; z++){
        _image2 = image2_arr[z];
        GLuint texID2 = [KYTexture getTextureImage:_image2];
        NSNumber *texid2 = [NSNumber numberWithInt:texID2];
        [tex2 addObject:texid2];
    };
    
}

+(Class)layerClass{
    return [CAEAGLLayer class];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        self.contentScaleFactor = [[UIScreen mainScreen] nativeScale]; //nativeScale:2.608696   scale:3.000000
        printf("%f---",self.contentScaleFactor);

        [self setupLayer];
        [self setContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self setupProgram];

        [self loadtex];
        [self setupDisplayLink];
        int width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].nativeScale;
        int height = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].nativeScale;
        _fbo = [[KYFbo alloc] initDefault_Width:width height:height];
    }
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
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_width2);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_height2);

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
    NSString * vertexshaderPath = [[NSBundle mainBundle]pathForResource:@"VS" ofType:@"glsl"];
    NSString * fragmentshaderPath = [[NSBundle mainBundle]pathForResource:@"FS" ofType:@"glsl"];

    _programHandle = [ESutil loadProgram:vertexshaderPath withFragmentShaderFilepath:fragmentshaderPath];
    glUseProgram(_programHandle);
    
    _positionSlot = glGetAttribLocation(_programHandle, "vPosition");
    glEnableVertexAttribArray(_positionSlot);
    // 纹理
    _texCoordSlot   = glGetAttribLocation(_programHandle, "TexCoordIn");
    
    glEnableVertexAttribArray(_texCoordSlot);
    _ourTextureSlot = glGetUniformLocation(_programHandle, "ourTexture");
    
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
    if(i>=[image1_arr count]-1){
        i = 0;
    }
    else{
        float t = [time1_arr[i] floatValue];
        sleep += (1.0/60.0);
        if (sleep > t){
            i++;
            NSNumber *num = tex[i];
            _textureID = [num intValue];
            sleep = 0;
        }
        
    }
//    设置清屏颜色,默认是黑色，如果你的运行结果是黑色，问题就可能在这儿
//    glClearColor(0.3, 0.5, 0.8, 1.0);
//    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//    glEnable(GL_DEPTH_TEST);  //添加
//
//    // Setup viewport
//    glViewport(0, 0, _width2, _height2);//self.frame.size.width, self.frame.size.height);
//    //    //4个顶点(分别表示xyz轴)
    GLfloat vertices[] = {
        //   x    y    z
        -1.0,  0.0, 0.0,  //左上
        1.0,  0.0, 0.0,  //右上
        -1.0, -1.0, 0.0,  //左下
        1.0, -1.0, 0.0,  //右下
    };
    
    //    }; // -1图片颠倒的第三种方法  前两种 见 FragmentShader
    //4个顶点对应纹理坐标
    GLfloat textureCoord[] = {
        0, 1,
        1, 1,
        0, 0,
        1, 0,
    };
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, 0, textureCoord);
    
    //使用纹理单元
//    [_fbo bind];

    glActiveTexture(GL_TEXTURE0);  //激活纹理
    glBindTexture(GL_TEXTURE_2D, _textureID); // 绑定纹理id
    glUniform1i(_ourTextureSlot, 0);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    // --------------------2------------------
    if(c >= [image2_arr count]-1){
        c = 0;
    }
    else{

        float tt = [time2_arr[c] floatValue];
        sleep2 += (1.0/60.0);   // 浮点数要加0
        if (sleep2 > tt) {
            c ++;
            NSNumber *num2 = tex2[c];
            _textureID2 =  [num2 intValue];
            sleep2 = 0.0;
        }
    }

    //        printf("%d ---",i);
    GLfloat vertices2[] = {
        //   x    y    z
        -1.0,  1.0, 0.0,  //左上
        1.0,  1.0, 0.0,  //右上
        -1.0, 0.0, 0.0,  //左下
        1.0, 0.0, 0.0,  //右下
    };

    GLfloat textureCoord2[] = {
        0, 1,
        1, 1,
        0, 0,
        1, 0,

    };

    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices2);
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, 0, textureCoord2);
//
        //使用纹理单元
    glActiveTexture(GL_TEXTURE0);  //激活纹理
    glBindTexture(GL_TEXTURE_2D, _textureID2); // 绑定纹理id
    glUniform1i(_ourTextureSlot, 0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    [_fbo unbind];
    

    glClearColor(0.3, 0.5, 0.8, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//    glEnable(GL_DEPTH_TEST);  //添加
    glViewport(0, 0, _width2 , _height2); // 1080 1920
//    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
//    printf("%d---",self.frame.size.width);
//    printf("==%d",self.frame.size.height);

    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);

    GLfloat vertices3[] = {
        //   x    y    z
        -1.0,  1.0, 0.0,  //左上
        1.0,  1.0, 0.0,  //右上
        -1.0, -1.0, 0.0,  //左下
        1.0, -1.0, 0.0,  //右下
    };

    GLfloat textureCoord3[] = {
        0, 1,
        1, 1,
        0, 0,
        1, 0,

    };
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices3);
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, 0, textureCoord3);
    //

//    _textureID3 = [_fbo getTextureResult];
    glActiveTexture(GL_TEXTURE0);  //激活纹理
    glBindTexture(GL_TEXTURE_2D, [_fbo getTextureResult]); // 绑定纹理id
    glUniform1i(_ourTextureSlot, 0);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer); // 主屏的渲染缓存
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}





@end
