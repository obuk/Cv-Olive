/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvSize) for OUTPUT: */
void XS_pack_CvSize(SV* arg, CvSize var)
{
	AV* av = newAV();
	av_push(av, newSViv(var.width));
	av_push(av, newSViv(var.height));
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
}
