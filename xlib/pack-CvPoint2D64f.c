/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvPoint2D64f) for OUTPUT: */
void XS_pack_CvPoint2D64f(SV* arg, CvPoint2D64f var)
{
	AV *av = newAV();
	av_push(av, newSVnv(var.x));
	av_push(av, newSVnv(var.y));
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
}
