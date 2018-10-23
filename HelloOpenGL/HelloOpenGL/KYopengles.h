//
//  KYopengles.h
//  HelloOpenGL
//
//  Created by wangkaiyu on 2018/10/22.
//  Copyright © 2018年 wangkaiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@interface KYopengles : UIView {
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    GLuint _positionSlot;
    GLuint _colorSlot;
    GLuint _programHandle;
    GLuint _modelViewprojectionUniform;
    GLuint _projectionUniform;
    
    float _currentRotation;
    GLuint _depthRenderBuffer;


    
}

//- (id)initWithFrame:(CGRect)frame Height:(float)height Length:(float)length;

//- (instancetype)initWithHeight:(float)height Length:(float)length;

@end
