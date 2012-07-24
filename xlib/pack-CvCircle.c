/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvCircle) for OUTPUT: */
void XS_pack_CvCircle(SV* arg, CvCircle var)
{
	AV* av = newAV();
	AV* av_center = newAV();
	av_push(av_center, newSVnv(var.center.x));
	av_push(av_center, newSVnv(var.center.y));
	av_push(av, newRV_inc(sv_2mortal((SV*)av_center)));
	av_push(av, newSVnv(var.radius));
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
}
