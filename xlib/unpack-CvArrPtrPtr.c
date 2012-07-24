/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_AVREF_EX (CvArr**) for INPUT: */
CvArr** XS_unpack_CvArrPtrPtr(AV* av, CvArr** var, int length_var)
{
	int i;
	for (i = 0; i < length_var; i++) {
		SV* p = (SV*)(*av_fetch(av, i, 0));
		if (SvROK(p) && sv_derived_from(p, "Cv::Arr"))
			var[i] = (CvArr*)SvIV((SV*)SvRV(p));
		else if (SvROK(p) && SvIOK(SvRV(p)) && SvIV(SvRV(p)) == 0)
			var[i] = (CvArr*)0;
		else
			croak("element is not derivered from Cv::Arr");
	}
	return var;
}
