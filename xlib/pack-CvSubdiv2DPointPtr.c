/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* not typemaped (CvPoint2D32f*) for OUTPUT: */
void XS_pack_CvSubdiv2DPointPtr(SV* arg, CvSubdiv2DPoint* var, int length_var)
{
	AV* list = (AV*)SvRV(arg); int i;
	av_clear(list);
	for (i = 0; i < length_var; i++) {
		AV* av = newAV();
		av_push(av, newSViv(var[i].flags));
		av_push(av, newSVuv(var[i].first));
		AV* av_pt = newAV();
		av_push(av_pt, newSVnv(var[i].pt.x));
		av_push(av_pt, newSVnv(var[i].pt.y));
		av_push(av, newRV_inc(sv_2mortal((SV*)av_pt)));
#if CV_MAJOR_VERSION == 2
		av_push(av, newSViv(var[i].id));
#endif
		av_push(list, newRV_inc(sv_2mortal((SV*)av)));
	}
}
