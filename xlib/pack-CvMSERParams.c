/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

#if CV_MAJOR_VERSION >= 2

/* T_PACKED (CvMSERParams) for OUTPUT: */
void XS_pack_CvMSERParams(SV* arg, CvMSERParams var)
{
	AV* av = newAV();
	av_push(av, newSViv(var.delta));
	av_push(av, newSViv(var.maxArea));
	av_push(av, newSViv(var.minArea));
	av_push(av, newSVnv(var.maxVariation));
	av_push(av, newSVnv(var.minDiversity));
	av_push(av, newSViv(var.maxEvolution));
	av_push(av, newSVnv(var.areaThreshold));
	av_push(av, newSVnv(var.minMargin));
	av_push(av, newSViv(var.edgeBlurSize));
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
}

#endif
