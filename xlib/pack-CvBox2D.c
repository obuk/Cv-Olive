/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvBox2D) for OUTPUT: */
void XS_pack_CvBox2D(SV* arg, CvBox2D var)
{
	AV* av = newAV();
	AV* av_center = newAV();
	av_push(av_center, newSVnv(var.center.x));
	av_push(av_center, newSVnv(var.center.y));
	av_push(av, newRV_inc(sv_2mortal((SV*)av_center)));
	AV* av_size = newAV();
	av_push(av_size, newSVnv(var.size.width));
	av_push(av_size, newSVnv(var.size.height));
	av_push(av, newRV_inc(sv_2mortal((SV*)av_size)));
	av_push(av, newSVnv(var.angle));
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
}
