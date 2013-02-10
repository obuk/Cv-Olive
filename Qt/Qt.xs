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


MODULE = Cv::Qt		PACKAGE = Cv::Qt

=xxx

int
cvInitSystem2(AV* argv)
CODE:
	fprintf(stderr, "Cv::Qt::cvInitSystem2\n");
	if (av_len(argv) >= 0) {
		char **av = (char**)alloca(sizeof(char*) * (av_len(argv) + 2)); int ac;
		if (av == NULL) XSRETURN_UNDEF;
		for (ac = 0; ac <= av_len(argv); ac++) {
			av[ac] = SvPV_nolen((SV*)(*av_fetch(argv, ac, 0)));
		}
		av[ac++] = 0;
		RETVAL = cvInitSystem(ac, av);
	} else {
		RETVAL = cvInitSystem(0, NULL);
	}
OUTPUT:
	RETVAL

=cut

# ============================================================
#  highgui. High-level GUI and Media I/O: Qt new functions
# ============================================================

#if _CV_VERSION() >= _VERSION(2,0,0)

void
cvSetWindowProperty(const char* name, int prop_id, double prop_value)

void
cvGetWindowProperty(const char* name, int prop_id)

#endif

#if _CV_VERSION() >= _VERSION(2,2,0)

CvFont*
cvFontQt(const char* nameFont, int pointSize = -1, CvScalar color = cvScalarAll(0), int weight = CV_FONT_NORMAL, int style = CV_STYLE_NORMAL, int spacing = 0)
CODE:
	Newx(RETVAL, 1, CvFont);
	*RETVAL = cvFontQt(nameFont, pointSize, color, weight, style, spacing);
OUTPUT:
	RETVAL

void
cvAddText(const CvArr* img, const char* text, CvPoint location, CvFont *font)

void
cvDisplayOverlay(const char* name, const char* text, int delay)

void
cvDisplayStatusBar(const char* name, const char* text, int delayms)

#TBD# void cvCreateOpenGLCallback(const char* window_name, CvOpenGLCallback callbackOpenGL, VOID* userdata = NULL, double angle = -1, double zmin = -1, double zmax = -1)

void
cvSaveWindowParameters(const char* name)

void
cvLoadWindowParameters(const char* name)

#TBD# int cvCreateButton(const char* button_name=NULL, CvButtonCallback on_change = NULL, VOID* userdata = NULL, int button_type = CV_PUSH_BUTTON, int initial_button_state = 0)

#endif
