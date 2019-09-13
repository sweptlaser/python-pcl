# -*- coding: utf-8 -*-
cimport _pcl
cimport pcl_defs as cpp
cimport numpy as cnp

cimport pcl_visualization_defs as pcl_vis
from boost_shared_ptr cimport sp_assign

cdef class PointCloudColorHandleringGenericField:
    """
    """
    
    # workaround for Cython not supporting fused types in __cinit__
    def __cinit__(self, pc, str field):
        self.__assign__(pc, field)
    
    def __assign__(self, _pcl.PointCloudTypes pc, str field):
        sp_assign(self.thisptr_shared, pcl_vis.pcl_visualization_newPointCloudColorHandlerGenericField(pc.thisptr_shared, field.encode("UTF-8")))
    
    def __dealloc__(self):
        # del self.me
        pass



