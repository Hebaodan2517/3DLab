#pragma once

#include "Transform.h"
#include "Shader.h"

class Camera
{
protected:
	Transform m_transform;
	float m_fov;
	float m_aspect;
	float m_near;
	float m_far;
	float m_height;

public:
	Camera(float FOV, float aspect, float far, float near)
		:m_transform()
	{
		m_fov = FOV;
		m_aspect = aspect;
		m_far = far;
		m_near = near;
		m_height = 0;
	}

	glm::mat4 GetProjectionMat(bool bPerspective = true);
	glm::mat4 GetViewMat();


	glm::vec3 GetPosition() { return m_transform.GetPosition(); }
	void SetPosition(glm::vec3 position) { m_transform.SetPosition(position); }
	void LookAt(glm::vec3 position);


	float GetFOV() { return m_fov; }
	void SetFOV(float FOV) { m_fov = FOV; }
	float GetAspect() { return m_aspect; }
	void SetAspect(float aspect) { m_aspect = aspect; }

	float GetFarClipDistance() { return m_far; }
	float GetNearClipDistance() { return m_near; }
	void SetClipDistance(float near, float far) { m_far = far, m_near = near; }


	void Translate(glm::vec3 movement);
	void LookRotate(glm::vec2 rotate);

	void ApplyProjection(Shader& shader);
	void ApplyView(Shader& shader, bool translate = true);
	void ApplyPosition(Shader& shader);
	void ApplyCameraPlate(Shader& shader);

};

