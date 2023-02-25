#version 330 core

out float shadow;

in vec2 texCoord;
uniform sampler2D gPosition;

#define MAX_LEVEL       5
uniform int totalLevel;
uniform mat4 lightView[MAX_LEVEL];

uniform float levelDepth[MAX_LEVEL];
uniform sampler2D cascadeDepth[MAX_LEVEL];

const float bias = 0.005;
void main()
{
    vec4 pos = texture(gPosition,texCoord);
    vec3 worldPos = pos.xyz;
    float depth = pos.w;
    int index = 0;
    for(index = 0;index<totalLevel;++index)
    {
        if(depth < levelDepth[index])
        break;
    }
    if(index < totalLevel && depth >0.1)
    { 
        pos = vec4(worldPos,1);
        pos = lightView[index]*pos;
        //pos /= pos.w;
        vec2 viewCoord = pos.xy;
        viewCoord = viewCoord*0.5+0.5;

        float lightDepth = texture(cascadeDepth[index],viewCoord).r;
        float viewDepth = pos.z*0.5+0.5;
        if(viewDepth < lightDepth+bias)
            shadow = 0;
        else
            shadow = 1;

        /*switch(index)
        {
            case 0:shadow = vec3(1,0,0);break;
            case 1:shadow = vec3(1,1,0);break;
            case 2:shadow = vec3(0,1,0);break;
            case 3:shadow = vec3(0,0,1);break;
            default:shadow = vec3(1,0,1);break;
        }*/
        
        //shadow = vec3(lightDepth-viewDepth);
    }else
        shadow = 0;

    
}