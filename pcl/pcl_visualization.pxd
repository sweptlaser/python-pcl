# -*- coding: utf-8 -*-
# Header for pcl_visualization.pyx functionality that needs sharing with other modules.

cimport pcl_visualization_defs as pcl_vis
cimport vtk_defs as vtk

from libc.stddef cimport size_t

from boost_shared_ptr cimport shared_ptr
from libcpp.vector cimport vector
from libcpp.string cimport string
from libcpp cimport bool

# main
cimport pcl_defs as cpp

# class override(PointCloud)
cdef class PointCloudColorHandleringCustom:
    cdef cpp.shared_bare_ptr thisptr_shared     # PointCloudColorHandlerCustom[PointT]
    
    # pcl_visualization_defs
    cdef inline pcl_vis.PointCloudColorHandlerCustom[cpp.PointXYZ] *thisptr(self) nogil:
        # Shortcut to get raw pointer to underlying PointCloudColorHandlerCustom<PointXYZ>.
        return <pcl_vis.PointCloudColorHandlerCustom[cpp.PointXYZ] *> self.thisptr_shared.get()

# class override(PointCloud)
cdef class PointCloudColorHandleringGenericField:
    cdef cpp.shared_bare_ptr thisptr_shared     # PointCloudColorHandlerGenericField[PointT]
    
    # pcl_visualization_defs
    cdef inline pcl_vis.PointCloudColorHandlerGenericField[cpp.PointXYZ] *thisptr(self) nogil:
        # Shortcut to get raw pointer to underlying PointCloudColorHandlerGenericField<PointXYZ>.
        return <pcl_vis.PointCloudColorHandlerGenericField[cpp.PointXYZ] *> self.thisptr_shared.get()

ctypedef fused PointCloudColorHandleringTypes:
    PointCloudColorHandleringCustom
    PointCloudColorHandleringGenericField

cdef class PointCloudGeometryHandleringCustom:
    cdef pcl_vis.PointCloudGeometryHandlerCustom_Ptr_t thisptr_shared     # PointCloudGeometryHandlerCustom[PointXYZ]
    
    # cdef inline PointCloudGeometryHandlerCustom[cpp.PointXYZ] *thisptr(self) nogil:
    # pcl_visualization_defs
    cdef inline pcl_vis.PointCloudGeometryHandlerCustom[cpp.PointXYZ] *thisptr(self) nogil:
        # Shortcut to get raw pointer to underlying PointCloudGeometryHandlerCustom<PointXYZ>.
        return self.thisptr_shared.get()


cdef class vtkSmartPointerRenderWindow:
    # cdef vtk.vtkRenderWindow_Ptr_t thisptr_shared     # vtkRenderWindow
    cdef vtk.vtkSmartPointer[vtk.vtkRenderWindow] thisptr_shared
    
    # cdef inline vtk.vtkRenderWindow *thisptr(self) nogil:
    cdef inline vtk.vtkSmartPointer[vtk.vtkRenderWindow] thisptr(self) nogil:
        # Shortcut to get raw pointer to underlying vtkRenderWindow.
        return self.thisptr_shared

