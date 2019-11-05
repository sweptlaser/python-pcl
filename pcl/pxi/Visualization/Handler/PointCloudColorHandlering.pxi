# -*- coding: utf-8 -*-
cimport _pcl
from cpython.ref cimport PyObject
cimport pcl_defs as cpp
cimport numpy as cnp
cimport vtk_defs
import vtk

cimport pcl_visualization_defs as pcl_vis
from boost_shared_ptr cimport sp_assign

cimport PointCloudColorHandler as pcch

cdef void getColor_callback(PyObject* gh, vtk_defs.vtkSmartPointer[vtk_defs.vtkDataArray] &scalars):
    cdef object py_scalars = <object>vtk_defs.convertSmartPointer[vtk_defs.vtkDataArray](scalars)
    if py_scalars is None:
        raise ValueError("getColor called with NULL scalars")
    (<object>gh).getColor(py_scalars)

cdef class PointCloudColorHandlering:
    """
    """
    def __cinit__(self, pc, *pargs, **kwargs):
        if isinstance(pc, _pcl.PCLPointCloud2):
            self.__assign_PCLPointCloud2__(pc)
        else:
            raise TypeError("currently only support PCLPointCloud2 point clouds")
    
    def __init__(self, pc):
        self.cloud = pc
    
    def __assign_PCLPointCloud2__(self, _pcl.PCLPointCloud2 pc):
        sp_assign(self.thisptr_shared, <int*> new pcch.PointCloudColorHandler_PCLPointCloud2(pc.thisptr_shared, <PyObject*>self, getColor_callback))
    
    def __dealloc__(self):
        pass
    
    def getColor(self, scalars):
        pass
