#version 330 core

layout (location = 0) in vec3 inPos;


struct Transform
{
    mat4 model;
    mat3 normal;
};

uniform Transform transform;
uniform mat4 lightView;
out vec3 worldPos;
void main()
{
    vec4 position = transform.model*vec4(inPos,1);
    gl_Position = lightView*position;
    worldPos = position.xyz;
}