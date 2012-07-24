/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_AVREF_EX (CvPoint*) for INPUT: */
CvPoint* XS_unpack_CvPointPtr(AV* av, CvPoint* var, int length_var)
{
	int i;
	for (i = 0; i < length_var; i++) {
		SV* p = (SV*)(*av_fetch(av, i, 0));
		if (SvROK(p) && SvTYPE(SvRV(p)) == SVt_PVAV)
			var[i] = cvPoint(
				SvIV((SV*)(*av_fetch((AV*)SvRV(p), 0, 0))),
				SvIV((SV*)(*av_fetch((AV*)SvRV(p), 1, 0)))
				);
		else
			croak("element is not an array reference");
	}
	return var;
}
