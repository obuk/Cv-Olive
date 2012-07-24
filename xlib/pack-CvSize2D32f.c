/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvSize2D32f) for OUTPUT: */
void XS_pack_CvSize2D32f(SV* arg, CvSize2D32f var)
{
	AV* av = newAV();
	av_push(av, newSVnv(var.width));
	av_push(av, newSVnv(var.height));
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
}
