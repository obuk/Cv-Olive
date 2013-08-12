/* -*- mode: text; coding: utf-8; tab-width: 4 -*- */

#include "Cv.inc"

#ifndef CV_Error
#define CV_Error(code, msg) cvError(code, msg, __func__, __FILE__, __LINE__)
#endif

#define nonzero_(elem_t)	{											\
	RETVAL = newAV();													\
	int sizes[CV_MAX_DIM];												\
	int dims = cvGetDims(arr, sizes);									\
	if (dims == 1) {													\
		int i;															\
		elem_t* line = (elem_t*)cvPtr1D(arr, 0, NULL);					\
		for (i = 0; i < sizes[0]; i++) {								\
			if (line[i]) {												\
				AV* pt = newAV();										\
				av_push(pt, newSViv(i));								\
				av_push(RETVAL, newRV_inc(sv_2mortal((SV*)pt)));		\
			}															\
		}																\
	} else if (dims == 2) {												\
		int i, j;														\
		for (j = 0; j < sizes[0]; j++) {								\
			elem_t* line = (elem_t*)cvPtr2D(arr, j, 0, NULL);			\
			for (i = 0; i < sizes[1]; i++) {							\
				if (line[i]) {											\
					AV* pt = newAV();									\
					if (reverse) {										\
						av_push(pt, newSViv(j));						\
						av_push(pt, newSViv(i));						\
					} else {											\
						av_push(pt, newSViv(i));						\
						av_push(pt, newSViv(j));						\
					}													\
					av_push(RETVAL, newRV_inc(sv_2mortal((SV*)pt)));	\
				}														\
			}															\
		}																\
	} else if (dims == 3) {												\
		int i, j, k;													\
		for (k = 0; k < sizes[0]; k++) {								\
			for (j = 0; j < sizes[1]; j++) {							\
				elem_t* line = (elem_t*)cvPtr3D(arr, k, j, 0, NULL);	\
				for (i = 0; i < sizes[2]; i++) {						\
					if (line[i]) {										\
						AV* pt = newAV();								\
						if (reverse) {									\
							av_push(pt, newSViv(k));					\
							av_push(pt, newSViv(j));					\
							av_push(pt, newSViv(i));					\
						} else {										\
							av_push(pt, newSViv(i));					\
							av_push(pt, newSViv(j));					\
							av_push(pt, newSViv(k));					\
						}												\
						av_push(RETVAL, newRV_inc(sv_2mortal((SV*)pt)));\
					}													\
				}														\
			}															\
		}																\
	} else {															\
		CV_Error(CV_StsUnsupportedFormat, "nr of arr dims expected 1..3");\
	}																	\
}

static AV*
nonzero(CvArr* arr, int reverse)
{
	AV* RETVAL;
	int type = cvGetElemType(arr);
	if (CV_IS_SPARSE_MAT_HDR(arr))
		CV_Error(CV_StsBadArg, "Sparse array is not supported");
	if (CV_MAT_CN(type) != 1)
        CV_Error(CV_StsUnsupportedFormat, "The number of channels must be 1");
	switch (CV_MAT_DEPTH(type)) {
	case CV_8U:
	case CV_8S:
		nonzero_(char);
		break;
	case CV_16U:
	case CV_16S:
		nonzero_(short);
		break;
	case CV_32S:
		nonzero_(int);
		break;
	case CV_32F:
		nonzero_(float);
		break;
	case CV_64F:
		nonzero_(double);
		break;
	default:
		CV_Error(CV_StsUnsupportedFormat, "unknown type of element");
		break;
	}
	return RETVAL;
}

MODULE = Cv::More		PACKAGE = Cv::More

void
nonzero(CvArr *arr, int reverse = 0)
ALIAS:	Cv::Arr::nonzero = 1
PPCODE:
	const int verbose = 0;
	AV* av = nonzero(arr, reverse);
	if (av) {
		I32 gimme = GIMME_V; /* wantarray */
		if (gimme == G_VOID) {
			if (verbose) fprintf(stderr, "Context is Void\n");
		} else if (gimme == G_SCALAR) {
			if (verbose) fprintf(stderr, "Context is Scalar\n");
			XPUSHs(sv_2mortal(newSViv(av_len(av) + 1)));
		} else if (gimme == G_ARRAY) {
			SV* sv;
			if (verbose) fprintf(stderr, "Context is Array\n");
			EXTEND(SP, av_len(av) + 1);
			while ((sv = av_shift(av)) && sv != &PL_sv_undef) {
				PUSHs(sv);
			}
		}
		sv_2mortal((SV*)av);
	}
