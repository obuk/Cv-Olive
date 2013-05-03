/* -*- mode: text; coding: utf-8; tab-width: 4 -*- */

#include "Cv.inc"

MODULE = Cv::Qt		PACKAGE = Cv::Qt

# ============================================================
#  highgui. High-level GUI and Media I/O: Qt new functions
# ============================================================

#if _CV_VERSION() >= _VERSION(2,0,0)

void
cvSetWindowProperty(const char* name, int prop_id, double prop_value)

double
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
