#version 330 core

in vec2 texPos;
out vec4 FragColor;
in vec3 camPos;
uniform samplerCube envTex;

in vec3 worldPos;
in vec3 normal;

vec3 calcEnvironment()
{
    vec3 lookDir = camPos-worldPos;
    vec3 envDir = reflect(-lookDir,normal);

    return texture(envTex,envDir).rgb;
}


void main()
{
    vec3 color = calcEnvironment();
    FragColor = vec4(color,1);
}