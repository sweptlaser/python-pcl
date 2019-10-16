# -*- coding: utf-8 -*-

from cython.operator cimport dereference as deref

cimport pcl_conversions_180 as conversions

def fromPCLPointCloud2 (PCLPointCloud2 msg, PointCloudTypes cloud):
    conversions.fromPCLPointCloud2 (deref(msg.thisptr()), deref(cloud.thisptr()))

def toPCLPointCloud2 (PointCloudTypes cloud, PCLPointCloud2 msg):
    conversions.toPCLPointCloud2 (deref(cloud.thisptr()), deref(msg.thisptr()))
