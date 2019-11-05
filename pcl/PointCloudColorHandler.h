#include <pcl/point_cloud.h>
#include <pcl/point_types.h>

typedef void (*PointCloudColorHandler_callback_t)(PyObject* o, vtkSmartPointer<vtkDataArray> &scalars);

class PointCloudColorHandler_PCLPointCloud2: public PointCloudColorHandler<pcl::PCLPointCloud2>
{
      public:
        using PointCloud = PointCloudColorHandler<pcl::PCLPointCloud2>::PointCloud;
        using PointCloudPtr = PointCloud::Ptr;
        using PointCloudConstPtr = PointCloud::ConstPtr;

        using Ptr = boost::shared_ptr<PointCloudColorHandler_PCLPointCloud2>;
        using ConstPtr = boost::shared_ptr<const PointCloudColorHandler_PCLPointCloud2>;

        /** \brief Constructor. */
        PointCloudColorHandler_PCLPointCloud2 (const PointCloudConstPtr &cloud,
                                               PyObject* object,
                                               PointCloudColorHandler_callback_t callback)
            : PointCloudColorHandler<pcl::PCLPointCloud2>(cloud), m_pythonObject(object),
            m_pythonCallback(callback)
        {
            capable_ = true;
        }

        /** \brief Destructor. */
        virtual ~PointCloudColorHandler_PCLPointCloud2 () {}

        /** \brief Class getName method. */
        virtual std::string 
        getName () const { return ("PointCloudColorHandler_PCLPointCloud2"); }

        /** \brief Get the name of the field used. */
        virtual std::string
        getFieldName () const { return ""; }

        /** \brief Obtain the actual color for the input dataset as a VTK data array. */
        virtual bool
        getColor (vtkSmartPointer<vtkDataArray> &scalars) const {
            if (!capable_)
                throw std::runtime_error("getColor requires an assigned point cloud");
            if (!scalars)
                scalars = vtkSmartPointer<vtkUnsignedCharArray>::New ();
            m_pythonCallback(m_pythonObject, scalars);
            return scalars;
        }

    private:
        PyObject* m_pythonObject;
        PointCloudColorHandler_callback_t m_pythonCallback;
};
