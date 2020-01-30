# -*- coding: utf-8 -*-
cimport _pcl
from libcpp.vector cimport vector
from libcpp cimport bool

cimport pcl_defs as cpp
cimport pcl_features_180 as pcl_ftr


cdef class NormalEstimationOMP:
    """
    NormalEstimationOMP class for
    """
    cdef pcl_ftr.NormalEstimationOMP_t *me

    def __cinit__(self):
        self.me = new pcl_ftr.NormalEstimationOMP_t()

    def __dealloc__(self):
        del self.me

    def set_InputCloud(self, _pcl.PointCloud pc):
        self.me.setInputCloud(<cpp.shared_ptr[cpp.PointCloud[cpp.PointXYZ]]> pc.thisptr_shared)

    def set_ViewPoint(self, float vpx, float vpy, float vpz):
        self.me.setViewPoint(vpx, vpy, vpz)

    def get_ViewPoint(self, float vpx, float vpy, float vpz):
        self.me.getViewPoint(vpx, vpy, vpz)
        return vpx, vpy, vpz

    def useSensorOriginAsViewPoint(self):
        self.me.useSensorOriginAsViewPoint()

    def set_SearchMethod(self, _pcl.KdTree kdtree):
        self.me.setSearchMethod(kdtree.thisptr_shared)

    def set_RadiusSearch(self, double param):
        self.me.setRadiusSearch(param)

    def set_KSearch (self, int param):
        self.me.setKSearch (param)

    def set_NumberOfThreads(self, int threads):
        self.me.setNumberOfThreads(threads)

    def compute(self):
        normals = PointCloud_Normal()
        sp_assign(normals.thisptr_shared, new cpp.PointCloud[cpp.Normal]())
        cdef cpp.PointCloud_Normal_t *cNormal = <cpp.PointCloud_Normal_t*>normals.thisptr()
        (<pcl_ftr.Feature_t*>self.me).compute(deref(cNormal))
        return normals

