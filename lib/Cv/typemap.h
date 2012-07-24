/* -*- mode: c; coding: utf-8; tab-width: 4; -*- */

#ifndef __typemap_h
#define __typemap_h 1

typedef char tiny;
typedef struct CvCircle {
	CvPoint2D32f center;
	float radius;
} CvCircle;

#define decl_T_PACKED(_type) \
_type XS_unpack_ ## _type(SV* arg); \
void XS_pack_ ## _type(SV* arg, _type var);

decl_T_PACKED(CvPoint)
decl_T_PACKED(CvPoint2D32f)
decl_T_PACKED(CvPoint2D64f)
decl_T_PACKED(CvPoint3D32f)
decl_T_PACKED(CvPoint3D64f)
decl_T_PACKED(CvRect)
decl_T_PACKED(CvScalar)
decl_T_PACKED(CvSize)
decl_T_PACKED(CvSize2D32f)
decl_T_PACKED(CvBox2D)
decl_T_PACKED(CvSlice)
decl_T_PACKED(CvString)
decl_T_PACKED(CvTermCriteria)
decl_T_PACKED(CvConnectedComp)
decl_T_PACKED(CvSubdiv2DPoint)
decl_T_PACKED(CvSURFParams)
decl_T_PACKED(CvSURFPoint)
decl_T_PACKED(CvMemStoragePos)
decl_T_PACKED(CvCircle)

#if CV_MAJOR_VERSION >= 2
decl_T_PACKED(CvMSERParams)
#endif

#define decl_T_PACKED_EX(_type, _typename)    \
_type XS_unpack_ ## _typename(AV* arg, _type var, int len); \
void XS_pack_ ## _typename(SV* arg, _type var, int len);

decl_T_PACKED_EX(tiny*, tinyPtr)
decl_T_PACKED_EX(int*, intPtr)
decl_T_PACKED_EX(float*, floatPtr)
decl_T_PACKED_EX(double*, doublePtr)
decl_T_PACKED_EX(CvPoint*, CvPointPtr)
decl_T_PACKED_EX(CvPoint2D32f*, CvPoint2D32fPtr)
decl_T_PACKED_EX(CvPoint2D64f*, CvPoint2D64fPtr)
decl_T_PACKED_EX(CvPoint3D32f*, CvPoint3D32fPtr)
decl_T_PACKED_EX(CvPoint3D64f*, CvPoint3D64fPtr)
decl_T_PACKED_EX(CvSubdiv2DPoint*, CvSubdiv2DPointPtr)

decl_T_PACKED_EX(int*, lengthPtr)
decl_T_PACKED_EX(CvArr**, CvArrPtrPtr)
decl_T_PACKED_EX(IplImage**, IplImagePtrPtr)

#ifdef __cplusplus
#if CV_MAJOR_VERSION >= 2
using namespace cv;
using namespace std;
void XS_pack_floatVec(SV* arg, vector<float>& vec);
void XS_pack_PointVecVec(SV* arg, vector<vector<Point> >& points);
void XS_pack_KeyPointVec(SV* arg, vector<KeyPoint>& keypoints);
#endif
#endif
#endif
