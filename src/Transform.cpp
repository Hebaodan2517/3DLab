#include "Transform.h"

Transform::Transform()
	:m_transform(1)
{
}

Transform::Transform(glm::vec3 pos, glm::vec3 rotation, glm::vec3 scale)
{
	glm::mat4 pitch = glm::rotate(glm::mat4(1), rotation.x, glm::vec3(1, 0, 0));
	glm::mat4 roll = glm::rotate(glm::mat4(1), rotation.y, glm::vec3(0, 1, 0));
	glm::mat4 yaw = glm::rotate(glm::mat4(1), rotation.z, glm::vec3(0, 0, 1));

	m_transform = glm::scale(glm::mat4(1),scale);
	m_transform = yaw*pitch*roll*m_transform;
	m_transform[3][0] = pos.x;
	m_transform[3][1] = pos.y;
	m_transform[3][2] = pos.z;
}

void Transform::SetPosition(glm::vec3 pos)
{
	m_transform[3][0] = pos[0];
	m_transform[3][1] = pos[1];
	m_transform[3][2] = pos[2];
}

glm::vec3 Transform::GetPosition()
{
	return glm::vec3(m_transform[3][0],
		m_transform[3][1], 
		m_transform[3][2]);
}

void Transform::SetRotation(float yaw, float pitch, float roll)
{
	//not neccesary
}

void Transform::GetPitchYaw(float& pitch, float& yaw)
{
	const float pi = 3.141592653589f;
	glm::vec3 forward = glm::vec3(-m_transform[3]);
	glm::vec3 up = glm::vec3(m_transform[1]);
	glm::normalize(forward);
	pitch = acosf(forward.z);
	if (up.z < 0)
		pitch += pi;
	yaw = atan2f(forward.x, forward.z) - pi;
}


void Transform::SetScale(glm::vec3 scale)
{
	glm::vec3 oldScale = GetScale();
	scale = oldScale / scale;
	m_transform = m_transform*glm::scale(glm::mat4(1), scale);
}

glm::vec3 Transform::GetScale()
{
	return glm::vec3(glm::length(m_transform[0]),
		glm::length(m_transform[1]),
		glm::length(m_transform[2]));
}

void Transform::Translate(glm::vec3 move, bool local)
{
	glm::vec4 x, y, z;
	if (local)
	{
		x = m_transform[0];
		y = m_transform[1];
		z = m_transform[2];
		glm::normalize(x);
		glm::normalize(y);
		glm::normalize(z);
	}
	else
	{
		x = glm::vec4(1, 0, 0, 0);
		y = glm::vec4(0, 1, 0, 0);
		z = glm::vec4(0, 0, 1, 0);
	}
	m_transform[0] += x * move[0];
	m_transform[1] += y * move[1];
	m_transform[2] += z * move[2];
}


glm::mat4 Transform::GetMatrix()
{
	return m_transform;
}
