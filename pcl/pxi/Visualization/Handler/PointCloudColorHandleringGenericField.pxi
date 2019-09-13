# -*- coding: utf-8 -*-
cimport _pcl
cimport pcl_defs as cpp
cimport numpy as cnp

cimport pcl_visualization_defs as pcl_vis
from boost_shared_ptr cimport sp_assign

cdef class PointCloudColorHandleringGenericField:
    """
    """
    
    def __cinit__(self, _pcl.PointCloud pc, str field):
        sp_assign(self.thisptr_shared, new pcl_vis.PointCloudColorHandlerGenericField[cpp.PointXYZ](pc.thisptr_shared, field.encode("UTF-8")))
        pass
    
    def __dealloc__(self):
        # del self.me
        pass



