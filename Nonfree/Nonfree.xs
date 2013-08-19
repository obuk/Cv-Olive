/* -*- mode: text; coding: utf-8; tab-width: 4 -*- */

#include "Cv.inc"

#if _CV_VERSION() >= _VERSION(2,4,0)
#ifdef __cplusplus                                                      // XXXXX
#  include "opencv2/nonfree/nonfree.hpp"                                // XXXXX
#endif                                                                  // XXXXX
#endif

MODULE = Cv::Nonfree		PACKAGE = Cv::Nonfree

# ============================================================
#  nonfree. Non-free functionality
# ============================================================

BOOT:
#if _CV_VERSION() >= _VERSION(2,4,0)
#ifdef __cplusplus                                                      // XXXXX
	initModule_nonfree();                                               // XXXXX
#endif                                                                  // XXXXX
#endif
