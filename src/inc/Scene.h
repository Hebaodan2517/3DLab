#pragma once

#include <vector>
#include "Object.h"
#include "Shader.h"
#include "Camera.h"
class Scene
{

	void Render();

	Camera& GetCamera() { return m_camera; };

protected:
	std::vector<Object> m_objects;
	Object* m_selectedObj;
	Camera m_camera;
};

