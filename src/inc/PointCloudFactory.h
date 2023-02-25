#pragma once

#include "PointCloud.h"
#include "Mesh.h"
#include "RayBunch.h"
class PointCloudFactory
{
public:
	void SetCameraProperty(Transform transoform, float fov, float aspect)
	{
		m_transform = transoform;
		m_fov = fov;
		m_aspect = aspect;
	}

	void RecordRays(bool enable) { m_recordRays = enable; }

	void SetSamplerProperty(int width,int height,int samplesPerUnit) 
	{ 
		m_width = width;
		m_height = height;
		m_samples = samplesPerUnit;
	}


	void CreatePointCloud(PointCloud& ptCloud,Mesh& mesh);

	void GetRayBunch(RayBunch& rbunch);

protected:
	void generateHitRay(glm::vec3& rayDir);

protected:
	std::vector<glm::vec3> m_rayDirs;
	bool m_recordRays;
	Transform m_transform;
	float m_fov;
	float m_aspect;
	int m_width;
	int m_height;
	int m_samples;


};

