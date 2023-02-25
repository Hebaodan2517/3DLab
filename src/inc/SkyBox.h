#pragma once

#include <glad/glad.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <vector>
#include <string>
#include "Object.h"


class SkyBox : public Object
{
	GLuint m_texture;
	GLuint m_VBO;
	GLuint m_VAO;
	static std::vector<float> ms_cubeVertices;
public:
	SkyBox();
	~SkyBox();

	void Render(Shader& shader);
};

