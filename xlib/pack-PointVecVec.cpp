/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

#ifdef __cplusplus
#if CV_MAJOR_VERSION >= 2
void XS_pack_PointVecVec(SV* arg, vector<vector<Point> >& vv)
{
	AV* av_vv = newAV();
	for (int i = 0; i < vv.size(); i++) {
		AV* av_v = newAV();
		for (int j = 0; j < vv[i].size(); j++) {
			AV* av_pt = newAV();
			av_push(av_pt, newSViv(vv[i][j].x));
			av_push(av_pt, newSViv(vv[i][j].y));
			av_push(av_v, newRV_inc(sv_2mortal((SV*)av_pt)));
		}
		av_push(av_vv, newRV_inc(sv_2mortal((SV*)av_v)));
	}
	sv_setsv(arg, sv_2mortal(newRV_inc(sv_2mortal((SV*)av_vv))));
}
#endif
#endif
