# -*- coding: utf-8 -*-
from _pcl cimport PointCloud
from _pcl cimport PointCloud_PointWithViewpoint
cimport pcl_defs as cpp
cimport pcl_range_image_180 as pcl_rim

cimport eigen as eigen3
from boost_shared_ptr cimport sp_assign

from cython.operator cimport dereference as deref, preincrement as inc


cimport pcl_common_180 as common

def copyPointCloud (PCLPointCloud2 cloud_in, PCLPointCloud2 cloud_out):
    common.copyPointCloud (deref(cloud_in.thisptr()), deref(cloud_out.thisptr()))


def copyPointCloud (PCLPointCloud2 cloud_in, object indices, PCLPointCloud2 cloud_out):
    cdef vector[int] vect
    for i in indices:
        vect.push_back(i)

    common.copyPointCloud (deref(cloud_in.thisptr()), vect, deref(cloud_out.thisptr()))
