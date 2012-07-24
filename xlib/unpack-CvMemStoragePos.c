/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvMemStoragePos) for INPUT: */
CvMemStoragePos XS_unpack_CvMemStoragePos(SV* arg)
{
	if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVAV) {
		CvMemStoragePos s;
		s.top = (CvMemBlock*)SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 0, 0)));
		s.free_space = SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 1, 0)));
		return s;
	} else
		croak("not a CvMemStoragePos");
}
