# -*- coding: utf-8 -*-
cimport _pcl
cimport pcl_visualization
from _pcl cimport PointCloud_PointWithViewpoint
from _pcl cimport RangeImages
cimport pcl_defs as cpp
cimport numpy as cnp


cimport pcl_visualization_defs as pcl_vis
from boost_shared_ptr cimport sp_assign
cdef class PointCloudColorHandleringCustom:
    """
    """
    # cdef pcl_vis.PointCloudColorHandlerCustom_t *me

    def __cinit__(self):
        pass

    # void sp_assign[T](shared_ptr[T] &p, T *value)
    def __cinit__(self, pc, int r, int g, int b):
        if isinstance(pc, _pcl.PCLPointCloud2):
            self.__assign_PCLPointCloud2__(pc, r, g, b)

        else:
            self.__assign__(pc, r, g, b)

        pass

    def __assign_PCLPointCloud2__(self, _pcl.PCLPointCloud2 pc, int r, int g, int b):
        sp_assign(self.thisptr_shared, <int*> new pcl_vis.PointCloudColorHandlerCustom_PCLPointCloud2(pc.thisptr_shared, r, g, b))

    def __assign__(self, _pcl.PointCloudTypes pc, int r, int g, int b):
        sp_assign(self.thisptr_shared, <int*> pcl_vis.pcl_visualization_newPointCloudColorHandlerCustom(pc.thisptr_shared, r, g, b))

    # def __cinit__(self, _pcl.RangeImages rangeImage, int r, int g, int b):
    #     sp_assign(self.thisptr_shared, new pcl_vis.PointCloudColorHandlerCustom[cpp.PointWithViewpoint](rangeImage.thisptr_shared, r, g, b))
    #     pass

    def __dealloc__(self):
        # del self.me
        pass



