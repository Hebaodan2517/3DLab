#pragma once

#include "Transform.h"
#include "Shader.h"

class Object
{
public:
	virtual void Render(Shader& shader) = 0;

	Transform& GetTransform();
	const char* GetName();
	void SetName(const char* namePtr);
	void SetColor(glm::vec3 color);
	glm::vec3 GetColor();
protected:
	glm::vec3 m_color;
	std::string m_name;
	Transform m_transform;
};

