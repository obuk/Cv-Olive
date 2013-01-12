#!/bin/sh

# mkdir opencv
# git clone https://github.com/Itseez/opencv.git
# mkdir build
# cd build
# cmake.sh   (this script)

src=../opencv
modules=`pwd`/$src/modules
cmake \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_VERBOSE:BOOL=No \
    -DBUILD_DOCS:BOOL=Yes \
    -DBUILD_EXAMPLES:BOOL=Yes \
    -DBUILD_TESTS:BOOL=Yes \
    -DINSTALL_C_EXAMPLES:BOOL=Yes \
    -DINSTALL_PYTHON_EXAMPLES:BOOL=Yes \
    -DWITH_FFMPEG:BOOL=Yes \
    -DWITH_GSTREAMER:BOOL=No \
    -DWITH_GTK:BOOL=Yes \
    -DWITH_JASPER:BOOL=Yes \
    -DWITH_JPEG:BOOL=Yes \
    -DWITH_OPENEXR:BOOL=No \
    -DWITH_PNG:BOOL=Yes \
    -DWITH_QT:BOOL=No \
    -DWITH_TBB:BOOL=Yes \
    -DWITH_EIGEN:BOOL=No \
    -DWITH_EIGEN2:BOOL=No \
    -DWITH_V4L:BOOL=Yes \
    -DWITH_TIFF:BOOL=Yes \
    -DWITH_XINE:BOOL=No \
    -DWITH_PVAPI:BOOL=No \
    -DWITH_1394:BOOL=No \
    -DWITH_CUDA:BOOL=No \
    $src

if [ "`uname`" = "FreeBSD" ]; then
  patch=patch-cvconfig.pl
  target=cvconfig.h
  if [ -f $target ]; then
    cat >$patch <<'EOF'
s<(/\*)?\s*\#undef\s+(HAVE_CAMV4L2?)\s*(\*/)?><\#define $2\t/* FIXED */>;
EOF
    perl -i.bak -lp $patch $target
  fi

  patch=patch-opencvpc.pl
  target=unix-install/opencv.pc
  if [ -f $target ]; then
    cat >$patch <<'EOF'
s<libdir=\s*$><libdir=\${prefix}/lib>;
s<Libs:  ><Libs: -L\${libdir} >;
s<\${exec_prefix}/lib/libopencv><-lopencv>g;
s<(opencv_\w+)\.so><$1>g;
EOF
    perl -i.bak -lp $patch $target
  fi
fi

cat <<EOF

\$ make -j4
# You can use -jN.  N is the maximum number of jobs that make may have
# running at any one time.

EOF
             
