/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvSURFPoint) for OUTPUT: */
void XS_pack_CvSURFPoint(SV* arg, CvSURFPoint var)
{
	AV* av = newAV();
	AV* av_pt = newAV();
	av_push(av_pt, newSVnv(var.pt.x));
	av_push(av_pt, newSVnv(var.pt.y));
	av_push(av, newRV_inc(sv_2mortal((SV*)av_pt)));
	av_push(av, newSViv(var.laplacian));
	av_push(av, newSViv(var.size));
	av_push(av, newSVnv(var.dir));
	av_push(av, newSVnv(var.hessian));
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
}
