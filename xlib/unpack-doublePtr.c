/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_AVREF_EX (double*) for INPUT: */
double* XS_unpack_doublePtr(AV* av, double* var, int length_var)
{
	int i;
	for (i = 0; i < length_var; i++) {
		SV* p = (SV*)(*av_fetch(av, i, 0));
        var[i] = SvNV(p);
	}
	return var;
}
