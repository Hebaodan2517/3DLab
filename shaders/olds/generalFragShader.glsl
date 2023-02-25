#version 330 core


out vec4 FragColor;

#define TEXTURE_DIFFUSE_COUNT   2
#define TEXTURE_SPECULAR_COUNT  3


struct Material
{
    float shininess;
    int defaultDiffuse;
    int defaultSpecular;
    sampler2D texture_diffuse[TEXTURE_DIFFUSE_COUNT];
    sampler2D texture_specular[TEXTURE_SPECULAR_COUNT];
};

struct DirectionalLight
{
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    vec3 direction;
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

uniform Material material;
uniform PointLight pointLight;
uniform SpotLight spotLight;
uniform DirectionalLight dirLight;

uniform sampler2D shadowTex;
//uniform int usingDirLight;
//uniform int usingSpotLight;
//uniform int usingPtLight;

in vec3 camPos;
in vec3 worldPos;
in vec3 normal;
in vec2 texCoord;
in vec4 lightViewPos;

vec3 calcDirectionalLight(DirectionalLight light,vec3 diffuseClr,vec3 specularClr,float shadow)
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

vec3 calcSpotLight(SpotLight light,vec3 diffuseClr,vec3 specularClr)
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

vec3 calcPointLight(PointLight light,vec3 diffuseClr,vec3 specularClr)
{
    float lightDis = distance(light.position,worldPos);
    vec3 lightDir = normalize(light.position-worldPos);
    vec3 viewDir = normalize(camPos-worldPos);
    vec3 halfDir = normalize(viewDir+lightDir);

    float diffuseVal = max(dot(lightDir,normal),0);
    float specularVal = pow(max(dot(halfDir,normal),0),32);

    vec3 diffuse = light.diffuse*diffuseVal*diffuseClr;
    vec3 specular = light.specular*specularVal*specularClr;
    float attenuation = light.attenuation.x+light.attenuation.y*lightDis+light.attenuation.z*lightDis*lightDis;
    vec3 result = diffuse+specular;
    result = result/attenuation;
    return result;
}


vec3 calcEnvironment(vec3 diffuseClr,vec3 specularClr)
{
    return vec3(0);
}

float calcShadow(DirectionalLight light)
{
    vec3 pos = lightViewPos.xyz/lightViewPos.w;
    vec3 lightDir = -normalize(light.direction);
    pos = pos*0.5+0.5;
    float shadowDepth = texture(shadowTex,pos.xy).r;

    shadowDepth = shadowDepth+max(0.05*dot(lightDir,normal),0.005);

    float depth = pos.z;
    if(depth > 1)depth = 0;
    //return shadowDepth;
    if(depth > shadowDepth)
        return 1;
    return 0;
}

void main()
{

    vec3 diffuseClr = vec3(0);
    vec3 specularClr = vec3(0);
    for(int i = 0;i<TEXTURE_DIFFUSE_COUNT;i++)
        diffuseClr += texture(material.texture_diffuse[i],texCoord).xyz;
    for(int i = 0;i<TEXTURE_SPECULAR_COUNT;i++)
        specularClr += texture(material.texture_specular[i],texCoord).xyz;
    if(material.defaultDiffuse == 1)
        diffuseClr = vec3(0.5,0.5,0.5);
    if(material.defaultSpecular == 1)
        specularClr = vec3(1,1,1);
    float shadow = 0;//calcShadow(dirLight);
    vec3 color = calcDirectionalLight(dirLight,diffuseClr,specularClr,shadow);
    //color += calcPointLight(pointLight,diffuseClr,specularClr);
    //color += calcSpotLight(spotLight,diffuseClr,specularClr);
    FragColor = vec4(color,1);
}