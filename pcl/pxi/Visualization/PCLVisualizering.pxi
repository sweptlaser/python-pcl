# -*- coding: utf-8 -*-
cimport _pcl
cimport pcl_defs as cpp
cimport numpy as cnp

cimport cython
cimport pcl_visualization

cimport pcl_visualization_defs as pcl_vis
cimport vtk_defs
import vtk

from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector
from cpython.ref cimport PyObject

from boost_shared_ptr cimport shared_ptr
from boost_shared_ptr cimport sp_assign


cdef class PCLVisualizering:
    """
    """
    cdef pcl_vis.PCLVisualizerPtr_t thisptr_shared
    cdef vtk_defs.vtkSmartPointerRendererPtrT renptr_shared
    cdef vtk_defs.vtkSmartPointerRenderWindowPtrT winptr_shared

    def __cinit_simple__(self, bytes name, bool create_interactor):
        sp_assign(self.thisptr_shared, new pcl_vis.PCLVisualizer(name, create_interactor))
        self.winptr_shared = self.thisptr().getRenderWindow()

    def __cinit_renderer__(self, ren, wind, bytes name, bool create_interactor):
        self.renptr_shared = vtk_defs.GetVtkSmartPointer[vtk_defs.vtkRenderer](<PyObject *>ren)
        self.winptr_shared = vtk_defs.GetVtkSmartPointer[vtk_defs.vtkRenderWindow](<PyObject *>wind)
        sp_assign(self.thisptr_shared, new pcl_vis.PCLVisualizer(self.renptr_shared, self.winptr_shared, name, create_interactor))

    def __cinit__(self, *pargs, **kwargs):
        name = b'visual'
        create_interactor = True
        ren = None
        wind = None

        # handle positional arguments
        if len(pargs) > 0:
            if isinstance(pargs[0], unicode) or isinstance(pargs[0], bytes):
                name = pargs[0]
            elif isinstance(pargs[0], vtk.vtkRenderer):
                ren = pargs[0]
            else:
                raise Exception('Unsupported constructor call')
        if len(pargs) > 1:
            if isinstance(pargs[1], int):
                create_interactor = pargs[1]
            elif isinstance(pargs[1], vtk.vtkRenderWindow):
                wind = pargs[1]
            else:
                raise Exception('Unsupported constructor call')
        if len(pargs) > 2:
            if isinstance(pargs[2], unicode) or isinstance(pargs[2], bytes):
                name = pargs[2]
            else:
                raise Exception('Unsupported constructor call')
        if len(pargs) > 3:
            if isinstance(pargs[3], int):
                create_interactor = pargs[3]
            else:
                raise Exception('Unsupported constructor call')

        # handle keyword arguments
        if 'ren' in kwargs:
            ren = kwargs['ren']
        if 'wind' in kwargs:
            wind = kwargs['wind']
        if 'name' in kwargs:
            name = kwargs['name']
        if 'create_interactor' in kwargs:
            create_interactor = kwargs['create_interactor']

        # handle argument type conversion
        cdef bytes _name
        if isinstance(name, unicode):
            _name = name.encode("ascii")
        elif isinstance(name, bytes):
            _name = name
        else:
            raise TypeError("name should be a string, got %r" % name)

        if (ren is None and wind is None):
            self.__cinit_simple__(_name, create_interactor)
        else:
            self.__cinit_renderer__(ren, wind, _name, create_interactor)

    cdef inline pcl_vis.PCLVisualizer *thisptr(self) nogil:
        # Shortcut to get raw pointer to underlying PCLVisualizer
        return self.thisptr_shared.get()

    def SetFullScreen(self, bool mode):
        # """
        # :type mode: bool
        #  """
        self.thisptr().setFullScreen(mode)

    def SetWindowBorders(self, bool mode):
        # """
        # :type mode: bool
        #  """
        self.thisptr().setWindowBorders(mode)

    def Spin(self):
        self.thisptr().spin()

    def SpinOnce(self, int millis_to_wait = 1, bool force_redraw = False):
        self.thisptr().spinOnce (millis_to_wait, force_redraw)

    def AddCoordinateSystem(self, double scale = 1.0, int viewpoint = 0):
        # 1.7?
        # self.thisptr().addCoordinateSystem(scale, viewpoint)
        # 1.8/1.9
        self.thisptr().addCoordinateSystem(scale, b'reference', viewpoint)

    def AddCoordinateSystem(self, double scale, float x, float y, float z, int viewpoint = 0):
        # 1.7?
        # self.thisptr().addCoordinateSystem(scale, x, y, z, viewpoint)
        # 1.8/1.9
        self.thisptr().addCoordinateSystem(scale, x, y, z, b'reference', viewpoint)

    # void addCoordinateSystem (double scale, const eigen3.Affine3f& t, int viewport)

    # return bool
    def removeCoordinateSystem (self, int viewport):
        # 1.7?
        # return self.thisptr().removeCoordinateSystem (viewport)
        # 1.8/1.9
        return self.thisptr().removeCoordinateSystem (b'reference', viewport)

    # return bool
    def RemovePointCloud(self, string id, int viewport):
        return self.thisptr().removePointCloud (id, viewport)

    def RemovePolygonMesh(self, string id, int viewport):
        return self.thisptr().removePolygonMesh (id, viewport)

    def RemoveShape(self, string id, int viewport):
        return self.thisptr().removeShape (id, viewport)

    def RemoveText3D(self, string id, int viewport):
        return self.thisptr().removeText3D (id, viewport)

    def RemoveAllPointClouds(self, int viewport):
        return self.thisptr().removeAllPointClouds (viewport)

    def RemoveAllShapes(self, int viewport):
        return self.thisptr().removeAllShapes (viewport)

    def SetBackgroundColor (self, int r, int g, int b):
        self.thisptr().setBackgroundColor(r, g, b, 0)

    # return bool
    def AddText (self, string text, int xpos, int ypos, id, int viewport):
        return self.thisptr().addText (text, xpos, ypos, <string> id, viewport)

    # return bool
    def AddText (self, string text, int xpos, int ypos, double r, double g, double b, id, int viewport):
        return self.thisptr().addText (text, xpos, ypos, r, g, b, <string> id, viewport)

    # return bool
    def AddText (self, string text, int xpos, int ypos, int fontsize, double r, double g, double b, id, int viewport):
        return self.thisptr().addText (text, xpos, ypos, fontsize, r, g, b, <string> id, viewport)

    # return bool
    # def UpdateText (self, string text, int xpos, int ypos, const string &id):
    def UpdateText (self, string text, int xpos, int ypos, id):
        return self.thisptr().updateText (text, xpos, ypos, <string> id)

    # return bool
    # def UpdateText (self, string text, int xpos, int ypos, double r, double g, double b, const string &id):
    def UpdateText (self, string text, int xpos, int ypos, double r, double g, double b, id):
        return self.thisptr().updateText (text, xpos, ypos,  r,  g,  b, <string> id)

    # return bool
    # def UpdateText (self, string text, int xpos, int ypos, int fontsize, double r, double g, double b, const string &id):
    def UpdateText (self, string text, int xpos, int ypos, int fontsize, double r, double g, double b, id):
        return self.thisptr().updateText (text, xpos, ypos, fontsize, r, g, b, <string> id)

    # bool updateShapePose (const string &id, const eigen3.Affine3f& pose)

    # return bool
    # def AddText3D[PointT](const string &text, const PointT &position, double textScale, double r, double g, double b, const string &id, int viewport)
    #     return self.thisptr().AddText3D[PointT](const string &text, const PointT &position, double textScale, double r, double g, double b, const string &id, int viewport)
    # def add_text3D(self, string text, PointT position, double textScale, double r, double g, double b, string id, int viewport)
    # @cython.cfunc
    # @cython.returns(cython.bool)
    # @cython.locals(a=cython.string, position=cython.array, textScale=cython.double, r=cython.double, g=cython.double, b=cython.double, dx=cython.string, viewport=cython.int)
    def add_text3D(self, text, position, textScale, r, g, b, id, viewport):
        cdef cpp.PointXYZ pt_pos
        pt_pos.x = position[0]
        pt_pos.y = position[1]
        pt_pos.z = position[2]
        cdef bytes text_ascii
        if isinstance(text, unicode):
            text_ascii = text.encode("ascii")
        elif not isinstance(text, bytes):
            raise TypeError("text should be a string, got %r" % text)
        else:
            text_ascii = text

        cdef bytes id_ascii
        if isinstance(id, unicode):
            id_ascii = id.encode("ascii")
        elif not isinstance(id, bytes):
            raise TypeError("id should be a string, got %r" % id)
        else:
            id_ascii = id

        return self.thisptr().addText3D[cpp.PointXYZ](text_ascii, pt_pos, textScale, r, g, b, id_ascii, viewport)

    # bool addPointCloudNormals [PointNT](cpp.PointCloud[PointNT] cloud, int level, double scale, string id, int viewport)
    # bool addPointCloudNormals [PointT, PointNT] (const shared_ptr[cpp.PointCloud[PointT]] &cloud, const shared_ptr[cpp.PointCloud[PointNT]] &normals, int level, double scale, const string &id, int viewport)

    # bool updatePointCloud[PointT](const shared_ptr[cpp.PointCloud[PointT]] &cloud, string &id)
    # bool updatePointCloud[PointT](const shared_ptr[cpp.PointCloud[PointT]] &cloud, const PointCloudGeometryHandler[PointT] &geometry_handler, string &id)

    # def updatePointCloud(self, _pcl.PointCloud cloud, string id = 'cloud'):
    #     flag = self.thisptr().updatePointCloud[cpp.PointXYZ](<cpp.PointCloudPtr_t> cloud.thisptr_shared, id)
    #     return flag

    # def AddPointCloud (self, _pcl.PointCloud cloud, string id = 'cloud', int viewport = 0):
    # call (ex. id=b'range image')
    def AddPointCloud (self, _pcl.PointCloudTypes cloud, id = b'cloud', int viewport = 0):
        pcl_vis.pcl_visualization_PCLVisualizer_addPointCloud(deref(self.thisptr()), cloud.thisptr_shared, <string> id, viewport)

    # <const shared_ptr[PointCloudColorHandler[PointT]]> 
    # def AddPointCloud_ColorHandler(self, _pcl.PointCloud cloud, pcl_visualization.PointCloudColorHandleringCustom color_handler, string id = 'cloud', int viewport = 0):
    def AddPointCloud_ColorHandler(self, _pcl.PointCloudTypes cloud, pcl_visualization.PointCloudColorHandleringTypes color_handler, id = b'cloud', viewport = 0):
        # NG : Base Class
        # self.thisptr().addPointCloud[cpp.PointXYZ](cloud.thisptr_shared, <const pcl_vis.PointCloudColorHandler[cpp.PointXYZ]> deref(color_handler.thisptr_shared.get()), id, viewport)
        # OK? : Inheritance Class(PointCloudColorHandler)
        # self.thisptr().addPointCloud[cpp.PointXYZ](cloud.thisptr_shared, <const pcl_vis.PointCloudColorHandlerCustom[cpp.PointXYZ]> deref(color_handler.thisptr_shared.get()), id, viewport)
        cdef bytes id_ascii
        if isinstance(id, unicode):
            id_ascii = id.encode("ascii")
        elif not isinstance(id, bytes):
            raise TypeError("id should be a string, got %r" % id)
        else:
            id_ascii = id

        pcl_vis.pcl_visualization_PCLVisualizer_addPointCloud(deref(self.thisptr()), cloud.thisptr_shared, deref(color_handler.thisptr()), id_ascii, viewport)

    def AddPointCloud_ColorHandler(self, _pcl.RangeImages cloud, pcl_visualization.PointCloudColorHandleringCustom color_handler, id = b'cloud', int viewport = 0):
        # self.thisptr().addPointCloud[cpp.PointWithRange](cloud.thisptr_shared, <const pcl_vis.PointCloudColorHandlerCustom[cpp.PointXYZ]> deref(color_handler.thisptr_shared.get()), id, viewport)
        pass

    # <const shared_ptr[PointCloudGeometryHandler[PointT]]> 
    # def AddPointCloud_GeometryHandler(self, _pcl.PointCloud cloud, pcl_visualization.PointCloudGeometryHandleringCustom geometry_handler, id = b'cloud', int viewport = 0):
    #     # overloaded
    #     self.thisptr().addPointCloud[cpp.PointXYZ](cloud.thisptr_shared, <const pcl_vis.PointCloudGeometryHandlerCustom[cpp.PointXYZ]> deref(geometry_handler.thisptr_shared.get()), <string> id, viewport)
    #     # pass

    def AddPointCloudNormals(self, _pcl.PointCloud cloud, _pcl.PointCloud_Normal normal, int level = 100, double scale = 0.02, id = b'normals', int viewport = 0):
        self.thisptr().addPointCloudNormals[cpp.PointXYZ, cpp.Normal](<cpp.PointCloudPtr_t> cloud.thisptr_shared, <cpp.PointCloud_Normal_Ptr_t> normal.thisptr_shared, level, scale, <string> id, viewport)


    def AddPointCloud_PCLPointCloud2(self, *pargs, **kwargs):
        if ('geometry_handler' in kwargs) or (len(pargs) > 1 and pcl_visualization.isPointCloudGeometryHandlering(pargs[1])):
            self.AddPointCloud_PCLPointCloud2_GeometryHandler(*pargs, **kwargs)
        else:
            self.AddPointCloud_PCLPointCloud2_ColorHandler(*pargs, **kwargs)

    def AddPointCloud_PCLPointCloud2_ColorHandler(self, _pcl.PCLPointCloud2 cloud, pcl_visualization.PointCloudColorHandleringTypes color_handler, vector[float] origin, vector[float] orientation, id = b'cloud', int viewport = 0):
        cdef cpp.Vector4f _origin = cpp.Vector4f(origin[0], origin[1], origin[2], 0.0)
        cdef cpp.Quaternionf _orientation = cpp.Quaternionf(orientation[0], orientation[1], orientation[2], orientation[3])
        cdef bytes _id
        if isinstance(id, unicode):
            _id = id.encode("ascii")
        elif isinstance(id, bytes):
            _id = id
        else:
            raise TypeError("id should be a string, got %r" % id)
        cdef pcl_vis.PointCloudColorHandler_PCLPointCloud2_Ptr_t _ch
        _ch = pcl_vis._to_PointCloudColorHandler_PCLPointCloud2_Ptr_t(color_handler.thisptr_shared)
        self.thisptr().addPointCloud_PCLPointCloud2(cloud.thisptr_shared, _ch, _origin, _orientation, _id, viewport)

    def AddPointCloud_PCLPointCloud2_GeometryHandler(self, _pcl.PCLPointCloud2 cloud, pcl_visualization.PointCloudGeometryHandleringTypes geometry_handler, pcl_visualization.PointCloudColorHandleringTypes color_handler, vector[float] origin, vector[float] orientation, id = b'cloud', int viewport = 0):
        cdef cpp.Vector4f _origin = cpp.Vector4f(origin[0], origin[1], origin[2], 0.0)
        cdef cpp.Quaternionf _orientation = cpp.Quaternionf(orientation[0], orientation[1], orientation[2], orientation[3])
        cdef bytes _id
        if isinstance(id, unicode):
            _id = id.encode("ascii")
        elif isinstance(id, bytes):
            _id = id
        else:
            raise TypeError("id should be a string, got %r" % id)
        cdef pcl_vis.PointCloudGeometryHandler_PCLPointCloud2_Ptr_t _gh
        _gh = pcl_vis._to_PointCloudGeometryHandler_PCLPointCloud2_Ptr_t(geometry_handler.thisptr_shared)
        cdef pcl_vis.PointCloudColorHandler_PCLPointCloud2_Ptr_t _ch
        _ch = pcl_vis._to_PointCloudColorHandler_PCLPointCloud2_Ptr_t(color_handler.thisptr_shared)
        self.thisptr().addPointCloud_PCLPointCloud2(cloud.thisptr_shared, _gh, _ch, _origin, _orientation, _id, viewport)

    def SetPointCloudRenderingProperties(self, *pargs, **kwargs):
        if (len(pargs) == 3):
            self.SetPointCloudRenderingProperties_SingleValue(*pargs, **kwargs)
        elif (len(pargs) == 5):
            self.SetPointCloudRenderingProperties_ThreeValues(*pargs, **kwargs)

    def SetPointCloudRenderingProperties_SingleValue(self, int propType, int propValue, propName = b'cloud'):
        self.thisptr().setPointCloudRenderingProperties(propType, propValue, <string> propName, 0)

    def SetPointCloudRenderingProperties_ThreeValues(self, int propType, int propValueA, int propValueB, int propValueC, propName = b'cloud'):
        self.thisptr().setPointCloudRenderingProperties(propType, propValueA, propValueB, propValueC, <string> propName, 0)

    def InitCameraParameters(self):
        self.thisptr().initCameraParameters()

    # return bool
    def WasStopped(self):
        return self.thisptr().wasStopped()

    def ResetStoppedFlag(self):
        self.thisptr().resetStoppedFlag()

    def Close(self):
        self.thisptr().close ()

    # def AddCube(self, double min_x, double max_x, double min_y, double max_y, double min_z, double max_z, double r, double g, double b, string name):
    def AddCube(self, double min_x, double max_x, double min_y, double max_y, double min_z, double max_z, double r, double g, double b, name):
        cdef bytes name_ascii
        if isinstance(name, unicode):
            name_ascii = name.encode("ascii")
        elif not isinstance(name, bytes):
            raise TypeError("name should be a string, got %r" % name)
        else:
            name_ascii = name
        self.thisptr().addCube(min_x,  max_x,  min_y,  max_y,  min_z,  max_z, r, g, b, name_ascii, 0)

    # def AddLine(self, _pcl.PointCloud center, _pcl.PointCloud axis, double x, double y, double z, id = b'minor eigen vector')
    #     # pcl::PointXYZ
    #     self.thisptr().addLine(center, z_axis, 0.0, 0.0, 1.0, id)

    def AddCone(self):
        # self.thisptr().addCone()
        pass

    def AddCircle(self):
        # self.thisptr().addCone()
        pass

    def AddPlane(self):
        # self.thisptr().addPlane()
        pass

    def AddLine(self):
        # self.thisptr().addLine()
        pass

    def AddSphere(self):
        # self.thisptr().addSphere()
        pass

    def AddCylinder(self):
        # self.thisptr().addCylinder()
        pass

    def AddCircle(self):
        # self.thisptr().addCone()
        pass

    def setShowFPS(self, show_fps):
        self.thisptr().setShowFPS(show_fps)

    def get_render_window(self):
        cdef PyObject* converted_PY = vtk_defs.convertSmartPointer[vtk_defs.vtkRenderWindow](self.winptr_shared)
        if converted_PY == NULL:
            return None
        return <object>converted_PY

    # int property, double value, const string id, int viewport
    def set_shape_rendering_properties(self, property, value, id, viewport=0):
        cdef bytes id_ascii
        if isinstance(id, unicode):
            id_ascii = id.encode("ascii")
        elif not isinstance(id, bytes):
            raise TypeError("id should be a string, got %r" % id)
        else:
            id_ascii = id

        return self.thisptr().setPointCloudRenderingProperties (property, value, id_ascii, viewport)
        # pass

    def remove_all_pointclouds(self, viewport=0):
        self.thisptr().removeAllPointClouds(viewport)
        pass

    def remove_all_shapes(self, viewport=0):
        self.thisptr().removeAllPointClouds(viewport)
        pass
