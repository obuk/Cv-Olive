/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvMemStoragePos) for OUTPUT: */
void XS_pack_CvMemStoragePos(SV* arg, CvMemStoragePos var)
{
	AV* av = newAV();
	av_push(av, newSViv((IV)var.top));
	av_push(av, newSViv(var.free_space));
	SV* sv = sv_2mortal(newRV_inc(sv_2mortal((SV*)av)));
	sv_setsv(arg, sv_bless(sv, gv_stashpv("Cv::MemStoragePos", 1)));
}
