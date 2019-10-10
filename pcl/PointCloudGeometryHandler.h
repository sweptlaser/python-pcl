#include <pcl/point_cloud.h>
#include <pcl/point_types.h>

typedef void (*pythonCallback_t)(PyObject* o, vtkSmartPointer<vtkPoints> &points);

class PointCloudGeometryHandler_PCLPointCloud2: public PointCloudGeometryHandler<pcl::PCLPointCloud2>
{
      public:
        using PointCloud = PointCloudGeometryHandler<pcl::PCLPointCloud2>::PointCloud;
        using PointCloudPtr = PointCloud::Ptr;
        using PointCloudConstPtr = PointCloud::ConstPtr;

        using Ptr = boost::shared_ptr<PointCloudGeometryHandler_PCLPointCloud2>;
        using ConstPtr = boost::shared_ptr<const PointCloudGeometryHandler_PCLPointCloud2>;

        /** \brief Constructor. */
        PointCloudGeometryHandler_PCLPointCloud2 (const PointCloudConstPtr &cloud,
                                                  PyObject* object, pythonCallback_t callback)
            : PointCloudGeometryHandler<pcl::PCLPointCloud2>(cloud), m_pythonObject(object),
            m_pythonCallback(callback)
        {
            field_x_idx_ = pcl::getFieldIndex (*cloud, "x");
            if (field_x_idx_ == -1)
                return;
            field_y_idx_ = pcl::getFieldIndex (*cloud, "y");
            if (field_y_idx_ == -1)
                return;
            field_z_idx_ = pcl::getFieldIndex (*cloud, "z");
            if (field_z_idx_ == -1)
                return;
            capable_ = true;
        }

        /** \brief Destructor. */
        virtual ~PointCloudGeometryHandler_PCLPointCloud2 () {}

        /** \brief Class getName method. */
        virtual std::string 
        getName () const { return ("PointCloudGeometryHandler_PCLPointCloud2"); }

        /** \brief Get the name of the field used. */
        virtual std::string
        getFieldName () const { return ("xyz"); }

        /** \brief Obtain the actual point geometry for the input dataset in VTK format.
          * \param[out] points the resultant geometry
          */
        virtual void
        getGeometry (vtkSmartPointer<vtkPoints> &points) const {
            if (!capable_)
                throw std::runtime_error("getGeometry requires an assigned point cloud");
            if (!points)
                points = vtkSmartPointer<vtkPoints>::New ();
            m_pythonCallback(m_pythonObject, points);
        }

    private:
        PyObject* m_pythonObject;
        pythonCallback_t m_pythonCallback;
};
