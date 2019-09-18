#ifndef _VTK_CONVERT_CPP__
#define _VTK_CONVERT_CPP__

#include <iostream>
#include <sstream>
#include <boost/python.hpp>
//#include <vtkPythonCompatibility.h>
#include <boost/python/module.hpp>
#include <boost/python/stl_iterator.hpp>
#define _BACKWARD_BACKWARD_WARNING_H 1 //Ignore vtk deprecated warnings
#include <vtkSmartPointer.h>
#include <vtkObjectBase.h>

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
    //boost::python::object obj = import("vtk").attr("vtkObjectBase")(address_str);
    object obj = import("vtk").attr("vtkObjectBase")(address_str);

    // Important to increment object reference
    return incref(obj.ptr());
}

#endif //_VTK_CONVERT_CPP__