#version 330 core
out vec3 backColor;

in vec3 textureDir;
uniform samplerCube cubeMap;

void main()
{
    backColor = texture(cubeMap,textureDir).rgb;
}