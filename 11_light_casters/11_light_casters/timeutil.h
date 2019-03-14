//
//  timeutil.h
//  NVRender
//
//  Created by Mac on 2018/11/19.
//  Copyright © 2018年 NVisionXR. All rights reserved.
//

#ifndef timeutil_h
#define timeutil_h

#include <stdio.h>

#include <sys/time.h>

class timeutil {
public:
    static int64_t getCurrentTime();
};


#endif /* timeutil_h */
