/* -*- mode: text; coding: utf-8; tab-width: 4 -*- */

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

static int cb_error(int status, const char* func_name, const char* err_msg,
					const char* file_name, int line, VOID* userdata)  {
	SV* handler = get_sv("Cv::ERROR", 0);
	cvSetErrStatus(0);
	if (handler && SvROK(handler) && SvTYPE(SvRV(handler)) == SVt_PVCV) {
		dSP;
		ENTER;
		SAVETMPS;
		PUSHMARK(SP);
		EXTEND(SP, 5);
		PUSHs(sv_2mortal(newSViv(status)));
		PUSHs(sv_2mortal(newSVpv(func_name, 0)));
		PUSHs(sv_2mortal(newSVpv(err_msg, 0)));
		PUSHs(sv_2mortal(newSVpv(file_name, 0)));
		PUSHs(sv_2mortal(newSViv(line)));
		PUTBACK;
		call_sv(handler, G_VOID|G_DISCARD);
		FREETMPS;
		LEAVE;
		return 0;
	} else {
		Perl_croak(aTHX_ "cb_error: can't call Cv::ERROR");
		return -1;
	}
}

MODULE = Cv::Typemap	PACKAGE = Cv

# ============================================================
#  T_CvBox2D
# ============================================================

CvBox2D
cvBox2D(CvPoint2D32f center, CvSize2D32f size, float angle)
CODE:
	RETVAL.center = center;
	RETVAL.size = size;
	RETVAL.angle = angle;
OUTPUT:
	RETVAL

CvBox2D
CvBox2D(CvBox2D box)
CODE:
	RETVAL = box;
OUTPUT:
	RETVAL

# ============================================================
#  T_CvConnectedComp
# ============================================================

CvConnectedComp
cvConnectedComp(double area, CvScalar value, CvRect rect, CvSeq* contour)
CODE:
	RETVAL.area = area;
	RETVAL.value = value;
	RETVAL.rect = rect;
	RETVAL.contour = contour;
OUTPUT:
	RETVAL

CvConnectedComp
CvConnectedComp(CvConnectedComp cc)
CODE:
	RETVAL = cc;
OUTPUT:
	RETVAL


# ============================================================
#  T_CvPoint, T_CvPointPtr
# ============================================================

CvPoint
CvPoint(CvPoint pt)
CODE:
	RETVAL = pt;
OUTPUT:
	RETVAL

CvPoint*
cvPointPtr(int x, int y)
CODE:
	CvPoint pt = cvPoint(x, y);
	int length_RETVAL = 1;
	RETVAL = &pt;
OUTPUT:
	RETVAL


CvPoint*
CvPointPtr(CvPoint pt)
CODE:
	int length_RETVAL = 1;
	RETVAL = &pt;
OUTPUT:
	RETVAL


# ============================================================
#  T_CvPoint2D32f, T_CvPoint2D32fPtr
# ============================================================

CvPoint2D32f
CvPoint2D32f(CvPoint2D32f pt)
CODE:
	RETVAL = pt;
OUTPUT:
	RETVAL


CvPoint2D32f*
cvPoint2D32fPtr(float x, float y)
CODE:
	CvPoint2D32f pt = cvPoint2D32f(x, y);
	int length_RETVAL = 1;
	RETVAL = &pt;
OUTPUT:
	RETVAL


CvPoint2D32f*
CvPoint2D32fPtr(CvPoint2D32f pt)
CODE:
	int length_RETVAL = 1;
	RETVAL = &pt;
OUTPUT:
	RETVAL


# ============================================================
#  T_CvPoint2D64f, T_CvPoint2D64fPtr
# ============================================================

CvPoint2D64f
CvPoint2D64f(CvPoint2D64f pt)
CODE:
	RETVAL = pt;
OUTPUT:
	RETVAL

CvPoint2D64f*
cvPoint2D64fPtr(double x, double y)
CODE:
	CvPoint2D64f pt = cvPoint2D64f(x, y);
	int length_RETVAL = 1;
	RETVAL = &pt;
OUTPUT:
	RETVAL


CvPoint2D64f*
CvPoint2D64fPtr(CvPoint2D64f pt)
CODE:
	int length_RETVAL = 1;
	RETVAL = &pt;
OUTPUT:
	RETVAL


# ============================================================
#  T_CvPoint3D32f, T_CvPoint3D32fPtr
# ============================================================

CvPoint3D32f
CvPoint3D32f(CvPoint3D32f pt)
CODE:
	RETVAL = pt;
OUTPUT:
	RETVAL


CvPoint3D32f*
cvPoint3D32fPtr(float x, float y, float z)
CODE:
	CvPoint3D32f pt = cvPoint3D32f(x, y, z);
	int length_RETVAL = 1;
	RETVAL = &pt;
OUTPUT:
	RETVAL


CvPoint3D32f*
CvPoint3D32fPtr(CvPoint3D32f pt)
CODE:
	int length_RETVAL = 1;
	RETVAL = &pt;
OUTPUT:
	RETVAL


# ============================================================
#  T_CvPoint3D64f, T_CvPoint3D64fPtr
# ============================================================

CvPoint3D64f
CvPoint3D64f(CvPoint3D64f pt)
CODE:
	RETVAL = pt;
OUTPUT:
	RETVAL


CvPoint3D64f*
cvPoint3D64fPtr(double x, double y, double z)
CODE:
	CvPoint3D64f pt = cvPoint3D64f(x, y, z);
	int length_RETVAL = 1;
	RETVAL = &pt;
OUTPUT:
	RETVAL


CvPoint3D64f*
CvPoint3D64fPtr(CvPoint3D64f pt)
CODE:
	int length_RETVAL = 1;
	RETVAL = &pt;
OUTPUT:
	RETVAL


# ============================================================
#  T_CvRect
# ============================================================

CvRect
CvRect(CvRect rect)
CODE:
	RETVAL = rect;
OUTPUT:
	RETVAL


# ============================================================
#  T_CvScalar
# ============================================================

CvScalar
CvScalar(CvScalar scalar)
CODE:
	RETVAL = scalar;
OUTPUT:
	RETVAL

# ============================================================
#  T_CvSize
# ============================================================

CvSize
CvSize(CvSize size)
CODE:
	RETVAL = size;
OUTPUT:
	RETVAL

# ============================================================
#  T_CvSize2D32f
# ============================================================

CvSize2D32f
CvSize2D32f(CvSize2D32f size)
CODE:
	RETVAL = size;
OUTPUT:
	RETVAL

# ============================================================
#  T_CvTermCriteria
# ============================================================

CvTermCriteria
CvTermCriteria(CvTermCriteria term)
CODE:
	RETVAL = term;
OUTPUT:
	RETVAL


# ============================================================
#  T_floatPtr
# ============================================================

float*
floatPtr(float* values)
CODE:
	int length_RETVAL = length_values;
	RETVAL = values;
OUTPUT:
	RETVAL

double*
doublePtr(double* values)
CODE:
	int length_RETVAL = length_values;
	RETVAL = values;
OUTPUT:
	RETVAL


# ============================================================
#  T_intPtr
# ============================================================

int*
intPtr(int* values)
CODE:
	int length_RETVAL = length_values;
	RETVAL = values;
OUTPUT:
	RETVAL

MODULE = Cv::Typemap	PACKAGE = Cv
# ====================
BOOT:
	cvRedirectError(&cb_error, (VOID*)NULL, NULL);
	cvSetErrMode(1);
	cvSetErrStatus(0);
