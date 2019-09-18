# -*- coding: utf-8 -*-
cimport _pcl
cimport pcl_defs as cpp
cimport numpy as cnp

cimport pcl_visualization_defs as pcl_vis
from boost_shared_ptr cimport sp_assign

cdef class PointCloudColorHandleringGenericField:
    """
    """
    
    def __cinit__(self, pc, str field):
        cdef bytes f = field.encode("UTF-8")
        if isinstance(pc, _pcl.PCLPointCloud2):
            self.__assign_PCLPointCloud2__(pc, f)
        else:
            self.__assign__(pc, f)
    
    def __assign_PCLPointCloud2__(self, _pcl.PCLPointCloud2 pc, bytes field):
        sp_assign(self.thisptr_shared, <int*> new pcl_vis.PointCloudColorHandlerGenericField_PCLPointCloud2(pc.thisptr_shared, field))
    
    def __assign__(self, _pcl.PointCloudTypes pc, bytes field):
        sp_assign(self.thisptr_shared, <int*> pcl_vis.pcl_visualization_newPointCloudColorHandlerGenericField(pc.thisptr_shared, field))
    
    def __dealloc__(self):
        # del self.me
        pass



