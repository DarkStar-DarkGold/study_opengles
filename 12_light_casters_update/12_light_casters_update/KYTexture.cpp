//
//  KYTexture.cpp
//  6MVPGL
//
//  Created by wangkaiyu on 2019/3/5.
//  Copyright © 2019 wangkaiyu. All rights reserved.
//

#include <stdio.h>
#include "KYTexture.h"
#include <Foundation/Foundation.h>
#include <iostream>
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

KYTexture::KYTexture()
{
    
}

KYTexture::~KYTexture(){
    
}

KYTexture *KYTexture::create(){
    KYTexture *ret = new KYTexture();
    if (! ret -> init()) {
        delete ret;
        ret = 0;
    }
    return ret;
}

bool KYTexture::init(){
    return true;
}

GLuint KYTexture::getTextureId(const char *path)
{
    GLuint _texture_id;
    int width,height,nrChannels;
    stbi_set_flip_vertically_on_load(true);
    unsigned char *data = stbi_load(path, &width, &height, &nrChannels, 0);
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1); //对齐字节
    if(!data)
    {
        std::cout << "Failed to load texture" << std::endl;
        stbi_image_free(data);
    }else{
        glGenTextures(1, &_texture_id);
        glBindTexture(GL_TEXTURE_2D, _texture_id);
        if (nrChannels == 4) {
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_BGRA, GL_UNSIGNED_BYTE, data);
        }
        if (nrChannels == 3){
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, data);

        }
        if (nrChannels == 1){
            glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, width, height, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, data);
        }
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glGenerateMipmap(GL_TEXTURE_2D);
        glBindTexture(GL_TEXTURE_2D, 0);
        
        stbi_image_free(data);
    }
     return _texture_id;
}
