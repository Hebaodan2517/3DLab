#include "Object.h"

Transform& Object::GetTransform()
{
    return m_transform;
    // TODO: �ڴ˴����� return ���
}

const char* Object::GetName()
{
    return m_name.c_str();
}

void Object::SetName(const char* namePtr)
{
    m_name = namePtr;
}

void Object::SetColor(glm::vec3 color)
{
    m_color = color;
}

glm::vec3 Object::GetColor()
{
    return m_color;
}
