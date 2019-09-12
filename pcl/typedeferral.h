#ifndef __TYPEDEFERRAL_CPP__
#define __TYPEDEFERRAL_CPP__

/*
 * Defer type resolution of routines for fused types until the C++ takes a look at it.  This is a
 * workaround for poor type inference where we have something that looks like:
 *     ret function[PointT](PointCloud<PointT>& var)
 */

using namespace pcl::visualization;

template <typename PointCloudPtrT>
inline bool
pcl_visualization_PCLVisualizer_addPointCloud(PCLVisualizer& visual,
                                              const PointCloudPtrT &cloud,
                                              const std::string &id = "cloud", int viewport = 0)
{
  return visual.addPointCloud<typename PointCloudPtrT::element_type::value_type> (cloud, id, viewport);
}

#endif
