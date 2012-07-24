/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvConnectedComp) for OUTPUT: */
void XS_pack_CvConnectedComp(SV* arg, CvConnectedComp var)
{
	AV *av = newAV();
	av_push(av, newSVnv(var.area));
	AV *av_value = newAV();
	av_push(av_value, newSVnv(var.value.val[0]));
	av_push(av_value, newSVnv(var.value.val[1]));
	av_push(av_value, newSVnv(var.value.val[2]));
	av_push(av_value, newSVnv(var.value.val[3]));
	av_push(av, newRV_inc(sv_2mortal((SV*)av_value)));
	AV *av_rect = newAV();
	av_push(av_rect, newSViv(var.rect.x));
	av_push(av_rect, newSViv(var.rect.y));
	av_push(av_rect, newSViv(var.rect.width));
	av_push(av_rect, newSViv(var.rect.height));
	av_push(av, newRV_inc(sv_2mortal((SV*)av_rect)));
	av_push(av, newSViv((IV)var.contour));
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
}
