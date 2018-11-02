//
//  KYshape.m
//  KY_GIF
//
//  Created by wangkaiyu on 2018/11/2.
//  Copyright © 2018年 wangkaiyu. All rights reserved.
//

#import "KYshape.h"
#import <OpenGLES/ES2/gl.h>


@implementation KYshape

GLfloat vertices[] = {
    //   x    y    z
    -1.0,  1.0, 0.0,  //左上
    1.0,  1.0, 0.0,  //右上
    -1.0, -1.0, 0.0,  //左下
    1.0, -1.0, 0.0,  //右下
};
GLfloat vertices1[] = {
    //   x    y    z
    -1.0,  1.0, 0.0,  //左上
    1.0,  1.0, 0.0,  //右上
    -1.0, 0.0, 0.0,  //左下
    1.0, 0.0, 0.0,  //右下
};
GLfloat vertices2[] = {
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)onDraw:(KYProgram *)program texture:(GLuint)tex
{
    glVertexAttribPointer(program.uPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(program.uPosition);

    glVertexAttribPointer(program.uTexCoord, 2, GL_FLOAT, GL_FALSE, 0, textureCoord);
    glEnableVertexAttribArray(program.uTexCoord);
    
    glActiveTexture(GL_TEXTURE0);  //激活纹理
    glBindTexture(GL_TEXTURE_2D, tex); // 绑定纹理id
    glUniform1i(program.uSampler, 0);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

-(void)onDownDraw:(KYProgram *)program texture:(GLuint)tex
{
    glVertexAttribPointer(program.uPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices2);
    glEnableVertexAttribArray(program.uPosition);
    
    glVertexAttribPointer(program.uTexCoord, 2, GL_FLOAT, GL_FALSE, 0, textureCoord);
    glEnableVertexAttribArray(program.uTexCoord);
    
    glActiveTexture(GL_TEXTURE0);  //激活纹理
    glBindTexture(GL_TEXTURE_2D, tex); // 绑定纹理id
    glUniform1i(program.uSampler, 0);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

-(void)onUpDraw:(KYProgram *)program texture:(GLuint)tex
{
    glVertexAttribPointer(program.uPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices1);
    glEnableVertexAttribArray(program.uPosition);
    
    glVertexAttribPointer(program.uTexCoord, 2, GL_FLOAT, GL_FALSE, 0, textureCoord);
    glEnableVertexAttribArray(program.uTexCoord);
    
    glActiveTexture(GL_TEXTURE0);  //激活纹理
    glBindTexture(GL_TEXTURE_2D, tex); // 绑定纹理id
    glUniform1i(program.uSampler, 0);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

@end
