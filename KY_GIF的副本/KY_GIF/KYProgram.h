//
//  KYProgram.h
//  KY_GIF
//
//  Created by wangkaiyu on 2018/11/2.
//  Copyright © 2018年 wangkaiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>


@interface KYProgram : NSObject

- (instancetype)initWithvertShaders:(NSURL *)vertShaderURL fragShaderURL:(NSURL *)fragShaderURL;

@property(nonatomic,assign)GLuint uPosition;
@property(nonatomic,assign)GLuint uTexCoord;
@property(nonatomic,assign)GLuint uSampler;

-(void)use;

- (GLint)glGetAttribLocation:(NSString *)name;
- (GLint)glGetUniformLocation:(NSString *)name;
- (void)destory;

@end
