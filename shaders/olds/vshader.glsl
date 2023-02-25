#version 330 core

layout (location = 0) in vec3 inPos;
layout (location = 1) in vec3 inNormal;
layout (location = 2) in vec2 inTexCoord;

struct Camera
{
    vec3 position;
    mat4 view;
    mat4 projection;
    
};
struct Transform
{
    mat4 model;
    mat3 normal;
};

uniform Camera camera;
uniform Transform transform;
uniform mat4 lightViewMat;

out vec4 lightViewPos;
out vec2 texCoord;
out vec3 camPos;
out vec3 worldPos;
out vec3 normal;

void main()
{
    vec4 position = transform.model*vec4(inPos,1);
    gl_Position = camera.projection*camera.view*position;

    worldPos = position.xyz;
    normal = transform.normal*inNormal;
    normal = normalize(normal);
    camPos = camera.position;
    texCoord = inTexCoord;
    lightViewPos = (lightViewMat*position);
}