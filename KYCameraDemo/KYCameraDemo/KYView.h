//
//  KYView.h
//  KYCameraDemo
//
//  Created by wangkaiyu on 2018/11/28.
//  Copyright © 2018 wangkaiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface KYView : UIView

- (void)setupGL;
- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end


