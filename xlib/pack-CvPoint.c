/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvPoint) for OUTPUT: */
void XS_pack_CvPoint(SV* arg, CvPoint var)
{
	AV *av = newAV();
	av_push(av, newSViv(var.x));
	av_push(av, newSViv(var.y));
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
}
