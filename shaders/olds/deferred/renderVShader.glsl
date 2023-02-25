#version 330 core


layout (location = 0) in vec2 screenPos;
layout (location = 1) in vec2 scnCoord;

struct Camera
{
    vec3 position;
    mat4 view;
    mat4 projection;
};

uniform Camera camera;

out vec2 texCoord;
out vec3 camPos;



void main()
{
    gl_Position = vec4(screenPos.x,screenPos.y,0,1);
    texCoord = scnCoord;
    camPos = camera.position;
}