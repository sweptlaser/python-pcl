# -*- coding: utf-8 -*-
cimport pcl_defs as cpp
import numpy as np
cimport numpy as cnp

cnp.import_array()

# 
cimport pcl_PCLPointCloud2_180 as pcl_pc2

# parts
cimport pcl_features_180 as pcl_ftr
cimport pcl_filters_180 as pcl_fil
cimport pcl_io_180 as pcl_io
cimport pcl_kdtree_180 as pcl_kdt
cimport pcl_octree_180 as pcl_oct
cimport pcl_sample_consensus_180 as pcl_sac
# cimport pcl_search_180 as pcl_sch
cimport pcl_segmentation_180 as pcl_seg
cimport pcl_surface_180 as pcl_srf
cimport pcl_range_image_180 as pcl_rim
cimport pcl_registration_180 as pcl_reg

from libcpp cimport bool
cimport indexing as idx

from boost_shared_ptr cimport sp_assign

cdef extern from "ProjectInliers.h":
    void mpcl_ProjectInliers_setModelCoefficients(pcl_fil.ProjectInliers_t) except +

# Empirically determine strides, for buffer support.
# XXX Is there a more elegant way to get these?
# cdef Py_ssize_t _strides_pointcloud2[2]
# cdef PointCloud2 _pc_tmp_pointcloud2 = PointCloud2(np.array([[1, 2, 3],
#                                                [4, 5, 6]], dtype=np.float32))
# 
# cdef pcl_pc2.PCLPointCloud2 *p_pointcloud2 = _pc_tmp_pointcloud2.thisptr()
# _strides_pointcloud2[0] = (  <Py_ssize_t><void *>idx.getptr(p_pointcloud2, 1)
#                - <Py_ssize_t><void *>idx.getptr(p_pointcloud2, 0))
# _strides_pointcloud2[1] = (  <Py_ssize_t><void *>&(idx.getptr(p_pointcloud2, 0).y)
#                - <Py_ssize_t><void *>&(idx.getptr(p_pointcloud2, 0).x))
# _pc_tmp_pointcloud2 = None

cdef class PCLPointCloud2:
    """Represents a cloud of points in 3-d space.

    A point cloud can be initialized from either a NumPy ndarray of shape
    (n_points, 3), from a list of triples, or from an integer n to create an
    "empty" cloud of n points.

    To load a point cloud from disk, use pcl.load.
    """
    cdef pcl_pc2.PCLPointCloud2Ptr_t thisptr_shared     # XYZ
    
    cdef inline pcl_pc2.PCLPointCloud2 *thisptr(self) nogil:
        # Shortcut to get raw pointer to underlying PCLPointCloud2.
        return self.thisptr_shared.get()

    def __cinit__(self, init=None):
        cdef PCLPointCloud2 other
        
        # TODO: NG --> import pcl --> pyd Error(python shapedptr/C++ shard ptr collusion?)
        sp_assign(self.thisptr_shared, new pcl_pc2.PCLPointCloud2())
        
        if init is None:
            return
        elif isinstance(init, (numbers.Integral, np.integer)):
            self.resize(init)
        elif isinstance(init, np.ndarray):
            self.from_array(init)
        elif isinstance(init, Sequence):
            self.from_list(init)
        elif isinstance(init, type(self)):
            other = init
            self.thisptr()[0] = other.thisptr()[0]
        else:
            raise TypeError("Can't initialize a PointCloud from a %s"
                            % type(init))

    property width:
        """ property containing the width of the point cloud """
        def __get__(self): return self.thisptr().width
    property height:
        """ property containing the height of the point cloud """
        def __get__(self): return self.thisptr().height
    property is_dense:
        """ property containing whether the cloud is dense or not """
        def __get__(self): return self.thisptr().is_dense

    def __repr__(self):
        return "<PCLPointCloud2>"

###
