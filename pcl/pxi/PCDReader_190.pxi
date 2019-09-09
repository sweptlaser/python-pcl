# -*- coding: utf-8 -*-
cimport pcl_defs as cpp
cimport pcl_io_180 as pcl_io
cimport stream as stream

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

    def read(self, str filename, PointCloudTypes pc):
        cdef int ok = -1
        cdef bytes b_filename = filename.encode("UTF-8")
        if pc is None: return ok
        ok = self.thisptr().read (string(b_filename), deref(pc.thisptr()))
        return ok
    
    def readHeader(self, bytes data, PCLPointCloud2 pc not None):
        cdef int ok = -1
        cdef int pcd_version = 0
        cdef int data_type = 0
        cdef unsigned int data_idx = 0
        cdef stream.bufferstream* bufstream = new stream.bufferstream(<char*>data, len(data))
        cdef cpp.Vector4f origin
        cdef cpp.Quaternionf orientation
        ok = self.thisptr().readHeader (<stream.istream&> deref(bufstream), deref(pc.thisptr()),
            origin, orientation, pcd_version, data_type, data_idx)
        del bufstream
        if ok != 0: return None
        ret = {}
        ret['origin'] = np.array([origin.data()[0], origin.data()[1], origin.data()[2]])
        ret['orientation'] = np.array([orientation.w(), orientation.x(), orientation.y(), orientation.z()])
        ret['pcd_version'] = pcd_version
        ret['data_type'] = data_type
        ret['data_idx'] = data_idx
        return ret
