#version 330 core

in vec3 worldPos;

uniform float far;
uniform vec3 lightPos;
uniform bool pointLight;

uniform int debug = 0;

float linearlize(float depth)
{
    if(!pointLight)return depth;
    depth = length(worldPos-lightPos);
    return depth/far;
}
void main()
{
    gl_FragDepth = linearlize(gl_FragCoord.z);
    //if(debug == 1)
     //   gl_FragDepth = 0;
    
}