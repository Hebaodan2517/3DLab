#pragma once

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <algorithm>


class BBox
{
public:
	glm::vec3 maxVec;
	glm::vec3 minVec;
public:

	BBox();
	BBox(glm::vec3 vertices[3]);
	BBox(glm::vec3 center, glm::vec3 radius);

	BBox Merge(BBox box1, BBox box2);

	bool HitTest(glm::vec3 rayPos,glm::vec3 rayDir);
};

