/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvSURFParams) for OUTPUT: */
void XS_pack_CvSURFParams(SV* arg, CvSURFParams var)
{
	AV* av = newAV();
	av_push(av, newSViv(var.extended));
	av_push(av, newSVnv(var.hessianThreshold));
	av_push(av, newSViv(var.nOctaves));
	av_push(av, newSViv(var.nOctaveLayers));
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
}
