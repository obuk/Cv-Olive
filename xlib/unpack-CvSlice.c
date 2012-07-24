/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvSlice) for INPUT: */
CvSlice XS_unpack_CvSlice(SV* arg)
{
	if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVAV) {
        AV* av = (AV*)SvRV(arg);
        if (av_len(av) + 1 == 2) {
            return cvSlice(
                SvIV((SV*)(*av_fetch(av, 0, 0))),
                SvIV((SV*)(*av_fetch(av, 1, 0)))
                );
        }
    }
	croak("not a CvSlice");
}
