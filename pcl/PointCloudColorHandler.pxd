# -*- coding: utf-8 -*-
from boost_shared_ptr cimport shared_ptr
from cpython.ref cimport PyObject
cimport pcl_defs as cpp
cimport vtk_defs

ctypedef void (*PointCloudColorHandler_callback_t)(PyObject* o, vtk_defs.vtkSmartPointer[vtk_defs.vtkDataArray] &scalars)

cdef extern from "PointCloudColorHandler.h" nogil:
    cdef cppclass PointCloudColorHandler_PCLPointCloud2:
        PointCloudColorHandler_PCLPointCloud2(shared_ptr[cpp.PCLPointCloud2] &cloud, PyObject* object, PointCloudColorHandler_callback_t callback)
