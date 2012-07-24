/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvSlice) for OUTPUT: */
void XS_pack_CvSlice(SV* arg, CvSlice var)
{
	AV* av = newAV();
	av_push(av, newSViv(var.start_index));
	av_push(av, newSViv(var.end_index));
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
}
