# -*- coding: utf-8 -*-
cimport pcl_defs as cpp
cimport pcl_io_180 as pcl_io
cimport stream as stream

from cython.operator cimport dereference as deref
from cpython.buffer cimport PyObject_GetBuffer, PyBuffer_Release, PyBUF_ANY_CONTIGUOUS, PyBUF_SIMPLE

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

    def _read_PointCloudTypes(self, str filename, PointCloudTypes pc):
        cdef int ok = -1
        cdef bytes b_filename = filename.encode("UTF-8")
        if pc is None: return ok
        ok = self.thisptr().read (string(b_filename), deref(pc.thisptr()))
        return ok
    
    def _read_PCLPointCloud2(self, str filename, PCLPointCloud2 pc not None):
        cdef int ok = -1
        cdef bytes b_filename = filename.encode("UTF-8")
        ok = self.thisptr().read (string(b_filename), deref(pc.thisptr()))
        return ok
    
    def read(self, str filename, pc not None):
        if isinstance(pc, PCLPointCloud2):
            self._read_PCLPointCloud2(filename, pc)
        else:
            self._read_PointCloudTypes(filename, pc)
    
    def readHeader(self, data, PCLPointCloud2 pc not None):
        cdef int ok = -1
        cdef int pcd_version = 0
        cdef int data_type = 0
        cdef unsigned int data_idx = 0
        cdef stream.bufferstream* bufstream
        cdef cpp.Vector4f origin
        cdef cpp.Quaternionf orientation
        cdef Py_buffer buffer
        cdef char* ptr
        cdef int size
        if isinstance(data, str):
            ok = self.thisptr().readHeader (<string> data.encode("UTF-8"), deref(pc.thisptr()),
                origin, orientation, pcd_version, data_type, data_idx)
        else:
            if isinstance(data, memoryview):
                PyObject_GetBuffer(data, &buffer, PyBUF_SIMPLE | PyBUF_ANY_CONTIGUOUS)
                ptr = <char*>buffer.buf
                size = buffer.len
            else:
                ptr = <char*>data
                size = len(data)
            bufstream = new stream.bufferstream(ptr, size)
            ok = self.thisptr().readHeader (<stream.istream&> deref(bufstream), deref(pc.thisptr()),
                origin, orientation, pcd_version, data_type, data_idx)
            if isinstance(data, memoryview):
                PyBuffer_Release(&buffer)
        if ok != 0: return None
        ret = {}
        ret['origin'] = np.array([origin.data()[0], origin.data()[1], origin.data()[2]])
        ret['orientation'] = np.array([orientation.w(), orientation.x(), orientation.y(), orientation.z()])
        ret['pcd_version'] = pcd_version
        ret['data_type'] = data_type
        ret['data_idx'] = data_idx
        return ret
    
    def readBodyBinary(self, data, PCLPointCloud2 pc not None, int pcd_version, bool compressed, unsigned int data_idx):
        cdef const unsigned char *ptr
        cdef Py_buffer buffer
        cdef int ok = -1
        if isinstance(data, memoryview):
            PyObject_GetBuffer(data, &buffer, PyBUF_SIMPLE | PyBUF_ANY_CONTIGUOUS)
            ptr = <const unsigned char *>buffer.buf
        elif isinstance(data, bytes):
            ptr = <const unsigned char *>data
        else:
            raise TypeError("Argument 'data' has incorrect type (expected bytes or memoryview, got %r)", data)
        ok = self.thisptr().readBodyBinary(ptr, deref(pc.thisptr()), pcd_version, compressed, data_idx)
        if isinstance(data, memoryview):
            PyBuffer_Release(&buffer)
        return ok
