/* -*- mode: c; coding: utf-8; tab-width: 4 -*- */

#ifndef _cv_inc_
#define _cv_inc_

#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif

/* #define NEED_sv_2pv_nolen */
#include "ppport.h"

/* remove confincting macros */
#undef do_open
#undef do_close

#include <opencv/cv.h>
#include <opencv/highgui.h>

#define _VERSION(x, y, z) ((((x) * 1000 + (y)) * 1000) + (z))
#define _CV_VERSION() _VERSION(CV_MAJOR_VERSION, CV_MINOR_VERSION, CV_SUBMINOR_VERSION)

#ifndef __cplusplus
#  if _CV_VERSION() >= _VERSION(2,4,0)
#    define __OPENCV_BACKGROUND_SEGM_HPP__
#  endif
#  define __OPENCV_VIDEOSURVEILLANCE_H__
#endif

#include <opencv/cvaux.h>

#ifdef __cplusplus
#  ifdef __OPENCV_OLD_CV_H__
#    include <opencv2/opencv.hpp>
#  endif
#else
#  if _CV_VERSION() >= _VERSION(2,4,0)
#    include <opencv2/photo/photo_c.h>
#  endif
#endif

#ifdef __cplusplus
#  if CV_MAJOR_VERSION >= 2
using namespace cv;
using namespace std;
#  endif
#endif

typedef char tiny;
#define VOID void
#define CvWindow void

#define DIM(x) (sizeof(x)/sizeof((x)[0]))

#define length(x) length_ ## x

void Carp_croak(pTHX_ char const* format, ...)
{
	va_list ap;
	const size_t size = 1000;
	char* str = (char*) alloca(size);
	char* argv[] = { str, 0 };
	SV* sv_carplevel = get_sv("Carp::CarpLevel", 0);
	va_start(ap, format);
	vsnprintf(str, size, format, ap);
	va_end(ap);
	if (sv_carplevel) {
		IV i = SvIV(sv_carplevel);
		sv_setiv(sv_carplevel, i + 1);
		call_argv("Carp::croak", G_VOID|G_DISCARD, argv);
		/* NOTREACHED, but ... */
		sv_setiv(sv_carplevel, i);
	}
	/* plan b */
	Perl_croak(aTHX_ "%s", str);
}

#define Perl_croak Carp_croak

#endif
