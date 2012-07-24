/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvRect) for INPUT: */
CvRect XS_unpack_CvRect(SV* arg)
{
	if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVAV) {
		return cvRect(
			SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 0, 0))),
			SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 1, 0))),
			SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 2, 0))),
			SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 3, 0)))
			);
	}
	croak("not a CvRect");
}
