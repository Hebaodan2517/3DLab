#version 330 core

uniform vec3 lightColor;
out vec4 FragColor;

in vec2 texPos;

void main()
{
    FragColor = vec4(lightColor,1);
}