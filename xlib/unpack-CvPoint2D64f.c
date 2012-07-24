/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvPoint2D64f) for INPUT: */
CvPoint2D64f XS_unpack_CvPoint2D64f(SV* arg)
{
	if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVAV) {
		return cvPoint2D64f(
			SvNV((SV*)(*av_fetch((AV*)SvRV(arg), 0, 0))),
			SvNV((SV*)(*av_fetch((AV*)SvRV(arg), 1, 0)))
			);
	}
	croak("not a CvPoint");
}
