#version 330 core

layout (location = 0) in vec2 screenPos;
layout (location = 1) in vec2 scnCoord;

out vec2 texCoord;

void main()
{
    gl_Position = vec4(screenPos.x,screenPos.y,0,1);
    texCoord = scnCoord;
}