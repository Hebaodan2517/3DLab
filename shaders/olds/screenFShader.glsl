#version 330 core
uniform sampler2D screenTex;

in vec2 texCoords;
out vec3 FragColor;

const float cx = 1.0/800.0;
const float cy = 1.0/600.0;

void main()
{

    vec3 color = texture(screenTex,texCoords).rgb;
    //color = vec3(1,0,0);
    color = pow(color,vec3(1/2.2));
    //color = vec3(1,1,1);
    FragColor = color;
}