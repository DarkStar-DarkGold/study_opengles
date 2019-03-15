//
//  timeutil.cpp
//  NVRender
//
//  Created by Mac on 2018/11/19.
//  Copyright © 2018年 NVisionXR. All rights reserved.
//

#include <stdio.h>
#include "./timeutil.h"

#ifdef WIN32
int gettimeofday(struct timeval *tp, void *tzp)
{
    time_t clock;
    struct tm tm;
    SYSTEMTIME wtm;
    GetLocalTime(&wtm);
    tm.tm_year = wtm.wYear - 1900;
    tm.tm_mon = wtm.wMonth - 1;
    tm.tm_mday = wtm.wDay;
    tm.tm_hour = wtm.wHour;
    tm.tm_min = wtm.wMinute;
    tm.tm_sec = wtm.wSecond;
    tm.tm_isdst = -1;
    clock = mktime(&tm);
    tp->tv_sec = clock;
    tp->tv_usec = wtm.wMilliseconds * 1000;
    return (0);
}
#endif

int64_t timeutil::getCurrentTime()
{
    struct timeval tv;
    gettimeofday(&tv,NULL);
    
    return tv.tv_sec * 1000 + tv.tv_usec / 1000; // 秒*1000（毫秒） + 微妙/1000（毫秒）
}
