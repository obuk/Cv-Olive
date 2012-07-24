/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvPoint) for INPUT: */
CvPoint XS_unpack_CvPoint(SV* arg)
{
	if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVAV) {
		return cvPoint(
			SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 0, 0))),
			SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 1, 0)))
			);
	}
	croak("not a CvPoint");
}
