# nodejz-zlib
A pseudo-library to convince CMAKE that zlib exists when linked with nodejs

When building a c++ plugin with nodejs, it's useful to allow cmake to find node's version of the header files.

However, unfortunately, the script FindZLIB.cmake expects to find a library in the same tree as the header files.

This project builds a dummy library so that find_package(ZLIB) can find it as expected
