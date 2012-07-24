/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvSubdiv2DPoint) for OUTPUT: */
void XS_pack_CvSubdiv2DPoint(SV* arg, CvSubdiv2DPoint var)
{
	AV* av = newAV();
	av_push(av, newSViv(var.flags));
	av_push(av, newSVuv(var.first));
	AV* av_pt = newAV();
	av_push(av_pt, newSVnv(var.pt.x));
	av_push(av_pt, newSVnv(var.pt.y));
	av_push(av, newRV_inc(sv_2mortal((SV*)av_pt)));
#if CV_MAJOR_VERSION == 2
    av_push(av, newSViv(var.id));
#endif
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
}
