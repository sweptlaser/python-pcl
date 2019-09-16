#ifndef __TYPEDEFERRAL_CPP__
#define __TYPEDEFERRAL_CPP__

/*
 * Defer type resolution of routines for fused types until the C++ takes a look at it.  This is a
 * workaround for poor type inference where we have something that looks like:
 *     ret function[PointT](PointCloud<PointT>& var)
 */

#include <boost/shared_ptr.hpp>

using namespace pcl;
using namespace pcl::visualization;

template <typename PointCloudPtrT>
inline bool
pcl_visualization_PCLVisualizer_addPointCloud(PCLVisualizer& visual,
                                              const PointCloudPtrT &cloud,
                                              const std::string &id = "cloud", int viewport = 0)
{
  return visual.addPointCloud<typename PointCloudPtrT::element_type::value_type> (cloud, id, viewport);
}

template <typename PointCloudPtrT>
inline PointCloudColorHandlerGenericField<typename PointCloudPtrT::element_type::value_type>*
pcl_visualization_newPointCloudColorHandlerGenericField (const PointCloudPtrT &cloud, const std::string &field)
{
  return new PointCloudColorHandlerGenericField<typename PointCloudPtrT::element_type::value_type>(cloud, field);
}

template <typename PointCloudPtrT, template<typename> typename PointCloudColorHandlerT>
inline bool
pcl_visualization_PCLVisualizer_addPointCloud(PCLVisualizer& visual,
                                              const PointCloudPtrT &cloud,
                                              const PointCloudColorHandlerT<PointXYZ> &color_handler,
                                              const std::string &id = "cloud", int viewport = 0)
{
  const PointCloudColorHandlerT<typename PointCloudPtrT::element_type::value_type> &ch = reinterpret_cast<const PointCloudColorHandlerT<typename PointCloudPtrT::element_type::value_type> &>(color_handler);
  return visual.addPointCloud<typename PointCloudPtrT::element_type::value_type> (cloud, ch, id, viewport);
}

inline boost::shared_ptr<PointCloudColorHandler<PCLPointCloud2>>&
_to_PointCloudColorHandler_PCLPointCloud2_Ptr_t(boost::shared_ptr<void>& color_handler)
{
  return reinterpret_cast<boost::shared_ptr<PointCloudColorHandler<PCLPointCloud2>>&>(color_handler);
}

#endif
