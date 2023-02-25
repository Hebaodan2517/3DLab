#pragma once

#include "BBox.h"
#include "Object.h"
#include <vector>

class PointCloud : public Object
{
	friend class PointCloudFactory;
	struct BVHNode
	{
		BBox box;
		int left, right;
		std::vector<int> ptGroup;
	};

public:
	int HitTest(glm::vec3 rayPos, glm::vec3 rayDir);
	int GetPointCount();
	glm::vec3 GetPointAt(int index);

	void SetPointSize(float radius);
protected:
	void buildBVH(int maxLeaf);
	void loadBufferData();
protected:
	std::vector<glm::vec3> m_points;
	std::vector<BVHNode> m_bvhNodes;
	int m_root;

	float m_pointRadius;

	GLuint m_VBO;


};

