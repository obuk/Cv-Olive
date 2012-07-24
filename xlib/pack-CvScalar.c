/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_PACKED (CvScalar) for OUTPUT: */
void XS_pack_CvScalar(SV* arg, CvScalar var)
{
    // ignore \0
    if (SvROK(arg) && (SvTYPE(arg) == SVt_IV || SvTYPE(arg) == SVt_NV))
        return;
    else {
        AV* av = newAV();
        av_push(av, newSVnv(var.val[0]));
        av_push(av, newSVnv(var.val[1]));
        av_push(av, newSVnv(var.val[2]));
        av_push(av, newSVnv(var.val[3]));
        sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av))));
    }
}
