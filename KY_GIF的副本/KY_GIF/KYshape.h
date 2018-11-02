//
//  KYshape.h
//  KY_GIF
//
//  Created by wangkaiyu on 2018/11/2.
//  Copyright © 2018年 wangkaiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KYProgram.h"

@interface KYshape : NSObject

-(instancetype)init;

-(void)onDraw:(KYProgram *)program texture:(GLuint)tex;
-(void)onDownDraw:(KYProgram *)program texture:(GLuint)tex;
-(void)onUpDraw:(KYProgram *)program texture:(GLuint)tex;

@end
