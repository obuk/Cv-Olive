# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More qw(no_plan);
# use Test::More tests => 17;

# use lib qw(Highgui/blib/lib Highgui/blib/arch);
BEGIN { use_ok('Cv::Highgui') };

# ============================================================
#  highgui. High-level GUI and Media I/O: User Interface
# ============================================================

ok(Cv::Arr->can('cvConvertImage'), "Cv::Arr->can('cvConvertImage')");
ok(Cv->can('cvCreateTrackbar'), "Cv->can('cvCreateTrackbar')");
ok(Cv->can('cvDestroyAllWindows'), "Cv->can('cvDestroyAllWindows')");
ok(Cv->can('cvDestroyWindow'), "Cv->can('cvDestroyWindow')");
ok(Cv->can('cvGetTrackbarPos'), "Cv->can('cvGetTrackbarPos')");
ok(Cv->can('cvGetWindowHandle'), "Cv->can('cvGetWindowHandle')");
ok(Cv->can('cvGetWindowName'), "Cv->can('cvGetWindowName')");
ok(Cv->can('cvInitSystem'), "Cv->can('cvInitSystem')");
ok(Cv->can('cvMoveWindow'), "Cv->can('cvMoveWindow')");
ok(Cv->can('cvNamedWindow'), "Cv->can('cvNamedWindow')");
ok(Cv->can('cvResizeWindow'), "Cv->can('cvResizeWindow')");
ok(Cv->can('cvSetMouseCallback'), "Cv->can('cvSetMouseCallback')");
ok(Cv->can('cvSetTrackbarPos'), "Cv->can('cvSetTrackbarPos')");
ok(Cv::Arr->can('cvShowImage'), "Cv::Arr->can('cvShowImage')");
ok(Cv->can('cvWaitKey'), "Cv->can('cvWaitKey')");

# ============================================================
#  highgui. High-level GUI and Media I/O: Reading and Writing Images and Video
# ============================================================

ok(Cv->can('cvLoadImage'), "Cv->can('cvLoadImage')");
ok(Cv->can('cvLoadImageM'), "Cv->can('cvLoadImageM')");
ok(Cv::Arr->can('cvSaveImage'), "Cv::Arr->can('cvSaveImage')");
ok(Cv->can('cvCaptureFromCAM'), "Cv->can('cvCaptureFromCAM')");
ok(Cv->can('cvCaptureFromFile'), "Cv->can('cvCaptureFromFile')");
ok(Cv::Capture->can('cvGetCaptureProperty'), "Cv::Capture->can('cvGetCaptureProperty')");
ok(Cv::Capture->can('cvGrabFrame'), "Cv::Capture->can('cvGrabFrame')");
ok(Cv::Capture->can('cvQueryFrame'), "Cv::Capture->can('cvQueryFrame')");
ok(Cv::Capture->can('cvReleaseCapture'), "Cv::Capture->can('cvReleaseCapture')");
ok(Cv::Capture->can('cvRetrieveFrame'), "Cv::Capture->can('cvRetrieveFrame')");
ok(Cv::Capture->can('cvSetCaptureProperty'), "Cv::Capture->can('cvSetCaptureProperty')");
ok(Cv->can('cvCreateVideoWriter'), "Cv->can('cvCreateVideoWriter')");
ok(Cv::VideoWriter->can('cvReleaseVideoWriter'), "Cv::VideoWriter->can('cvReleaseVideoWriter')");
ok(Cv::VideoWriter->can('cvWriteFrame'), "Cv::VideoWriter->can('cvWriteFrame')");


# ============================================================
#  highgui. High-level GUI and Media I/O: Qt new functions
# ============================================================

SKIP: {
      skip "todo", 8;

      skip "version 2.0.0+", 8 unless cvVersion() >= 2.0;
      skip "has Qt", 8 unless Cv->hasQt;

      ok(Cv->can('cvSetWindowProperty'), "Cv->can('cvSetWindowProperty')");
      ok(Cv->can('cvGetWindowProperty'), "Cv->can('cvGetWindowProperty')");

      skip "version 2.2.0+", 6 unless cvVersion() >= 2.002;

      ok(Cv->can('cvFontQt'), "Cv->can('cvFontQt')");
      ok(Cv->can('cvAddText'), "Cv->can('cvAddText')");
      ok(Cv->can('cvDisplayOverlay'), "Cv->can('cvDisplayOverlay')");
      ok(Cv->can('cvDisplayStatusBar'), "Cv->can('cvDisplayStatusBar')");
      # ok(Cv->can('cvCreateOpenGLCallback'), "Cv->can('cvCreateOpenGLCallback')");
      ok(Cv->can('cvSaveWindowParameters'), "Cv->can('cvSaveWindowParameters')");
      ok(Cv->can('cvLoadWindowParameters'), "Cv->can('cvLoadWindowParameters')");
      # ok(Cv->can('cvCreateButton'), "Cv->can('cvCreateButton')");

}
