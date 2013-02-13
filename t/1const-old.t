# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
use Test::More qw(no_plan);
# use Test::More tests => 425;

BEGIN {
	use_ok('Cv', -nomore);
}


our %OLD_CONST = (
    1.001 => [qw(

CV_16S
CV_16SC1
CV_16SC2
CV_16SC3
CV_16SC4
CV_16U
CV_16UC1
CV_16UC2
CV_16UC3
CV_16UC4
CV_32F
CV_32FC1
CV_32FC2
CV_32FC3
CV_32FC4
CV_32S
CV_32SC1
CV_32SC2
CV_32SC3
CV_32SC4
CV_64F
CV_64FC1
CV_64FC2
CV_64FC3
CV_64FC4
CV_8S
CV_8SC1
CV_8SC2
CV_8SC3
CV_8SC4
CV_8U
CV_8UC1
CV_8UC2
CV_8UC3
CV_8UC4
CV_AA
CV_ADAPTIVE_THRESH_GAUSSIAN_C
CV_ADAPTIVE_THRESH_MEAN_C
CV_BGR2BGR555
CV_BGR2BGR565
CV_BGR2BGRA
CV_BGR2GRAY
CV_BGR2HLS
CV_BGR2HSV
CV_BGR2Lab
CV_BGR2RGB
CV_BGR2RGBA
CV_BGR2XYZ
CV_BGR2YCrCb
CV_BGR5552BGR
CV_BGR5552BGRA
CV_BGR5552GRAY
CV_BGR5552RGB
CV_BGR5552RGBA
CV_BGR5652BGR
CV_BGR5652BGRA
CV_BGR5652GRAY
CV_BGR5652RGB
CV_BGR5652RGBA
CV_BGRA2BGR
CV_BGRA2BGR555
CV_BGRA2BGR565
CV_BGRA2GRAY
CV_BGRA2RGB
CV_BGRA2RGBA
CV_BILATERAL
CV_BLUR
CV_BLUR_NO_SCALE
CV_BayerBG2BGR
CV_BayerBG2RGB
CV_BayerGB2BGR
CV_BayerGB2RGB
CV_BayerGR2BGR
CV_BayerGR2RGB
CV_BayerRG2BGR
CV_BayerRG2RGB
CV_CALIB_CB_ADAPTIVE_THRESH
CV_CALIB_CB_FILTER_QUADS
CV_CALIB_CB_NORMALIZE_IMAGE
CV_CALIB_FIX_ASPECT_RATIO
CV_CALIB_FIX_K1
CV_CALIB_FIX_K2
CV_CALIB_FIX_K3
CV_CALIB_FIX_PRINCIPAL_POINT
CV_CALIB_SAME_FOCAL_LENGTH
CV_CALIB_USE_INTRINSIC_GUESS
CV_CALIB_ZERO_TANGENT_DIST
CV_CAP_PROP_BRIGHTNESS
CV_CAP_PROP_CONTRAST
CV_CAP_PROP_CONVERT_RGB
CV_CAP_PROP_FORMAT
CV_CAP_PROP_FOURCC
CV_CAP_PROP_FPS
CV_CAP_PROP_FRAME_COUNT
CV_CAP_PROP_FRAME_HEIGHT
CV_CAP_PROP_FRAME_WIDTH
CV_CAP_PROP_GAIN
CV_CAP_PROP_HUE
CV_CAP_PROP_MODE
CV_CAP_PROP_POS_AVI_RATIO
CV_CAP_PROP_POS_FRAMES
CV_CAP_PROP_POS_MSEC
CV_CAP_PROP_SATURATION
CV_CHAIN_APPROX_NONE
CV_CHAIN_APPROX_SIMPLE
CV_CHAIN_APPROX_TC89_KCOS
CV_CHAIN_APPROX_TC89_L1
CV_CHAIN_CODE
CV_CMP_EQ
CV_CMP_GE
CV_CMP_GT
CV_CMP_LE
CV_CMP_LT
CV_CMP_NE
CV_CN_SHIFT
CV_COMP_BHATTACHARYYA
CV_COMP_CHISQR
CV_COMP_CORREL
CV_COMP_INTERSECT
CV_COVAR_COLS
CV_COVAR_NORMAL
CV_COVAR_ROWS
CV_COVAR_SCALE
CV_COVAR_SCRAMBLED
CV_COVAR_USE_AVG
CV_DIST_C
CV_DIST_L1
CV_DIST_L2
CV_DIST_MASK_3
CV_DIST_MASK_5
CV_DIST_MASK_PRECISE
CV_DXT_FORWARD
CV_DXT_INVERSE
CV_DXT_INVERSE_SCALE
CV_DXT_ROWS
CV_DXT_SCALE
CV_EVENT_FLAG_ALTKEY
CV_EVENT_FLAG_CTRLKEY
CV_EVENT_FLAG_LBUTTON
CV_EVENT_FLAG_MBUTTON
CV_EVENT_FLAG_RBUTTON
CV_EVENT_FLAG_SHIFTKEY
CV_EVENT_LBUTTONDBLCLK
CV_EVENT_LBUTTONDOWN
CV_EVENT_LBUTTONUP
CV_EVENT_MBUTTONDBLCLK
CV_EVENT_MBUTTONDOWN
CV_EVENT_MBUTTONUP
CV_EVENT_MOUSEMOVE
CV_EVENT_RBUTTONDBLCLK
CV_EVENT_RBUTTONDOWN
CV_EVENT_RBUTTONUP
CV_ErrModeLeaf
CV_ErrModeParent
CV_ErrModeSilent
CV_FILLED
CV_FLOODFILL_FIXED_RANGE
CV_FLOODFILL_MASK_ONLY
CV_FONT_HERSHEY_COMPLEX
CV_FONT_HERSHEY_COMPLEX_SMALL
CV_FONT_HERSHEY_DUPLEX
CV_FONT_HERSHEY_PLAIN
CV_FONT_HERSHEY_SCRIPT_COMPLEX
CV_FONT_HERSHEY_SCRIPT_SIMPLEX
CV_FONT_HERSHEY_SIMPLEX
CV_FONT_HERSHEY_TRIPLEX
CV_GAUSSIAN
CV_GAUSSIAN_5x5
CV_GEMM_A_T
CV_GEMM_B_T
CV_GEMM_C_T
CV_GRAPH_ALL_ITEMS
CV_GRAPH_ANY_EDGE
CV_GRAPH_BACKTRACKING
CV_GRAPH_BACK_EDGE
CV_GRAPH_CROSS_EDGE
CV_GRAPH_FLAG_ORIENTED
CV_GRAPH_FORWARD_EDGE
CV_GRAPH_NEW_TREE
CV_GRAPH_TREE_EDGE
CV_GRAPH_VERTEX
CV_GRAY2BGR
CV_GRAY2BGR555
CV_GRAY2BGR565
CV_GRAY2BGRA
CV_GRAY2RGB
CV_GRAY2RGBA
CV_HAAR_DO_CANNY_PRUNING
CV_HAAR_DO_ROUGH_SEARCH
CV_HAAR_FEATURE_MAX
CV_HAAR_FIND_BIGGEST_OBJECT
CV_HAAR_MAGIC_VAL
CV_HAAR_SCALE_IMAGE
CV_HIST_ARRAY
CV_HIST_SPARSE
CV_HLS2BGR
CV_HLS2RGB
CV_HOUGH_GRADIENT
CV_HOUGH_MULTI_SCALE
CV_HOUGH_PROBABILISTIC
CV_HOUGH_STANDARD
CV_HSV2BGR
CV_HSV2RGB
CV_INPAINT_NS
CV_INPAINT_TELEA
CV_INTER_AREA
CV_INTER_CUBIC
CV_INTER_LINEAR
CV_INTER_NN
CV_L1
CV_L2
CV_LINK_RUNS
CV_LKFLOW_PYR_A_READY
CV_LKFLOW_PYR_B_READY
CV_LOAD_IMAGE_COLOR
CV_LOAD_IMAGE_GRAYSCALE
CV_LU
CV_MAJOR_VERSION
CV_MAT_CN_MASK
CV_MAT_DEPTH_MASK
CV_MEDIAN
CV_MINMAX
CV_MINOR_VERSION
CV_MOP_BLACKHAT
CV_MOP_CLOSE
CV_MOP_GRADIENT
CV_MOP_OPEN
CV_MOP_TOPHAT
CV_NEXT_AROUND_DST
CV_NEXT_AROUND_LEFT
CV_NEXT_AROUND_ORG
CV_NEXT_AROUND_RIGHT
CV_NODE_EMPTY
CV_NODE_FLOAT
CV_NODE_INT
CV_NODE_INTEGER
CV_NODE_MAP
CV_NODE_NAMED
CV_NODE_NONE
CV_NODE_REAL
CV_NODE_REF
CV_NODE_SEQ
CV_NODE_STR
CV_NODE_STRING
CV_NODE_TYPE_MASK
CV_NODE_USER
CV_POLY_APPROX_DP
CV_PREV_AROUND_DST
CV_PREV_AROUND_LEFT
CV_PREV_AROUND_ORG
CV_PREV_AROUND_RIGHT
CV_PTLOC_ERROR
CV_PTLOC_INSIDE
CV_PTLOC_ON_EDGE
CV_PTLOC_OUTSIDE_RECT
CV_PTLOC_VERTEX
CV_RAND_NORMAL
CV_RAND_UNI
CV_RANSAC
CV_REDUCE_AVG
CV_REDUCE_MAX
CV_REDUCE_MIN
CV_REDUCE_SUM
CV_RETR_CCOMP
CV_RETR_EXTERNAL
CV_RETR_LIST
CV_RETR_TREE
CV_RGB2BGR
CV_RGB2BGR555
CV_RGB2BGR565
CV_RGB2BGRA
CV_RGB2GRAY
CV_RGB2HLS
CV_RGB2HSV
CV_RGB2Lab
CV_RGB2RGBA
CV_RGB2XYZ
CV_RGB2YCrCb
CV_RGBA2BGR
CV_RGBA2BGR555
CV_RGBA2BGR565
CV_RGBA2BGRA
CV_RGBA2GRAY
CV_RGBA2RGB
CV_SEQ_ELTYPE_CODE
CV_SEQ_ELTYPE_GENERIC
CV_SEQ_ELTYPE_GRAPH_EDGE
CV_SEQ_ELTYPE_GRAPH_VERTEX
CV_SEQ_ELTYPE_INDEX
CV_SEQ_ELTYPE_POINT
CV_SEQ_ELTYPE_POINT3D
CV_SEQ_ELTYPE_PPOINT
CV_SEQ_ELTYPE_PTR
CV_SEQ_ELTYPE_TRIAN_ATR
CV_SEQ_KIND_BIN_TREE
CV_SEQ_KIND_CURVE
CV_SEQ_KIND_GENERIC
CV_SEQ_KIND_GRAPH
CV_SEQ_KIND_SUBDIV2D   
CV_SHAPE_CROSS
CV_SHAPE_ELLIPSE
CV_SHAPE_RECT
CV_STEREO_BM_BASIC
CV_STEREO_BM_FISH_EYE
CV_STEREO_BM_NARROW
CV_STORAGE_READ
CV_STORAGE_WRITE
CV_SUBMINOR_VERSION
CV_SVD
CV_SVD_SYM
CV_TERMCRIT_EPS
CV_TERMCRIT_ITER
CV_TERMCRIT_NUMBER
CV_THRESH_BINARY
CV_THRESH_BINARY_INV
CV_THRESH_OTSU
CV_THRESH_TOZERO
CV_THRESH_TOZERO_INV
CV_THRESH_TRUNC
CV_TM_CCOEFF
CV_TM_CCOEFF_NORMED
CV_TM_CCORR
CV_TM_CCORR_NORMED
CV_TM_SQDIFF
CV_TM_SQDIFF_NORMED
CV_WARP_FILL_OUTLIERS
CV_WARP_INVERSE_MAP
CV_WINDOW_AUTOSIZE
CV_XYZ2BGR
CV_XYZ2RGB
CV_YCrCb2BGR
CV_YCrCb2RGB
IPL_BORDER_CONSTANT
IPL_BORDER_REPLICATE
IPL_DEPTH_16S
IPL_DEPTH_16U
IPL_DEPTH_1U
IPL_DEPTH_32F
IPL_DEPTH_32S
IPL_DEPTH_64F
IPL_DEPTH_8S
IPL_DEPTH_8U
IPL_ORIGIN_BL
IPL_ORIGIN_TL

CV_CLOCKWISE
CV_FM_RANSAC
CV_CALIB_FIX_INTRINSIC

)],

    2.001 => [qw(

CV_CALIB_CB_FAST_CHECK
CV_CALIB_ZERO_DISPARITY
CV_CAP_PROP_EXPOSURE
CV_CAP_PROP_RECTIFICATION
CV_IMWRITE_JPEG_QUALITY
CV_IMWRITE_PNG_COMPRESSION
CV_IMWRITE_PXM_BINARY
CV_WINDOW_FULLSCREEN
CV_WINDOW_NORMAL
CV_WND_PROP_AUTOSIZE
CV_WND_PROP_FULLSCREEN

)],

    2.002 => [qw(

CV_BGR2HLS_FULL
CV_BGR2HSV_FULL
CV_BGR2Luv
CV_BGR2YUV
CV_BayerBG2BGR_VNG
CV_BayerBG2RGB_VNG
CV_BayerGB2BGR_VNG
CV_BayerGB2RGB_VNG
CV_BayerGR2BGR_VNG
CV_BayerGR2RGB_VNG
CV_BayerRG2BGR_VNG
CV_BayerRG2RGB_VNG
CV_FONT_BLACK
CV_FONT_BOLD
CV_FONT_DEMIBOLD
CV_FONT_LIGHT
CV_FONT_NORMAL
CV_GUI_EXPANDED
CV_GUI_NORMAL
CV_HLS2BGR_FULL
CV_HLS2RGB_FULL
CV_HSV2BGR_FULL
CV_HSV2RGB_FULL
CV_LBGR2Lab
CV_LBGR2Luv
CV_LRGB2Lab
CV_LRGB2Luv
CV_Lab2BGR
CV_Lab2LBGR
CV_Lab2LRGB
CV_Lab2RGB
CV_Luv2BGR
CV_Luv2LBGR
CV_Luv2LRGB
CV_Luv2RGB
CV_RGB2HLS_FULL
CV_RGB2HSV_FULL
CV_RGB2Luv
CV_RGB2YUV
CV_STYLE_ITALIC
CV_STYLE_NORMAL
CV_STYLE_OBLIQUE
CV_WINDOW_FREERATIO
CV_WINDOW_KEEPRATIO
CV_WND_PROP_ASPECTRATIO
CV_YUV2BGR
CV_YUV2RGB

)],

    2.003 => [qw(

CV_CAP_PROP_AUTOGRAB
CV_CAP_PROP_AUTO_EXPOSURE
CV_CAP_PROP_GAMMA
CV_CAP_PROP_MAX_DC1394
CV_CAP_PROP_MONOCROME
CV_CAP_PROP_SHARPNESS
CV_CAP_PROP_SUPPORTED_PREVIEW_SIZES_STRING
CV_CAP_PROP_TEMPERATURE
CV_CAP_PROP_TRIGGER
CV_CAP_PROP_TRIGGER_DELAY
CV_CAP_PROP_WHITE_BALANCE_BLUE_U
CV_CAP_PROP_WHITE_BALANCE_RED_V

)],

    );

foreach (map { @{$OLD_CONST{$_}} } grep { $_ <= cvVersion() } keys %OLD_CONST) {
	no strict 'refs';
	eval { &$_ };
	print STDERR "$@\n" if $@;
	ok(!$@, $_);
}
