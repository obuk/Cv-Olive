/* -*- mode: text; coding: utf-8; tab-width: 4 -*- */

#include "Cv.inc"

static int HvIV(HV* hv, const char* name, int value)
{
	SV** p = hv_fetch(hv, name, strlen(name), 0);
	if (p) value = SvIV(*p);
	return value;
}

static double HvNV(HV* hv, const char* name, double value)
{
	SV** p = hv_fetch(hv, name, strlen(name), 0);
	if (p) value = SvNV(*p);
	return value;
}

MODULE = Cv::MSER		PACKAGE = Cv::MSER

# ============================================================
#  features2d. 2D Features Framework
# ============================================================

#if _CV_VERSION() >= _VERSION(2,0,0)

AV*
detect(SV* self, CvArr* image, CvArr* mask = NULL)
CODE:
	MSER mser;
	if (SvROK(self) && SvTYPE(SvRV(self))) {
		HV* hv_self = (HV*)SvRV(self);
		int    delta          = HvIV(hv_self, "delta"        , 5     );
		int    minArea        = HvIV(hv_self, "minArea"      , 60    );
		int    maxArea        = HvIV(hv_self, "maxArea"      , 14400 );
		float  maxVariation   = HvNV(hv_self, "maxVariation" , 0.25  );
		float  minDiversity   = HvNV(hv_self, "minDiversity" , 0.2   );
		int    maxEvolution   = HvIV(hv_self, "maxEvolution" , 200   );
		double areaThreshold  = HvNV(hv_self, "areaThreshold", 1.01  );
		double minMargin      = HvNV(hv_self, "minMargin"    , 0.003 );
		int    edgeBlurSize   = HvIV(hv_self, "edgeBlurSize" , 5     );
		mser = MSER(
				delta, minArea, maxArea, maxVariation, minDiversity,
				maxEvolution, areaThreshold, minMargin, edgeBlurSize
				);
	} else {
		Perl_croak(aTHX_ "%s is not of type hashref in %s",
			"self", "Cv::MSER::detect");
	}
	cv::Mat _image = cv::cvarrToMat(image);
	vector<vector<Point> > _contours;
	if (mask) {
		cv::Mat _mask = cv::cvarrToMat(mask);
		mser(_image, _contours, _mask);
	} else {
		mser(_image, _contours);
	}
	RETVAL = newAV();
	for (int i = (int)_contours.size() - 1; i >= 0; i--) {
		const vector<Point>& r = _contours[i];
		AV* av_pts = newAV();
		for (int j = 0; j < (int)r.size(); j++) {
			AV* av = newAV();
			av_push(av, newSViv(r[j].x));
			av_push(av, newSViv(r[j].y));
			av_push(av_pts, newRV_inc(sv_2mortal((SV*)av)));
		}
		av_push(RETVAL, newRV_inc(sv_2mortal((SV*)av_pts)));
	}
OUTPUT:
	RETVAL

#endif
