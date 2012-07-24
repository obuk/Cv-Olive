/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvTermCriteria) for OUTPUT: */
void XS_pack_CvTermCriteria(SV* arg, CvTermCriteria var)
{
	AV* av = newAV();
	av_push(av, newSViv(var.type));
	av_push(av, newSViv(var.max_iter));
	av_push(av, newSVnv(var.epsilon));
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
}
