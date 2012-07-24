/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

#ifdef __cplusplus
#if CV_MAJOR_VERSION >= 2
void XS_pack_floatVec(SV* arg, vector<float>& v)
{
	AV* av_v = newAV();
	for (int i = 0; i < v.size(); i++) {
		av_push(av_v, newSVnv(v[i])); 
	}
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av_v))));
}
#endif
#endif
