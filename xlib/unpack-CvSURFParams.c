/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvSURFParams) for INPUT: */
CvSURFParams XS_unpack_CvSURFParams(SV* arg)
{
	if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVAV &&
		av_len((AV*)SvRV(arg)) == 3) {
		CvSURFParams surf;
		surf.extended         = SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 0, 0)));
		surf.hessianThreshold = SvNV((SV*)(*av_fetch((AV*)SvRV(arg), 1, 0)));
		surf.nOctaves         = SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 2, 0)));
		surf.nOctaveLayers    = SvIV((SV*)(*av_fetch((AV*)SvRV(arg), 3, 0)));
		return surf;
	}
	croak("not a CvSURFParams");
}
