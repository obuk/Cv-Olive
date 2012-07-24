/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvTermCriteria) for INPUT: */
CvTermCriteria XS_unpack_CvTermCriteria(SV* arg)
{
	if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVAV) {
		int n = av_len((AV*)SvRV(arg)) + 1;
		return cvTermCriteria(
			n >= 1 ? SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 0, 0))) : 0,
			n >= 2 ? SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 1, 0))) : 0,
			n >= 3 ? SvNV((SV*)(*av_fetch((AV*)SvRV(arg), 2, 0))) : 0
			);
	}
	croak("not a CvTermCriteria");
}
