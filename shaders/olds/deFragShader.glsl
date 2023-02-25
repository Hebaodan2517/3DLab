#version 330 core

#define DIR_SHADOWMAP_LEVEL     4

struct DirectionalLight
{
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    vec3 direction;
    sampler2D shadowMap[DIR_SHADOWMAP_LEVEL];
    mat4 levelView[DIR_SHADOWMAP_LEVEL];
    float levelDepth[DIR_SHADOWMAP_LEVEL-1];
};
struct PointLight
{
    vec3 diffuse;
    vec3 specular;
    vec3 position;
    vec3 attenuation;
};

struct SpotLight
{
    vec3 diffuse;
    vec3 specular;
    vec3 attenuation;

    vec3 position;
    vec3 direction;
    float outerEdge;
    float innerEdge;
};


out vec4 FragColor;

in vec2 texCoord;
uniform sampler2D gPosition;
uniform sampler2D gNormal;
uniform sampler2D gAlbedo;

uniform PointLight pointLight;
uniform SpotLight spotLight;
uniform DirectionalLight dirLight;

float calcDirectionalShadow(float depthInCam,vec3 position)
{
    int index = 0;
    for(index = 0;index<DIR_SHADOWMAP_LEVEL-1;index++)
    {
        if(depthInCam < dirLight.levelDepth[index])
            break;
    }

    vec4 lightViewPos = dirLight.levelView[index]*vec4(position,1);
    float camDepth = lightViewPos.z;
    float shadowDepth = texture(dirLight[index],lightViewPos.xy).r;
    if(camDepth < shadowDepth+0.01)
        return 0;
    return 1;
}

vec3 calcDirectionalLight(DirectionalLight light,vec3 diffuseClr,float specularClr,float shadow)
{
    vec3 lightDir = -light.direction;
   
    vec3 viewDir = normalize(camPos-worldPos);
    vec3 halfDir = normalize(viewDir+lightDir);

    float diffuseVal = max(dot(lightDir,normal),0);
    float specularVal = pow(max(dot(normal,halfDir),0),32);

    vec3 ambient = light.ambient*diffuseClr;
    vec3 diffuse = light.diffuse*diffuseVal*diffuseClr;
    vec3 specular = light.specular*specularVal*specularClr;
    vec3 result = ambient+(1.0-shadow)*(diffuse+specular);
    return result;
}

vec3 calcSpotLight(SpotLight light,vec3 diffuseClr,float specularClr)
{
    float lightDis = distance(light.position,worldPos);
    vec3 lightDir = normalize(light.position-worldPos);
    float attenuation = 0;
    float theta = dot(-lightDir,normalize(light.direction));
    if(theta >= light.innerEdge)
        attenuation = 1;
    else if(theta < light.innerEdge && theta >= light.outerEdge)
        attenuation = (theta-light.outerEdge)/(light.innerEdge-light.outerEdge);
    else
        return vec3(0);
    //return vec3(theta,0,0);
    vec3 viewDir = normalize(camPos-worldPos);
    vec3 halfDir = normalize(lightDir+viewDir);


    float diffuseVal = max(dot(lightDir,normal),0);
    float specularVal = pow(max(dot(halfDir,normal),0),32);

    vec3 diffuse = light.diffuse*diffuseVal*diffuseClr;
    vec3 specular = light.specular*specularVal*specularClr;
    vec3 result = diffuse+specular;
    float disAtt = light.attenuation.x+light.attenuation.y*lightDis+light.attenuation.z*lightDis*lightDis;
    result = result/attenuation*disAtt;
    return result;
}


void main()
{
    vec4 position = texture(gPosition,texCoord);
    vec3 normal = texture(gNormal,texCoord).rgb;
    vec3 diffuseClr = texture(gAlbedo,texCoord).rgb;
    float specularClr = texture(gAlbedo,texCoord).a;

    float shadow = calcDirectionalShadow(position.w,position.xyz);

    vec3 color = calcDirectionalLight(dirLight,diffuseClr,specularClr,shadow);
    FragColor = vec4(color,1);
}