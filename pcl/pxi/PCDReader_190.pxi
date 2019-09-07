# -*- coding: utf-8 -*-
cimport pcl_defs as cpp
cimport pcl_io_180 as pcl_io

from cython.operator cimport dereference as deref

from boost_shared_ptr cimport sp_assign

cdef class PCDReader:
    """Point Cloud Data (PCD) file format reader."""
    
    cdef pcl_io.PCDReaderPtr_t thisptr_shared
    
    cdef inline pcl_io.PCDReader *thisptr(self) nogil:
        return self.thisptr_shared.get()
    
    def __cinit__(self):
        sp_assign(self.thisptr_shared, new pcl_io.PCDReader())
    
    def __repr__(self):
        return "<PCDReader>"

    def read(self, str filename, PointCloud pc not None):
        cdef int ok = -1
        cdef bytes b_filename = filename.encode("UTF-8")
        ok = self.thisptr().read (string(b_filename), deref(pc.thisptr()))
        return ok
