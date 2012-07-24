/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvRect) for OUTPUT: */
void XS_pack_CvRect(SV* arg, CvRect var)
{
	AV *av = newAV();
	av_push(av, newSViv(var.x));
	av_push(av, newSViv(var.y));
	av_push(av, newSViv(var.width));
	av_push(av, newSViv(var.height));
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
}
