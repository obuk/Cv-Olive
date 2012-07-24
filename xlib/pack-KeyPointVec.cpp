/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

#ifdef __cplusplus
#if CV_MAJOR_VERSION >= 2
void XS_pack_KeyPointVec(SV* arg, vector<KeyPoint>& v)
{
	AV* av_v = newAV();
	for (int i = 0; i < v.size(); i++) {
        AV* av_kp = newAV();
        AV* av_pt = newAV();
        av_push(av_pt, newSVnv(v[i].pt.x));
        av_push(av_pt, newSVnv(v[i].pt.y));
        av_push(av_kp, newRV_inc(sv_2mortal((SV*)av_pt)));
        av_push(av_kp, newSVnv(v[i].size));
        av_push(av_kp, newSVnv(v[i].angle));
        av_push(av_kp, newSVnv(v[i].response));
        av_push(av_kp, newSViv(v[i].octave));
        av_push(av_kp, newSViv(v[i].class_id));
		av_push(av_v, newRV_inc(sv_2mortal((SV*)av_kp)));
	}
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av_v))));
}
#endif
#endif
