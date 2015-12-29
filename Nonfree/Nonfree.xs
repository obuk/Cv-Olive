/* -*- mode: text; coding: utf-8; tab-width: 4 -*- */

#include "Cv.inc"

MODULE = Cv::Nonfree		PACKAGE = Cv::Nonfree

# ============================================================
#  nonfree. Non-free functionality
# ============================================================

BOOT:
#ifdef HAVE_OPENCV_NONFREE
	initModule_nonfree();
#endif
