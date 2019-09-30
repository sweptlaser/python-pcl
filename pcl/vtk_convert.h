#ifndef _VTK_CONVERT_CPP__
#define _VTK_CONVERT_CPP__

#include <iostream>
#include <sstream>
#include <boost/python.hpp>
//#include <vtkPythonCompatibility.h>
//#include <boost/python/module.hpp>
//#include <boost/python/stl_iterator.hpp>
#define _BACKWARD_BACKWARD_WARNING_H 1 //Ignore vtk deprecated warnings
#include <vtkSmartPointer.h>
#include <vtkObjectBase.h>
#include <vtkRenderWindow.h>
#include <vtkRenderWindowInteractor.h>
#include <PyVTKObject.h>
#include <vtkSmartPyObject.h>
//#include <vtkPythonUtil.h>


using namespace boost::python;


/**
 *  Do the conversion
 *  @param rVtkSmartPointerToObject a vtk smart pointer
 *  @return A pointer to the Python object. Can be a None object if the smart pointer is empty.
 *  Example from   https://vtk.org/Wiki/Example_from_and_to_python_converters
 */
 static PyObject* convertSmartPointer(const vtkSmartPointer<vtkRenderWindow> &rVtkSmartPointer)
{
    // Make sure something is being pointed to, otherwise return python None type
    if(rVtkSmartPointer.GetPointer() == NULL)
    {
        return incref(Py_None);
    }

    // Get the address string of the vtk object
    std::ostringstream oss;
    oss << (void*) rVtkSmartPointer.GetPointer();
    std::string address_str = oss.str();

    // Can get vtk object type from address string using vtk tricks
    object obj;
    try
    {
        obj = import("vtk").attr("vtkObjectBase")(address_str);
    }
    catch(...)
    {
        return NULL;
    }

    // Important to increment object reference
    return incref(obj.ptr());
}

 static PyObject* convertRenderer(const vtkSmartPointer<vtkRendererCollection> &rVtkSmartPointer)
{
    // Make sure something is being pointed to, otherwise return python None type
    if(rVtkSmartPointer.GetPointer() == NULL)
    {
        return incref(Py_None);
    }

    // Get the address string of the vtk object
    std::ostringstream oss;
    oss << (void*) rVtkSmartPointer.GetPointer();
    std::string address_str = oss.str();

    // Can get vtk object type from address string using vtk tricks
    object obj;
    try
    {
        obj = import("vtk").attr("vtkObjectBase")(address_str);
    }
    catch(...)
    {
        return NULL;
    }
    // Important to increment object reference
    return incref(obj.ptr());
}

// This python to C++ converter uses the fact that VTK Python objects have an
// attribute called __this__, which is a string containing the memory address
// of the VTK C++ object and its class name.
// E.g. for a vtkPoints object __this__ might be "_0000000105a64420_p_vtkPoints"
//
vtkObjectBase* ExtractVtkWrappedPointer(PyObject* pPythonObject)
{

    vtkObjectBase* test = PyVTKObject_GetObject(pPythonObject);
    return test;
};

vtkSmartPointer<vtkRenderer> GetVtkSmartPointerRenderer(PyObject* pPythonObject)
{
    auto vtk_object = ExtractVtkWrappedPointer(pPythonObject);
    auto vtk_renderer = vtkRenderer::SafeDownCast(vtk_object);
    vtkSmartPointer<vtkRenderer> SmartPointer = vtkSmartPointer<vtkRenderer>::Take(vtk_renderer);
    return SmartPointer;
}

vtkSmartPointer<vtkRenderWindow> GetVtkSmartPointerRenderWindow(PyObject* pPythonObject)
{
    vtkObjectBase* vtk_object_base = ExtractVtkWrappedPointer(pPythonObject);
    auto vtk_renderwindow = vtkRenderWindow::SafeDownCast(vtk_object_base);
    vtkSmartPointer<vtkRenderWindow> SmartPointer = vtkSmartPointer<vtkRenderWindow>::Take(vtk_renderwindow);

    return SmartPointer;
}

void* GetVtkRenderWindowInteractor(PyObject* pPythonObject)
{
    auto vtk_object = ExtractVtkWrappedPointer(pPythonObject);
    return vtk_object;
}

void* GetVtkRenderWindow(PyObject* pPythonObject)
{
    auto vtk_object = ExtractVtkWrappedPointer(pPythonObject);
    return vtk_object;
}

#endif //_VTK_CONVERT_CPP__
