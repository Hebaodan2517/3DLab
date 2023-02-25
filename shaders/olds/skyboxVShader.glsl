#version 330 core

layout (location = 0) in vec3 position;

struct Camera
{
    vec3 position;
    mat4 view;
    mat4 projection;
};

uniform Camera camera;
out vec3 textureDir;

void main()
{
    textureDir = position;
    vec4 pos = camera.projection*camera.view*vec4(position,1.0);
    gl_Position = pos.xyww;
}