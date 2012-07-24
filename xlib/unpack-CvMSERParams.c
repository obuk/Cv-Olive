/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

#if CV_MAJOR_VERSION == 2

/* T_PACKED (CvMSERParams) for INPUT: */
CvMSERParams XS_unpack_CvMSERParams(SV* arg)
{
	if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVAV &&
		av_len((AV*)SvRV(arg)) == 8) {
		CvMSERParams mser;
		mser.delta         = SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 0, 0)));
		mser.maxArea       = SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 1, 0)));
		mser.minArea       = SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 2, 0)));
		mser.maxVariation  = SvNV((SV*)(*av_fetch((AV*)SvRV(arg), 3, 0)));
		mser.minDiversity  = SvNV((SV*)(*av_fetch((AV*)SvRV(arg), 4, 0)));
		mser.maxEvolution  = SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 5, 0)));
		mser.areaThreshold = SvNV((SV*)(*av_fetch((AV*)SvRV(arg), 6, 0)));
		mser.minMargin     = SvNV((SV*)(*av_fetch((AV*)SvRV(arg), 7, 0)));
		mser.edgeBlurSize  = SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 8, 0)));
		return mser;
	}
	croak("not a CvMSERParams");
}

#endif
