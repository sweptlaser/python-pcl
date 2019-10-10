# -*- coding: utf-8 -*-
cimport _pcl
cimport pcl_defs as cpp
cimport numpy as cnp

cimport pcl_visualization_defs as pcl_vis
from boost_shared_ptr cimport sp_assign

cdef class PointCloudGeometryHandleringXYZ:
    """
    """
    def __cinit__(self, pc):
        if isinstance(pc, _pcl.PCLPointCloud2):
            self.__assign_PCLPointCloud2__(pc)
        else:
            raise TypeError("currently only support PCLPointCloud2 point clouds")
    
    def __assign_PCLPointCloud2__(self, _pcl.PCLPointCloud2 pc):
        sp_assign(self.thisptr_shared, <int*> new pcl_vis.PointCloudGeometryHandlerXYZ_PCLPointCloud2(pc.thisptr_shared))
    
    def __dealloc__(self):
        pass



