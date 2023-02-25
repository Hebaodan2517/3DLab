#version 330 core
uniform sampler2D texBloom;
uniform sampler2D texOrigin;

in vec2 texCoord;
out vec3 FragColor;

uniform float exposure = 1.0;
void main()
{
    vec3 hdrClr = texture(texOrigin,texCoord).rgb;
    vec3 bloom = texture(texBloom,texCoord).rgb;


    hdrClr += bloom;
    vec3 color = vec3(1.0) - exp(-hdrClr*exposure);
    color = pow(color,vec3(1/2.2));
    //color *= 1.5;
    FragColor = color;
}