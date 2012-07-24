/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvSubdiv2DPoint) for INPUT: */
CvSubdiv2DPoint XS_unpack_CvSubdiv2DPoint(SV* arg)
{
	if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVAV) {
		CvSubdiv2DPoint pt;
		pt.flags = SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 0, 0)));
		pt.first = SvUV((SV*)(*av_fetch((AV*)SvRV(arg), 1, 0)));
		SV* sv   =      (SV*)(*av_fetch((AV*)SvRV(arg), 2, 0));
		pt.pt    = XS_unpack_CvPoint2D32f(sv);
#if CV_MAJOR_VERSION >= 2
		pt.id    = SvNV((SV*)(*av_fetch((AV*)SvRV(arg), 3, 0)));
#endif
		return pt;
	}
	croak("not a CvPoint");
}
