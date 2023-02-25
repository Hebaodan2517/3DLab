#version 330 core

layout (location = 0)out vec3 FragColor;
layout (location = 1)out vec3 BloomColor;


in vec2 texCoord;
in vec3 camPos;



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


uniform sampler2D texPosition;
uniform sampler2D texNormal;
uniform sampler2D texAlbedo;
uniform sampler2D texBackground;
uniform sampler2D texSSAO;

uniform DirectionalLight dirLight;


vec3 calcDirectionalLight(DirectionalLight light,float ssaoVal,vec3 diffuseClr,vec3 specularClr,vec3 worldPos,vec3 normal)
{
    vec3 lightDir = -light.direction;
   
    vec3 viewDir = normalize(camPos-worldPos);
    vec3 halfDir = normalize(viewDir+lightDir);

    float diffuseVal = max(dot(lightDir,normal),0);
    float specularVal = pow(max(dot(normal,halfDir),0),32);

    vec3 ambient = light.ambient*diffuseClr*ssaoVal;
    vec3 diffuse = light.diffuse*diffuseVal*diffuseClr;
    vec3 specular = light.specular*specularVal*specularClr;
    vec3 result = ambient+diffuse+specular;
    return result;
}

vec3 calcSpotLight(SpotLight light,vec3 diffuseClr,vec3 specularClr,vec3 worldPos,vec3 normal)
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

vec3 calcPointLight(PointLight light,vec3 diffuseClr,vec3 specularClr,vec3 worldPos,vec3 normal)
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

void main()
{
    vec3 diffuseClr = texture(texAlbedo,texCoord).rgb;
    vec3 specularClr = vec3(texture(texAlbedo,texCoord).a);
    vec3 worldPos = texture(texPosition,texCoord).xyz;
    vec3 normal = texture(texNormal,texCoord).xyz;
    float ssao = texture(texSSAO,texCoord).r;


    vec3 color = calcDirectionalLight(dirLight,ssao,diffuseClr,specularClr,worldPos,normal);
    //color += calcPointLight(pointLight,diffuseClr,specularClr);
    //color += calcSpotLight(spotLight,diffuseClr,specularClr);
    color += texture(texBackground,texCoord).rgb;
    //color += camPos;
    //color = vec3(texture(texSSAO,texCoord).rgb);

    FragColor = color;    
    float bright = dot(color,vec3(0.2126, 0.7152, 0.0722));
    if(bright >= 0.8)
        BloomColor = color;
    else
        BloomColor = vec3(0);
}