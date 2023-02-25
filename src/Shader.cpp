#include "Shader.h"

GLuint Shader::createShader(const char* path, GLenum shaderType)
{
    std::string code;
    std::ifstream file;
    file.exceptions(std::ifstream::failbit | std::ifstream::badbit);
    try
    {
        file.open(path);
        std::stringstream codeStream;
        codeStream << file.rdbuf();
        file.close();
        

        code = codeStream.str();
    }
    catch (std::ifstream::failure e)
    {
        std::cout << path << std::endl;
        std::cout << "ERROR::SHADER::FILE_NOT_SUCCESFULLY_READ" << std::endl;
        return 0;
    }
    GLuint shaderID = glCreateShader(shaderType);
    const char* codePtr = code.c_str();
    glShaderSource(shaderID, 1, &codePtr, NULL);
    int success; char infoLog[1024];
    glCompileShader(shaderID);
    glGetShaderiv(shaderID, GL_COMPILE_STATUS, &success);
    if (!success)
    {
        glGetShaderInfoLog(shaderID, 1024, NULL, infoLog);
        std::cout << path << std::endl;
        std::cout << "ERROR::SHADER::COMPILATION_FAILED\n" << infoLog << std::endl;
        glDeleteShader(shaderID);
        return 0;
    }
    return shaderID;
}

Shader::Shader(const char* vertexPath, const char* fragmentPath)
{
    GLuint vShader = createShader(vertexPath, GL_VERTEX_SHADER);
    GLuint fShader = createShader(fragmentPath, GL_FRAGMENT_SHADER);

    m_programID = glCreateProgram();
    glAttachShader(m_programID, vShader);
    glAttachShader(m_programID, fShader);
    glLinkProgram(m_programID);
    int success; char infoLog[1024];

    glGetProgramiv(m_programID, GL_LINK_STATUS, &success);
    if (!success) {
        glGetProgramInfoLog(m_programID, 1024, NULL, infoLog);
        std::cout << vertexPath << std::endl;
        std::cout << fragmentPath << std::endl;
        std::cout << "ERROR::PROGRAM::LINK_FAILED\n" << infoLog << std::endl;
    }

    glDeleteShader(vShader);
    glDeleteShader(fShader);
}

Shader::Shader(const char* vertexPath, const char* geometryPath, const char* fragmentPath)
{
    GLuint vShader = createShader(vertexPath, GL_VERTEX_SHADER);
    GLuint gShader = createShader(geometryPath, GL_GEOMETRY_SHADER);
    GLuint fShader = createShader(fragmentPath, GL_FRAGMENT_SHADER);

    m_programID = glCreateProgram();
    glAttachShader(m_programID, vShader);
    glAttachShader(m_programID, gShader);
    glAttachShader(m_programID, fShader);
    glLinkProgram(m_programID);
    int success; char infoLog[1024];

    glGetProgramiv(m_programID, GL_LINK_STATUS, &success);
    if (!success) {
        glGetProgramInfoLog(m_programID, 1024, NULL, infoLog);
        std::cout << vertexPath << std::endl;
        std::cout << geometryPath << std::endl;
        std::cout << fragmentPath << std::endl;
        std::cout << "ERROR::PROGRAM::LINK_FAILED\n" << infoLog << std::endl;
    }

    glDeleteShader(vShader);
    glDeleteShader(gShader);
    glDeleteShader(fShader);
}

Shader::~Shader()
{
    glDeleteProgram(m_programID);
}

void Shader::UseProgram()
{
    glUseProgram(m_programID);
}

void Shader::NotUseProgram()
{
    glUseProgram(0);
}

GLint Shader::GetUniformLocation(const char* varName)
{
    return glGetUniformLocation(m_programID, varName);
}

GLuint Shader::GetProgram()
{
    return m_programID;
}

void Shader::SetInt(const char* name, int value)
{
    auto i = glGetUniformLocation(m_programID, name);
    glUniform1i(glGetUniformLocation(m_programID, name), value);
}

void Shader::SetFloat(const char* name, float value)
{
    glUniform1f(glGetUniformLocation(m_programID, name), value);
}

void Shader::SetFloat2(const char* name, glm::vec2& vecValue)
{
    glUniform2f(glGetUniformLocation(m_programID, name), vecValue.x, vecValue.y);

}

void Shader::SetFloat2(const char* name, float val1, float val2)
{
    glUniform2f(glGetUniformLocation(m_programID, name), val1, val2);

}

void Shader::SetFloat3(const char* name, glm::vec3& vecValue)
{
    glUniform3f(glGetUniformLocation(m_programID, name), vecValue.x, vecValue.y, vecValue.z);
}

void Shader::SetFloat3(const char* name, float val1, float val2, float val3)
{
    glUniform3f(glGetUniformLocation(m_programID, name), val1, val2, val3);
}

void Shader::SetMat3(const char* name, glm::mat3& value)
{
    glUniformMatrix3fv(glGetUniformLocation(m_programID, name), 1, GL_FALSE, glm::value_ptr(value));
}

void Shader::SetMat4(const char* name, glm::mat4& value)
{
    glUniformMatrix4fv(glGetUniformLocation(m_programID, name), 1, GL_FALSE, glm::value_ptr(value));
}

