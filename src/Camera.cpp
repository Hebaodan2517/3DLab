#include "Camera.h"
#include <math.h>

glm::mat4 Camera::GetProjectionMat(bool bPerspective)
{
    if (bPerspective)
    {
        float farHeight = tan(m_fov / 2) * m_far;
        m_height = tan(m_fov / 2) * m_near;


        glm::mat4 proj(0.0f);
        proj[0][0] = 2.0f * m_near / m_height / m_aspect;
        proj[1][1] = 2.0f * m_near / m_height;
        proj[2][2] = -(m_far + m_near) / (m_far - m_near);
        proj[2][3] = -2.0f * m_far * m_near / (m_far - m_near);
        proj[3][2] = -1;
        proj = glm::transpose(proj);
        return proj;

    }
    else
    {
        m_height = tan(m_fov / 2) * 10;

        glm::mat4 ortho(0);
        ortho[0][0] = 2.0 / m_height / m_aspect;
        ortho[1][1] = 2.0 / m_height;
        ortho[2][2] = -2.0 / (m_far - m_near);
        ortho[3][3] = 1;
        ortho[3][2] = -(m_far + m_near) / (m_far - m_near);
        return ortho;
    }
    return glm::mat4();
}


glm::mat4 Camera::GetViewMat()
{
    return glm::inverse(m_transform.GetMatrix());
}

void Camera::LookAt(glm::vec3 position)
{
}

void Camera::Translate(glm::vec3 movement)
{
    m_transform.Translate(movement);
}


void Camera::LookRotate(glm::vec2 rotate)
{
    float yaw, pitch;
    m_transform.GetPitchYaw(pitch, yaw);
    m_transform.SetRotation(yaw + rotate.y, pitch + rotate.x, 0);
}

void Camera::ApplyProjection(Shader& shader)
{
    glm::mat4 proj = GetProjectionMat(true);
    shader.UseProgram();
    shader.SetMat4("camera.projection", proj);
}

void Camera::ApplyView(Shader& shader, bool translate)
{
    glm::mat4 view = GetViewMat();
    if (!translate)
    {
        view = glm::mat4(glm::mat3(view));
    }
    shader.UseProgram();
    shader.SetMat4("camera.view", view);
}

void Camera::ApplyPosition(Shader& shader)
{
    shader.UseProgram();
    shader.SetFloat3("camera.position", m_transform.GetPosition());
}

void Camera::ApplyCameraPlate(Shader& shader)
{
    shader.UseProgram();
    shader.SetFloat2("camera.plate", glm::vec2(m_near, m_far));
}
