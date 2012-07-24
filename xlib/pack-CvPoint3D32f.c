/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvPoint3D32f) for OUTPUT: */
void XS_pack_CvPoint3D32f(SV* arg, CvPoint3D32f var)
{
	AV *av = newAV();
	av_push(av, newSVnv(var.x));
	av_push(av, newSVnv(var.y));
	av_push(av, newSVnv(var.z));
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
}
