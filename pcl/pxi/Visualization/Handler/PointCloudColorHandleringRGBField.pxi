# -*- coding: utf-8 -*-
cimport _pcl
cimport pcl_defs as cpp
cimport numpy as cnp

cimport pcl_visualization_defs as pcl_vis
from boost_shared_ptr cimport sp_assign

cdef class PointCloudColorHandleringRGBField:
    def __cinit__(self, pc):
        if isinstance(pc, _pcl.PCLPointCloud2):
            self.__assign_PCLPointCloud2__(pc)
        else:
            self.__assign__(pc)

    def __assign_PCLPointCloud2__(self, _pcl.PCLPointCloud2 pc):
        sp_assign(self.thisptr_shared, <int*> new pcl_vis.PointCloudColorHandlerRGBField_PCLPointCloud2(pc.thisptr_shared))

    def __assign__(self, _pcl.PointCloudTypes pc):
        sp_assign(self.thisptr_shared, <int*> pcl_vis.pcl_visualization_newPointCloudColorHandlerRGBField(pc.thisptr_shared))

    def __dealloc__(self):
        # del self.me
        pass




