#version 330 core
out vec4 FragColor;

in vec3 textureDir;
uniform samplerCube cubeMap;

void main()
{
    vec3 color = texture(cubeMap,textureDir).rgb;
    color = pow(color, vec3(1.0/2.2)); 
    FragColor = vec4(color,1);
}