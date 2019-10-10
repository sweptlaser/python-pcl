# -*- coding: utf-8 -*-
from boost_shared_ptr cimport shared_ptr
from cpython.ref cimport PyObject
cimport pcl_defs as cpp
cimport vtk_defs

ctypedef void (*pythonCallback_t)(PyObject* o, vtk_defs.vtkSmartPointer[vtk_defs.vtkPoints] &points)

cdef extern from "PointCloudGeometryHandler.h" nogil:
    cdef cppclass PointCloudGeometryHandler_PCLPointCloud2:
        PointCloudGeometryHandler_PCLPointCloud2(shared_ptr[cpp.PCLPointCloud2] &cloud, PyObject* object, pythonCallback_t callback)
