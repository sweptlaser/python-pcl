#ifndef _VTK_CONVERT_CPP__
#define _VTK_CONVERT_CPP__

#include <iostream>
#include <sstream>
#include <boost/python.hpp>
#include <vtkSmartPointer.h>
#include <vtkObjectBase.h>
#include <vtkRenderWindow.h>


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
    // Get the __this__ attribute from the Python Object
    char thisStr[] = "__this__";

    // Several checks to make sure it is a valid vtk type, otherwise return a null pointer
    if (!PyObject_HasAttrString(pPythonObject, thisStr))
    {
        return NULL;
    }

    PyObject* thisAttr = PyObject_GetAttrString(pPythonObject, thisStr);
    if (thisAttr == NULL)
    {
        return NULL;
    }
    PyObject* thisAttrUni = PyUnicode_FromObject(thisAttr);
    const char* str = PyUnicode_AsUTF8(thisAttrUni);
    if(str == 0 || strlen(str) < 1)
    {
        return NULL;
    }

    char hex_address[100], *pEnd;
    const char *_p_ = strstr(str, "_p_vtk");
    if(_p_ == NULL)
    {
        return NULL;
    }

    const char *class_name = strstr(_p_, "vtk");
    if(class_name == NULL)
    {
        return NULL;

    }

    // Create a generic vtk object pointer and assign the address of the python object to it
    ::strcpy(hex_address, str+1);
    hex_address[_p_-str-1] = '\0';
    uint64_t address = strtoll(hex_address, &pEnd, 16);

    vtkObjectBase* vtk_object = (vtkObjectBase*)((void*)address);
    if(vtk_object->IsA(class_name))
    {
        vtk_object->Register(NULL);
        return vtk_object;
    }

    // Catch all in case something goes wrong
    return NULL;
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

#endif //_VTK_CONVERT_CPP__
