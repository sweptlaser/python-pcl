# -*- coding: utf-8 -*-
# Header for pcl_visualization.pyx functionality that needs sharing with other modules.

cimport pcl_visualization_defs as pcl_vis
cimport vtk_defs

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

# class override(PointCloud)
cdef class PointCloudColorHandleringRGBField:
    cdef cpp.shared_bare_ptr thisptr_shared     # PointCloudColorHandlerRGBField[PointT]

    # pcl_visualization_defs
    cdef inline pcl_vis.PointCloudColorHandlerRGBField[cpp.PointXYZ] *thisptr(self) nogil:
        # Shortcut to get raw pointer to underlying PointCloudColorHandlerCustom<PointXYZ>.
        return <pcl_vis.PointCloudColorHandlerRGBField[cpp.PointXYZ] *> self.thisptr_shared.get()

ctypedef fused PointCloudColorHandleringTypes:
    PointCloudColorHandleringCustom
    PointCloudColorHandleringGenericField
    PointCloudColorHandleringRGBField

cdef class PointCloudGeometryHandlering:
    cdef cpp.shared_bare_ptr thisptr_shared     # PointCloudGeometryHandler[PointT]
    
    # pcl_visualization_defs
    cdef inline pcl_vis.PointCloudGeometryHandler[cpp.PointXYZ] *thisptr(self) nogil:
        # Shortcut to get raw pointer to underlying PointCloudGeometryHandler<PointXYZ>.
        return <pcl_vis.PointCloudGeometryHandler[cpp.PointXYZ] *> self.thisptr_shared.get()

cdef class PointCloudGeometryHandleringCustom:
    cdef pcl_vis.PointCloudGeometryHandlerCustom_Ptr_t thisptr_shared     # PointCloudGeometryHandlerCustom[PointXYZ]
    
    # cdef inline PointCloudGeometryHandlerCustom[cpp.PointXYZ] *thisptr(self) nogil:
    # pcl_visualization_defs
    cdef inline pcl_vis.PointCloudGeometryHandlerCustom[cpp.PointXYZ] *thisptr(self) nogil:
        # Shortcut to get raw pointer to underlying PointCloudGeometryHandlerCustom<PointXYZ>.
        return self.thisptr_shared.get()

# class override(PointCloud)
cdef class PointCloudGeometryHandleringXYZ:
    cdef cpp.shared_bare_ptr thisptr_shared     # PointCloudGeometryHandlerXYZ[PointT]
    
    # pcl_visualization_defs
    cdef inline pcl_vis.PointCloudGeometryHandlerXYZ[cpp.PointXYZ] *thisptr(self) nogil:
        # Shortcut to get raw pointer to underlying PointCloudGeometryHandlerXYZ<PointXYZ>.
        return <pcl_vis.PointCloudGeometryHandlerXYZ[cpp.PointXYZ] *> self.thisptr_shared.get()

ctypedef fused PointCloudGeometryHandleringTypes:
    PointCloudGeometryHandlering
    PointCloudGeometryHandleringXYZ

cdef inline bool isPointCloudGeometryHandlering(object GeometryHandlering):
        # Is it possible to get this check to compare against the fused type, instead of checking each individual one.
        # if isinstance(GeometryHandlering, PointCloudGeometryHandleringTypes): return True
        if isinstance(GeometryHandlering, PointCloudGeometryHandlering): return True
        if isinstance(GeometryHandlering, PointCloudGeometryHandleringXYZ): return True
        else: return False


cdef class vtkSmartPointerRenderWindow:
    # cdef vtk_defs.vtkRenderWindow_Ptr_t thisptr_shared     # vtkRenderWindow
    cdef vtk_defs.vtkSmartPointer[vtk_defs.vtkRenderWindow] thisptr_shared
    
    # cdef inline vtk_defs.vtkRenderWindow *thisptr(self) nogil:
    cdef inline vtk_defs.vtkSmartPointer[vtk_defs.vtkRenderWindow] thisptr(self) nogil:
        # Shortcut to get raw pointer to underlying vtkRenderWindow.
        return self.thisptr_shared

