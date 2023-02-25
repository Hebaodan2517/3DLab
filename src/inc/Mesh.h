#pragma once

#include "Object.h"
#include "glad/glad.h"
#include "BBox.h"
#include <vector>

class Mesh : public Object
{
	friend class MeshFactory;
protected:
	struct Triangle{unsigned int vind[3];};
	struct BVHNode
	{
		BBox box;
		int left, right;
		std::vector<int> triangles;
	};
protected:
	std::vector<glm::vec3> m_vertices;
	std::vector<glm::vec3> m_normals;
	std::vector<Triangle> m_triangles;

	std::vector<BVHNode> m_bvhNodes;
	int m_root;

	GLuint m_VBO;
	GLuint m_VAO;
	GLuint m_EBO;
protected:

	void buildBVH(int maxLeaf);
	void loadBufferData();
	bool triangleHitTest(int index,glm::vec3 rayPos, glm::vec3 rayDir);
public:
	Mesh();

	glm::vec3 HitTest(glm::vec3 rayPos,glm::vec3 rayDir);

	void Clear();
};

