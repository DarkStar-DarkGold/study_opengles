//
//  KYTexture.h
//  6MVPGL
//
//  Created by wangkaiyu on 2019/3/5.
//  Copyright © 2019 wangkaiyu. All rights reserved.
//

#ifndef KYTexture_h
#define KYTexture_h
#include <OpenGLES/ES3/gl.h>
#include <OpenGLES/ES3/glext.h>

class KYTexture {
public:
    KYTexture();
    ~KYTexture();
    static KYTexture * create();
    static GLuint getTextureId(const char *path);
private:
    
    bool init();
};

#endif /* KYTexture_h */
