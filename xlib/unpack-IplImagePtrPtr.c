/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_AVREF_EX (IplImage**) for INPUT: */
IplImage** XS_unpack_IplImagePtrPtr(AV* av, IplImage** var, int length_var)
{
	int i;
	for (i = 0; i < length_var; i++) {
		SV* p = (SV*)(*av_fetch(av, i, 0));
		if (SvROK(p) && sv_derived_from(p, "Cv::Image"))
			var[i] = (IplImage*)SvIV((SV*)SvRV(p));
		else if (SvROK(p) && SvIOK(SvRV(p)) && SvIV(SvRV(p)) == 0)
			var[i] = (IplImage*)0;
		else
			croak("element is not derivered from Cv::Image");
	}
	return var;
}
