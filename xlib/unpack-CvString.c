/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvString) for INPUT: */
CvString XS_unpack_CvString(SV* arg)
{
	if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVAV) {
		CvString s;
		s.len = SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 0, 0)));
		s.ptr = (char*)SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 1, 0)));
		return s;
	}
	croak("not a CvString");
}
