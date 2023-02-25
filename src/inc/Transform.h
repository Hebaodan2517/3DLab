#pragma once

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>


class Transform
{
public:
	Transform();
	Transform(glm::vec3 pos,glm::vec3 rotation,glm::vec3 scale);


	void SetPosition(glm::vec3 pos);
	glm::vec3 GetPosition();
	void SetRotation(float yaw, float pitch, float roll);
	void GetPitchYaw(float& pitch,float& yaw);
	void SetScale(glm::vec3 scale);
	glm::vec3 GetScale();

	void Translate(glm::vec3 move, bool local = true);

	glm::mat4 GetMatrix();

protected:
	glm::mat4 m_transform;
};

