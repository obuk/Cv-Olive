/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_AVREF_EXX ((any**) for INPUT: */
int* XS_unpack_lengthPtr(AV* av, int* var, int length_var)
{
	int i;
	for (i = 0; i < length_var; i++) {
		SV* sv_inner = (SV*)(*av_fetch(av, i, 0));
		if (SvROK(sv_inner) && SvTYPE(SvRV(sv_inner)) == SVt_PVAV) {
			AV* av_inner = (AV*)SvRV(sv_inner);
			var[i] = av_len(av_inner) + 1;
		} else
			croak("element is not an AV");
	}
	return var;
}
