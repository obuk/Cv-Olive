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
#define __OPENCV_BACKGROUND_SEGM_HPP__
#define __OPENCV_VIDEOSURVEILLANCE_H__
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

typedef struct CvCircle {
	CvPoint2D32f center;
	float radius;
} CvCircle;


#define DIM(x) (sizeof(x)/sizeof((x)[0]))

#define length(x) length_ ## x

#define bless(st0, class, retval) \
    sv_setref_pv(st0 = sv_newmortal(), class, (void*)retval);

// #define SvREF0(arg) \
// 	(SvROK(arg) && SvIOK(SvRV(arg)) && SvIV(SvRV(arg)) == 0)

typedef struct {
	SV* callback;
	union {
		struct trackbar {
			SV* value;
			int pos;
			int lastpos;
		} t;
		struct mouse {
			SV* userdata;
			int pos;
			int lastpos;
		} m;
	} u;
} callback_t;

static void delete_callback(AV* av)
{
	SV* sv;
	while ((sv = av_shift(av)) && sv != &PL_sv_undef) {
		callback_t* callback = INT2PTR(callback_t*, SvIV(sv));
		if (callback) {
			if (callback->callback) SvREFCNT_dec(callback->callback);
			if (callback->u.t.value) SvREFCNT_dec(callback->u.t.value);
			safefree(callback);
		} else {
			croak("callback is 0");
		}
		// SvREFCNT_dec(sv);
	}
	// SvREFCNT_dec((SV*)av);
}

static void delete_all_callback(const char* hash)
{
	HV* hv = get_hv(hash, 0);
	if (hv) { HE* he;
		hv_iterinit(hv);
		while (he = hv_iternext(hv)) {
			SV* sv = hv_iterval(hv, he);
			delete_callback((AV*)SvRV(sv));
		}
		// hv_clear(hv);
		hv_undef(hv);
	}
}

static void delete_win_callback(const char* key, const char* hash)
{
	HV* hv = get_hv(hash, 0);
	if (hv) {
		SV* sv = hv_delete(hv, key, strlen(key), 0);
		if (sv && SvROK(sv) && SvTYPE(SvRV(sv)) == SVt_PVAV) {
			delete_callback((AV*)SvRV(sv));
		}
	}
}

static void cb_trackbar(int pos)
{
	HV* Cv_TRACKBAR = get_hv("Cv::TRACKBAR", 0);
	if (Cv_TRACKBAR) { HE* he;
		hv_iterinit(Cv_TRACKBAR);
		while (he = hv_iternext(Cv_TRACKBAR)) {
			SV* sv = hv_iterval(Cv_TRACKBAR, he);
			AV* av = (AV*)SvRV(sv);
			int i, n = av_len(av);
			for (i = 0; i <= n; i++) {
				SV* sv = *av_fetch(av, i, 0);
				callback_t* p = INT2PTR(callback_t*, SvIV(sv));
				if (p && p->u.t.pos != p->u.t.lastpos) {
					p->u.t.lastpos = p->u.t.pos;
					if (p->u.t.value) sv_setiv(p->u.t.value, p->u.t.pos);
					if (p->callback) {
						dSP;
						ENTER;
						SAVETMPS;
						PUSHMARK(SP);
						XPUSHs(sv_2mortal(newSViv(p->u.t.pos)));
						PUTBACK;
						call_sv(p->callback, G_EVAL|G_DISCARD);
						FREETMPS;
						LEAVE;
					}
				}
			}
		}
	}
}


static void cb_mouse(int event, int x, int y, int flags, VOID* userdata)
{
	callback_t *p = (callback_t*)userdata;
	if (p && p->callback) {
		dSP;
		ENTER;
		SAVETMPS;
		PUSHMARK(SP);
		EXTEND(SP, 5);
		PUSHs(sv_2mortal(newSViv(event)));
		PUSHs(sv_2mortal(newSViv(x)));
		PUSHs(sv_2mortal(newSViv(y)));
		PUSHs(sv_2mortal(newSViv(flags)));
		PUSHs(p->u.m.userdata? p->u.m.userdata : &PL_sv_undef);
		PUTBACK;
		call_sv(p->callback, G_EVAL|G_DISCARD);
		FREETMPS;
		LEAVE;
	}
}


#if _CV_VERSION() >= _VERSION(2,0,0)
#ifdef __cplusplus
void cv::error(const Exception& exc)
{
	SV* handler = get_sv("Cv::ERROR", 0);
	if (handler && SvROK(handler) && SvTYPE(SvRV(handler)) == SVt_PVCV) {
		dSP;
		ENTER;
		SAVETMPS;
		PUSHMARK(SP);
		EXTEND(SP, 5);
		PUSHs(sv_2mortal(newSViv(exc.code)));
		PUSHs(sv_2mortal(newSVpv(exc.func.c_str(), 0)));
		PUSHs(sv_2mortal(newSVpv(exc.err.c_str(), 0)));
		PUSHs(sv_2mortal(newSVpv(exc.file.c_str(), 0)));
		PUSHs(sv_2mortal(newSViv(exc.line)));
		PUTBACK;
		call_sv(handler, G_VOID|G_DISCARD);
		FREETMPS;
		LEAVE;
	} else {
		Perl_croak(aTHX_ "cv::error: can't call Cv::ERROR");
		throw exc;
	}
}
#endif
#endif

static SV *unbless(SV * rv)
{
    SV* sv = SvRV(rv);
    if (SvREADONLY(sv)) croak("%s", PL_no_modify);
    SvREFCNT_dec(SvSTASH(sv));
    SvSTASH(sv) = NULL;
    SvOBJECT_off(sv);
    if (SvTYPE(sv) != SVt_PVIO) PL_sv_objcount--;
    SvAMAGIC_off(rv);
#ifdef SvUNMAGIC
    SvUNMAGIC(sv);
#endif
    return rv;
}

MODULE = Cv::Highgui		PACKAGE = Cv::Highgui		


# ============================================================
#  highgui. High-level GUI and Media I/O: User Interface
# ============================================================

MODULE = Cv::Highgui	PACKAGE = Cv::Arr
# ====================
void
cvConvertImage(const CvArr* src, CvArr* dst, int flags=0)

MODULE = Cv::Highgui	PACKAGE = Cv
int
cvCreateTrackbar(const char* trackbarName, const char* windowName, SV* value, int count, SV* onChange = NULL)
PREINIT:
	callback_t* callback; 
	HV* Cv_TRACKBAR;
	SV** q; AV* av; SV* sv;
INIT:
	if (!(Cv_TRACKBAR = get_hv("Cv::TRACKBAR", 0))) {
		croak("Cv::cvCreateTrackbar: can't get %Cv::TRACKBAR");
	}
	RETVAL = -1;
CODE:
	Newx(callback, 1, callback_t);
	callback->callback = 0;
	if (onChange && SvROK(onChange) && SvTYPE(SvRV(onChange)) == SVt_PVCV) {
		SvREFCNT_inc(callback->callback = (SV*)SvRV(onChange));
	}
	callback->u.t.value = 0;
	callback->u.t.lastpos = callback->u.t.pos = 0;
	if (SvOK(value) && SvTYPE(value) == SVt_IV) {
		SvREFCNT_inc(callback->u.t.value = value);
		callback->u.t.lastpos = callback->u.t.pos = SvIV(value);
	}
	RETVAL = cvCreateTrackbar(trackbarName,	windowName,
				&callback->u.t.pos, count, cb_trackbar);
	q = hv_fetch(Cv_TRACKBAR, windowName, strlen(windowName), 0);
	if (q && SvROK(*q) && SvTYPE(SvRV(*q)) == SVt_PVAV) { SV* sv;
		av = (AV*)SvRV(*q);
		// delete_trackbar(av);
	} else if (!q) {
		av = newAV();
		hv_store(Cv_TRACKBAR, windowName, strlen(windowName),
			newRV_inc(sv_2mortal((SV*)av)), 0);
	} else {
		croak("Cv::cvCreateTrackbar: Cv::TRACKBAR was broken");
	}
	av_push(av, newSViv(PTR2IV(callback)));
OUTPUT:
	RETVAL

void
cvDestroyAllWindows()
CODE:
	cvDestroyAllWindows();
	delete_all_callback("Cv::TRACKBAR");
	delete_all_callback("Cv::MOUSE");


void
cvDestroyWindow(const char* name)
CODE:
	cvDestroyWindow(name);
	delete_win_callback(name, "Cv::TRACKBAR");
	delete_win_callback(name, "Cv::MOUSE");

int
cvGetTrackbarPos(const char* trackbarName, const char* windowName)

CvWindow*
cvGetWindowHandle(const char* name)

MODULE = Cv::Highgui	PACKAGE = Cv
const char*
cvGetWindowName(CvWindow* windowHandle)

#TBD# int cvInitSystem(int argc, char** argv)

int
cvInitSystem(AV* argv)
CODE:
#if !WITH_QT
	XSRETURN_UNDEF;
#endif
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


MODULE = Cv::Highgui	PACKAGE = Cv
void
cvMoveWindow(const char* name, int x, int y)

int
cvNamedWindow(const char* name, int flags = CV_WINDOW_AUTOSIZE)

void
cvResizeWindow(const char* name, int width, int height)

#C# void cvSetMouseCallback(const char* windowName, CvMouseCallback onMouse = NULL, VOID* param=NULL)

void
cvSetMouseCallback(const char* windowName, SV* onMouse = NO_INIT, SV* userdata = NO_INIT)
PREINIT:
	callback_t* callback;
	HV* Cv_MOUSE;
	SV** q; AV* av; SV* sv;
INIT:
	if (items <= 1) onMouse = (SV*)0;
	if (items <= 2) userdata = (SV*)0;
	if (!(Cv_MOUSE = get_hv("Cv::MOUSE", 0))) {
		croak("Cv::cvSetMouseCallback: can't get %Cv::MOUSE");
	}
CODE:
	Newx(callback, 1, callback_t);
	callback->callback = 0;
	if (onMouse && SvROK(onMouse) && SvTYPE(SvRV(onMouse)) == SVt_PVCV) {
		SvREFCNT_inc(callback->callback = (SV*)SvRV(onMouse));
	}
	callback->u.m.userdata = 0;
	if (userdata) {
		SvREFCNT_inc(callback->u.m.userdata = userdata);
	}
	q = hv_fetch(Cv_MOUSE, windowName, strlen(windowName), 0);
	if (q && SvROK(*q) && SvTYPE(SvRV(*q)) == SVt_PVAV) { SV* sv;
		av = (AV*)SvRV(*q);
		cvSetMouseCallback(windowName, NULL, NULL);
		delete_callback(av);
	} else if (!q) {
		av = newAV();
		hv_store(Cv_MOUSE, windowName, strlen(windowName),
			newRV_inc(sv_2mortal((SV*)av)), 0);
	} else {
		croak("Cv::cvSetMouseCallback: Cv::MOUSE was broken");
	}
	if (onMouse) {
		av_push(av, newSViv(PTR2IV(callback)));
		cvSetMouseCallback(windowName, cb_mouse, callback);
	}

void
cvSetTrackbarPos(const char* trackbarName, const char* windowName, int pos)

MODULE = Cv::Highgui	PACKAGE = Cv::Arr
void
cvShowImage(const CvArr* image, const char* name = "Cv", int flags = CV_WINDOW_AUTOSIZE)
CODE:
	CvWindow* win = cvGetWindowHandle(name);
	if (!win) {
		cvNamedWindow(name, flags);
		win = cvGetWindowHandle(name);
	}
	if (win) {
		cvShowImage(name, image);
	}
	XSRETURN(1);

MODULE = Cv::Highgui	PACKAGE = Cv
int
cvWaitKey(int delay=0)

# ============================================================
#  highgui. High-level GUI and Media I/O: Reading and Writing Images and Video
# ============================================================

IplImage*
cvLoadImage(const char* filename, int iscolor=CV_LOAD_IMAGE_COLOR)

CvMat*
cvLoadImageM(const char* filename, int iscolor=CV_LOAD_IMAGE_COLOR)

MODULE = Cv::Highgui	PACKAGE = Cv::Arr
NO_OUTPUT int
cvSaveImage(const CvArr* image, const char* filename, const int* params=0)
CODE:
	RETVAL = cvSaveImage(filename, image
#if _CV_VERSION() >= _VERSION(2,0,0)
		, params
#endif
		);
POSTCALL:
	if (!RETVAL) XSRETURN_UNDEF;
	XSRETURN(1);

#if _CV_VERSION() >= _VERSION(2,0,0)

CvMat*
cvEncodeImage(const CvArr* arr, const char* ext, int* params)
CODE:
    int i = length_params & ~1;
#ifdef __cplusplus
    cv::Mat img = cv::cvarrToMat(arr);
    if (CV_IS_IMAGE(arr) && ((const IplImage*)arr)->origin == IPL_ORIGIN_BL) {
        cv::Mat temp;
        cv::flip(img, temp, 0);
        img = temp;
    }
    cv::vector<uchar> buf;
    bool code = cv::imencode(ext, img, buf,
        i > 0 ? std::vector<int>(params, params + i) : std::vector<int>());
    if (!code) XSRETURN_UNDEF;
    RETVAL = cvCreateMat(1, (int)buf.size(), CV_8U);
    memcpy(RETVAL->data.ptr, &buf[0], buf.size());
#else
	if (params) params[i] = 0;
	RETVAL = cvEncodeImage(ext, arr, params);
#endif
OUTPUT:
	RETVAL

#C# IplImage* cvDecodeImage(const CvMat* buf, int iscolor=CV_LOAD_IMAGE_COLOR)
#C# CvMat* cvDecodeImageM(const CvMat* buf, int iscolor=CV_LOAD_IMAGE_COLOR)

MODULE = Cv::Highgui	PACKAGE = Cv
IplImage*
cvDecodeImage(SV* buf, int iscolor=CV_LOAD_IMAGE_COLOR)
ALIAS: Cv::Arr::cvDecodeImage = 1
INIT:
	RETVAL = (IplImage*)0;
CODE:
	if (SvROK(buf) && sv_isobject(buf) && sv_derived_from(buf, "Cv::Arr")) {
		IV tmp = SvIV((SV*)SvRV(buf));
		const CvArr* arr = INT2PTR(const CvArr*, tmp); CvMat m;
		RETVAL = cvDecodeImage(cvGetMat(arr, &m, NULL, 1), iscolor);
	} else if (SvPOK(buf)) {
		CvMat m; int rows = 1, cols = SvCUR(buf);
		cvInitMatHeader(&m, rows, cols, CV_8UC1, SvPV_nolen(buf), cols);
		RETVAL = cvDecodeImage(&m, iscolor);
	} else {
		if (SvROK(buf))
			croak("unsuported reference SvTYPE = %d\n", SvTYPE(SvRV(buf)));
		else
			croak("unsuported SvTYPE = %d\n", SvTYPE(buf));
	}
OUTPUT:
	RETVAL

CvMat*
cvDecodeImageM(SV* buf, int iscolor=CV_LOAD_IMAGE_COLOR)
ALIAS: Cv::Arr::cvDecodeImageM = 1
INIT:
	RETVAL = (CvMat*)0;
CODE:
	if (SvROK(buf) && sv_isobject(buf) && sv_derived_from(buf, "Cv::Arr")) {
		IV tmp = SvIV((SV*)SvRV(buf));
		const CvArr* arr = INT2PTR(const CvArr*, tmp); CvMat m;
		RETVAL = cvDecodeImageM(cvGetMat(arr, &m, NULL, 1), iscolor);
	} else if (SvPOK(buf)) {
		CvMat m; int rows = 1, cols = SvCUR(buf);
		cvInitMatHeader(&m, rows, cols, CV_8UC1, SvPV_nolen(buf), cols);
		RETVAL = cvDecodeImageM(&m, iscolor);
	} else {
		if (SvROK(buf))
			croak("unsuported reference SvTYPE = %d\n", SvTYPE(SvRV(buf)));
		else
			croak("unsuported SvTYPE = %d\n", SvTYPE(buf));
	}
OUTPUT:
	RETVAL

#endif

MODULE = Cv::Highgui	PACKAGE = Cv
CvCapture*
cvCaptureFromCAM(int index)
ALIAS: cvCreateCameraCapture = 1

CvCapture*
cvCaptureFromFile(const char* filename)
ALIAS: cvCreateFileCapture = 1
ALIAS: cvCaptureFromAVI = 2

MODULE = Cv::Highgui	PACKAGE = Cv::Capture
double
cvGetCaptureProperty(CvCapture* capture, int property_id)

int
cvGrabFrame(CvCapture* capture)

IplImage*
cvQueryFrame(CvCapture* capture)
OUTPUT: RETVAL bless(ST(0), "Cv::Image::Ghost", RETVAL);

void
cvReleaseCapture(CvCapture* &capture)
ALIAS: DESTROY = 1
POSTCALL:
	unbless(ST(0));

IplImage*
cvRetrieveFrame(CvCapture* capture, int streamIdx=0)
CODE:
	cvRetrieveFrame(capture
#if _CV_VERSION() >= _VERSION(2,0,0)
		, streamIdx
#endif
		);
OUTPUT:
	RETVAL bless(ST(0), "Cv::Image::Ghost", RETVAL);

int
cvSetCaptureProperty(CvCapture* capture, int property_id, double value)

MODULE = Cv::Highgui	PACKAGE = Cv
CvVideoWriter*
cvCreateVideoWriter(const char* filename, SV* fourcc, double fps, CvSize frame_size, int is_color=1)
INIT:
	int cc;
	if (SvPOK(fourcc)) {
		char* cp = SvPV_nolen(fourcc);
		cc = CV_FOURCC(cp[0], cp[1], cp[2], cp[3]);
	} else if (SvIOK(fourcc)) {
		cc = SvIV(fourcc);
	} else {
		croak("fourcc: expected \"MJPG\" or CV_FOURCC('M', 'J', 'P', 'G')");
	}
C_ARGS:	filename, cc, fps, frame_size, is_color


MODULE = Cv::Highgui	PACKAGE = Cv::VideoWriter
void
cvReleaseVideoWriter(CvVideoWriter* &writer)
ALIAS: DESTROY = 1
POSTCALL:
	unbless(ST(0));

int
cvWriteFrame(CvVideoWriter* writer, const IplImage* image)

# ============================================================
#  highgui. High-level GUI and Media I/O: Qt new functions
# ============================================================

#if WITH_QT

#if _CV_VERSION() >= _VERSION(2,0,0)

MODULE = Cv::Highgui	PACKAGE = Cv
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
	if (!RETVAL) Perl_croak(aTHX_ "cvFontQt: no core");
	*RETVAL = cvFontQt(nameFont, pointSize, color, weight, style, spacing);
OUTPUT:
	RETVAL

MODULE = Cv::Highgui	PACKAGE = Cv::Arr
void
cvAddText(const CvArr* img, const char* text, CvPoint location, CvFont *font)

MODULE = Cv::Highgui	PACKAGE = Cv
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

#endif /* WITH_QT */

