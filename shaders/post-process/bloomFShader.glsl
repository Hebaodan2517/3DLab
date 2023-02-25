#version 330 core


in vec2 texCoord;
layout (location = 0) out vec3 originColor;
layout (location = 1) out vec3 bloomColor;

uniform sampler2D texCanvas;

void main()
{
    vec3 color = texture(texCanvas,texCoord).rgb;
    float bright = dot(color,vec3(0.2126, 0.7152, 0.0722));
    if(bright >= 0.15)
        bloomColor = color;
    else
        bloomColor = vec3(0);
    originColor = color;
}