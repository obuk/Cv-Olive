/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_AVREF_EX (int*) for INPUT: */
int* XS_unpack_intPtr(AV* av, int* var, int length_var)
{
	int i;
	for (i = 0; i < length_var; i++) {
		SV* p = (SV*)(*av_fetch(av, i, 0));
        var[i] = SvIV(p);
	}
	return var;
}
