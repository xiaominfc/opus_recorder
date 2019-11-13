#ifndef LOG_INCLUDED
#define LOG_INCLUDED

#include "config.h"

#include<errno.h>

#define  LOG_TAG "libOpusTool"
#define  LOGI(...)  printf(__VA_ARGS__)
#define  LOGE(...)  printf(__VA_ARGS__)
#define  LOGD(...)  printf(__VA_ARGS__)

#ifdef perror
#undef perror
#endif
#define perror(smg) printf("opus error:%s :%s",smg, strerror(errno))

#ifdef fprintf
#undef fprintf
#endif
#define fprintf(strm,...) printf(__VA_ARGS__)

#else
#include <stdio.h>
#include <stdlib.h>
#define LOGE(fmt,arg...) fprintf(stderr,fmt , ##arg)
#define LOGD(fmt,arg...) fprintf(stderr,fmt , ##arg)
#endif
