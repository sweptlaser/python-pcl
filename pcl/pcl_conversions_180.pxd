# -*- coding: utf-8 -*-

cimport pcl_defs as cpp

cdef extern from "pcl/conversions.h" namespace "pcl" nogil:
    void fromPCLPointCloud2 [PointT](const cpp.PCLPointCloud2& msg, cpp.PointCloud[PointT]& cloud)
    void toPCLPointCloud2[PointT](cpp.PointCloud[PointT]& cloud, const cpp.PCLPointCloud2& msg)

