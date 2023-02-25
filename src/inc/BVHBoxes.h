#pragma once
#include "Object.h"
#include "BBox.h"
#include <list>
#include <vector>
class BVHBoxes :
    public Object
{
    struct Box
    {
        glm::vec3 max, min;
        unsigned int level;
    };
public:
    void StartConstruct();
    void AddBox(BBox box);
    void EndConstruct();

    void Clear();

    void SetSelectedLevel(int level);
protected:
    std::vector<BBox> m_boxes;

    int m_selectedLevel;
};

