#version 330 core

out vec3 FragColor;
in vec3 textureDir;
uniform samplerCube cubeMap;

const float PI = 3.141592653589;
void main()
{
    vec3 irradiance = vec3(0);
    vec3 up = normalize(textureDir);
    vec3 back = vec3(0,1,0);
    vec3 right = normalize(cross(back,up));
    back = normalize(cross(right,up));
    float sampleDelta = 0.05f;
    float sampleCnt = 0;
    for(float phi = 0;phi<PI/2.0;phi += sampleDelta)
    {
        for(float theta = 0;theta < 2.0*PI;theta+=sampleDelta)
        {
            vec3 direction = cos(phi)*cos(theta)*back+cos(phi)*sin(theta)*right+sin(phi)*up;
            irradiance += texture(cubeMap,direction).rgb*cos(phi)*sin(phi);
            sampleCnt +=1;
        }
    }

    FragColor = irradiance/sampleCnt*PI;
    //FragColor = texture(cubeMap,up).rgb;

}