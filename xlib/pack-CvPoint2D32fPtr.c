/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_AVREF_EX (CvPoint2D32f*) for OUTPUT: */
void XS_pack_CvPoint2D32fPtr(SV* arg, CvPoint2D32f* var, int length_var)
{
	AV* list = (AV*)SvRV(arg); int i;
	av_clear(list);
	for (i = 0; i < length_var; i++) {
		AV* av = newAV();
		av_push(av, newSVnv(var[i].x));
		av_push(av, newSVnv(var[i].y));
		av_push(list, newRV_inc(sv_2mortal((SV*)av)));
	}
}
