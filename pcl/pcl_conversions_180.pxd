# -*- coding: utf-8 -*-

cimport pcl_PCLPointCloud2_180 as pcl_pc2

cimport pcl_defs as cpp

cdef extern from "pcl/conversions.h" namespace "pcl" nogil:
    void fromPCLPointCloud2 [PointT](const pcl_pc2.PCLPointCloud2& msg, cpp.PointCloud[PointT]& cloud)

