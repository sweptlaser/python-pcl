# -*- coding: utf-8 -*-
# cython: embedsignature=True
from libcpp cimport bool

from collections import Sequence
import numbers
import numpy as np
cimport vtk_defs
cimport pcl_defs as cpp

import vtk
if not (vtk.VTK_MAJOR_VERSION == vtk_defs.VTK_MAJOR_VERSION and vtk.VTK_MINOR_VERSION == vtk_defs.VTK_MINOR_VERSION):
    raise Exception("VTK Runtime version({}.{}) does not match VTK build version({}.{})".format(vtk.VTK_MAJOR_VERSION,
                                                                                                vtk.VTK_MINOR_VERSION,
                                                                                                vtk_defs.VTK_MAJOR_VERSION,
                                                                                                vtk_defs.VTK_MINOR_VERSION))

import platform
if cpp.VTK_RENDERING_BACKEND_OPENGL_VERSION == 1:
    VTK_RENDERING_BACKEND="OpenGL"
elif cpp.VTK_RENDERING_BACKEND_OPENGL_VERSION == 2:
    VTK_RENDERING_BACKEND="OpenGL2"
else:
    raise Exception("could not detect VTK build backend")
if platform.system() == "Windows":
    base_compare='vtkIOExport'
else:
    base_compare='vtkRendering'
if not '{}{}'.format(base_compare, VTK_RENDERING_BACKEND) in dir(vtk):
    raise Exception("VTK runtime backend does not match VTK build backend ({})".format(VTK_RENDERING_BACKEND))
del base_compare

cimport numpy as cnp

cimport pcl_defs as cpp
cimport pcl_visualization_defs as pcl_vis

cimport cython
# from cython.operator import dereference as deref
from cython.operator cimport dereference as deref, preincrement as inc

from cpython cimport Py_buffer

from libcpp.string cimport string
from libcpp cimport bool
from libcpp.vector cimport vector

from boost_shared_ptr cimport sp_assign

cnp.import_array()

### Enum ###

### Enum Setting ###
# pcl_visualization_defs.pxd
# cdef enum RenderingProperties:
# Re: [Cython] resolving name conflict -- does not work for enums !? 
# https://www.mail-archive.com/cython-dev@codespeak.net/msg02494.html
PCLVISUALIZER_POINT_SIZE = pcl_vis.PCL_VISUALIZER_POINT_SIZE
PCLVISUALIZER_OPACITY = pcl_vis.PCL_VISUALIZER_OPACITY
PCLVISUALIZER_LINE_WIDTH = pcl_vis.PCL_VISUALIZER_LINE_WIDTH
PCLVISUALIZER_FONT_SIZE = pcl_vis.PCL_VISUALIZER_FONT_SIZE
PCLVISUALIZER_COLOR = pcl_vis.PCL_VISUALIZER_COLOR
PCLVISUALIZER_REPRESENTATION = pcl_vis.PCL_VISUALIZER_REPRESENTATION
PCLVISUALIZER_IMMEDIATE_RENDERING = pcl_vis.PCL_VISUALIZER_IMMEDIATE_RENDERING
PCLVISUALIZER_SHADING = pcl_vis.PCL_VISUALIZER_SHADING
PCLVISUALIZER_LUT = pcl_vis.PCL_VISUALIZER_LUT
PCLVISUALIZER_LUT_RANGE = pcl_vis.PCL_VISUALIZER_LUT_RANGE

# cdef enum RenderingRepresentationProperties:
PCLVISUALIZER_REPRESENTATION_POINTS = pcl_vis.PCL_VISUALIZER_REPRESENTATION_POINTS
PCLVISUALIZER_REPRESENTATION_WIREFRAME = pcl_vis.PCL_VISUALIZER_REPRESENTATION_WIREFRAME
PCLVISUALIZER_REPRESENTATION_SURFACE = pcl_vis.PCL_VISUALIZER_REPRESENTATION_SURFACE

# cdef enum LookUpTableRepresentationProperties:
PCLVISUALIZER_LUT_JET = pcl_vis.PCL_VISUALIZER_LUT_JET
PCLVISUALIZER_LUT_JET_INVERSE = pcl_vis.PCL_VISUALIZER_LUT_JET_INVERSE
PCLVISUALIZER_LUT_HSV = pcl_vis.PCL_VISUALIZER_LUT_HSV
PCLVISUALIZER_LUT_INVERSE = pcl_vis.PCL_VISUALIZER_LUT_HSV_INVERSE
PCLVISUALIZER_LUT_GREY = pcl_vis.PCL_VISUALIZER_LUT_GREY
PCLVISUALIZER_LUT_BLUE2RED = pcl_vis.PCL_VISUALIZER_LUT_BLUE2RED
PCLVISUALIZER_LUT_RANGE_AUTO = pcl_vis.PCL_VISUALIZER_LUT_RANGE_AUTO
PCLVISUALIZER_LUT_VIRIDIS = pcl_vis.PCL_VISUALIZER_LUT_VIRIDIS


### Enum Setting(define Class InternalType) ###

###

# PointCloud/Common
# NG
# include "pxi/PointCloud__PointXYZ.pxi"
# include "pxi/PointCloud__PointXYZI.pxi"
# include "pxi/Common/RangeImage/RangeImages.pxi"

# VTK - Handler(Color)
include "pxi/Visualization/Handler/PointCloudColorHandlering.pxi"
include "pxi/Visualization/Handler/PointCloudColorHandleringCustom.pxi"
include "pxi/Visualization/Handler/PointCloudColorHandleringGenericField.pxi"
include "pxi/Visualization/Handler/PointCloudColorHandleringHSVField.pxi"
include "pxi/Visualization/Handler/PointCloudColorHandleringRandom.pxi"
include "pxi/Visualization/Handler/PointCloudColorHandleringRGBField.pxi"
include "pxi/Visualization/Handler/PointCloudGeometryHandleringCustom.pxi"
include "pxi/Visualization/Handler/PointCloudGeometryHandleringSurfaceNormal.pxi"
include "pxi/Visualization/Handler/PointCloudGeometryHandlering.pxi"
include "pxi/Visualization/Handler/PointCloudGeometryHandleringXYZ.pxi"

# VTK
include "pxi/Visualization/CloudViewing.pxi"
include "pxi/Visualization/PCLVisualizering.pxi"
include "pxi/Visualization/PCLHistogramViewing.pxi"
# include "pxi/Visualization/RangeImageVisualization.pxi"
include "pxi/Visualization/vtkSmartPointerRenderWindow.pxi"

# NG(vtk Link Error)
# include "pxi/Visualization/RangeImageVisualization.pxi"
# include "pxi/Visualization/PCLHistogramViewing.pxi"
