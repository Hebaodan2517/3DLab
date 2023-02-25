#include "BBox.h"

BBox::BBox()
    :maxVec(0),minVec(0)
{
}

BBox::BBox(glm::vec3 vertices[3])
{
	maxVec = glm::max(vertices[0], vertices[1]);
	maxVec = glm::max(maxVec, vertices[2]);

	minVec = glm::min(vertices[0], vertices[1]);
	minVec = glm::min(minVec, vertices[2]);
}

BBox::BBox(glm::vec3 center,glm::vec3 radius)
	:maxVec(center + glm::abs(radius)),
	minVec(center - glm::abs(radius))
{
}

BBox BBox::Merge(BBox box1, BBox box2)
{
    BBox box;
    box.maxVec = glm::max(box1.maxVec, box2.maxVec);
    box.minVec = glm::min(box1.minVec, box2.minVec);
	return box;
}

bool BBox::HitTest(glm::vec3 rayPos, glm::vec3 rayDir)
{
    float xmin, xmax, ymin, ymax, zmin, zmax;
    xmin = (minVec.x - rayPos.x) / rayDir.x;
    xmax = (maxVec.x - rayPos.x) / rayDir.x;
    if (xmin > xmax) std::swap(xmin, xmax);
    ymin = (minVec.y - rayPos.y) / rayDir.y;
    ymax = (maxVec.y - rayPos.y) / rayDir.y;
    if (ymin > ymax) std::swap(ymin, ymax);
    if (xmin > ymax || ymin > xmax) return false;

    if (ymin > xmin) xmin = ymin;
    if (ymax < xmax) xmax = ymax;


    zmin = (minVec.z - rayPos.z) / rayDir.z;
    zmax = (maxVec.z - rayPos.z) / rayDir.z;
    if (zmin > zmax) std::swap(zmin, zmax);
    if (xmin > zmax || zmin > xmax) return false;

    if (zmin > xmin) xmin = zmin;
    if (zmax < xmax) xmax = zmax;
    return true;
}
