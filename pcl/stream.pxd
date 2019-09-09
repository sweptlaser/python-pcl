# -*- coding: utf-8 -*-

cdef extern from "<boost/interprocess/streams/bufferstream.hpp>" namespace "boost::interprocess" nogil:
    cdef cppclass bufferstream:
        bufferstream(char* begin, int count) except +

cdef extern from "<iostream>" namespace "std" nogil:
    cdef cppclass istream:
        istream() except +

