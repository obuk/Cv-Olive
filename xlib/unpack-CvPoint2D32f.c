/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvPoint2D32f) for INPUT: */
CvPoint2D32f XS_unpack_CvPoint2D32f(SV* arg)
{
	if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVAV) {
		return cvPoint2D32f(
			SvNV((SV*)(*av_fetch((AV*)SvRV(arg), 0, 0))),
			SvNV((SV*)(*av_fetch((AV*)SvRV(arg), 1, 0)))
			);
	}
	croak("not a CvPoint");
}
