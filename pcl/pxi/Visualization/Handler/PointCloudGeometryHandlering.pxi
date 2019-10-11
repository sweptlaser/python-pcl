# -*- coding: utf-8 -*-
cimport _pcl
from cpython.ref cimport PyObject
cimport pcl_defs as cpp
cimport numpy as cnp
cimport vtk_defs
import vtk

cimport pcl_visualization_defs as pcl_vis
from boost_shared_ptr cimport sp_assign

cimport PointCloudGeometryHandler as wrapper

cdef void getGeometry_callback(PyObject* gh, vtk_defs.vtkSmartPointer[vtk_defs.vtkPoints] &points):
    cdef object py_points = <object>vtk_defs.convertSmartPointer[vtk_defs.vtkPoints](points)
    if py_points is None:
        raise ValueError("getGeometry called with NULL points")
    (<object>gh).getGeometry(py_points)

cdef class PointCloudGeometryHandlering:
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
        sp_assign(self.thisptr_shared, <int*> new wrapper.PointCloudGeometryHandler_PCLPointCloud2(pc.thisptr_shared, <PyObject*>self, getGeometry_callback))
    
    def __dealloc__(self):
        pass
    
    def getGeometry(self, points):
        pass
