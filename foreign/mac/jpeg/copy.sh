#! /bin/sh

if [ -d include ]; then
  rm -r include
fi

if [ -d lib ]; then
  rm -r lib
fi

mkdir include
cp /Users/cartier/Devel/local/include/jpeglib.h include

mkdir lib
cp /Users/cartier/Devel/local/lib/libjpeg.8.dylib lib
chmod 755 lib/libjpeg.8.dylib
