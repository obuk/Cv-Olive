/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvString) for OUTPUT: */
void XS_pack_CvString(SV* arg, CvString var)
{
	AV* av = newAV();
	av_push(av, newSViv(var.len));
	av_push(av, newSViv((IV)var.ptr));
	SV* sv = sv_2mortal(newRV_inc(sv_2mortal((SV*)av)));
	sv_setsv(arg, sv_bless(sv, gv_stashpv("Cv::String", 1)));
}
