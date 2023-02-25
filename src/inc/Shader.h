#pragma once
#include <string>
#include <fstream>
#include <sstream>
#include <iostream>

#include <glad/glad.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>




class Shader
{
private:
    GLuint m_programID;

    GLuint createShader(const char* path, GLenum shaderType);
public:
    Shader(const char* vertexPath, const char* fragmentPath);
    Shader(const char* vertexPath, const char* geometryPath, const char* fragmentPath);
    ~Shader();
    // 使用/激活程序
    void UseProgram();
    void NotUseProgram();
    GLint GetUniformLocation(const char* varName);
    GLuint GetProgram();

    void SetInt(const char* name, int value);
    void SetFloat(const char* name, float value);
    void SetFloat2(const char* name, glm::vec2& vecValue);
    void SetFloat2(const char* name, float val1, float val2);

    void SetFloat3(const char* name, glm::vec3& vecValue);
    void SetFloat3(const char* name, float val1, float val2, float val3);
    void SetMat3(const char* name, glm::mat3& value);
    void SetMat4(const char* name, glm::mat4& value);
};

