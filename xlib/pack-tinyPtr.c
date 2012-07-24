/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#include "xs.h"

/* T_AVREF_EX (tiny*) for OUTPUT: */
void XS_pack_tinyPtr(SV* arg, tiny* var, int length_var)
{
	AV* list = (AV*)SvRV(arg); int i;
	av_clear(list);
	for (i = 0; i < length_var; i++) {
		av_push(list, newSViv(var[i]));
	}
}
