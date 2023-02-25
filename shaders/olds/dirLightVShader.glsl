#version 330 core

layout (location = 0) in vec3 inPos;
layout (location = 1) in vec3 inNormal;
layout (location = 2) in vec2 inTexCoord;


struct Transform
{
    mat4 model;
    mat3 normal;
};
uniform mat4 lightMat;
uniform Transform transform;

void main()
{
    gl_Position = lightMat*transform.model*vec4(inPos,1);
}
