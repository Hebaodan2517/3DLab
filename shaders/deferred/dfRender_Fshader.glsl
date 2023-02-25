#version 330 core

out vec3 FragColor;



in vec2 texCoord;
in vec3 camPos;

struct Environment
{
    sampler2D texSSAO;
    samplerCube irradianceMap;
    samplerCube specularMap;
    sampler2D brdfMap;
};

#define LIGHT_TYPE_DIRECTION    0
#define LIGHT_TYPE_POINT        1
#define LIGHT_TYPE_SPOT         2
struct Light
{
    int type;
    vec3 color;
    vec3 direction;
    vec3 position;
    vec2 edge;
    vec3 attenuation;
    bool usingShadow;
    sampler2D shadowMap;

};


uniform sampler2D texCanvas;
uniform sampler2D texPosition;
uniform sampler2D texNormal;
uniform sampler2D texAlbedo;
uniform sampler2D texPbr;



uniform Light light;
uniform Environment environment;

#define RENDER_STEP_ENV         0
#define RENDER_LIGHTS           1

uniform int renderStep;


const float PI = 3.141592653589;
float NormalDistribution_GGX_TR(vec3 N,vec3 H,float roughness);
float Geometry_GGX_Schlick(float NdotV,float roughness);
float Geometry_Smith(vec3 N,vec3 V,vec3 L,float roughness);
vec3 Frehsnel_Schlick(float HdotV,vec3 F0,float roughness);



vec3 renderLight(vec3 P,vec3 N,vec3 V,vec3 F0,vec3 albedo,float metallic,float roughness)
{
    float shadow = 0;
    if(light.usingShadow)
        shadow = texture(light.shadowMap,texCoord).r;
    
    vec3 L = vec3(0);
    float attenuation = 0;
    switch(light.type)
    {
        case LIGHT_TYPE_DIRECTION:
        {
            L = normalize(-light.direction);
            attenuation = 1;
        }break;
        case LIGHT_TYPE_POINT:
        {
            L = normalize(light.position-P);
            float dist = length(light.position-P);
            attenuation = 1.0/(light.attenuation.x+light.attenuation.y*dist+light.attenuation.z*dist*dist+0.0001);
        }break;
        case LIGHT_TYPE_SPOT:
        {
            L = normalize(light.position-P);
            float dist = length(light.position-P);
            attenuation = 1.0/(light.attenuation.x+light.attenuation.y*dist+light.attenuation.z*dist*dist+0.0001);
            //more to calc
        }break;
    }

    vec3 H = normalize(L+V);

    vec3 radiance = light.color*attenuation*(1.0-shadow);

    float NDF = NormalDistribution_GGX_TR(N,H,roughness);
    float G = Geometry_Smith(N,V,L,roughness);
    vec3 F = Frehsnel_Schlick(clamp(dot(H,V),0,1),F0,roughness);
    vec3 nom = NDF*G*F;
    float denom = 4.0*max(dot(N,V),0.0)*max(dot(N,L),0)+0.001;

    vec3 specular = nom/denom;

    vec3 kD = vec3(1)-F;
    kD *= 1.0-metallic;
    float NdotL = max(dot(N,L),0.0);
    vec3 Lo = (kD*albedo/PI+specular)*radiance*NdotL;
    return Lo;
}

vec3 renderEnvironemnt(vec3 N,vec3 V,vec3 F0,vec3 albedo,float metallic,float roughness,float ao)
{
    vec3 R = reflect(-V,N);

    const float MAX_REFELCTION_LOD  = 4.0;
    vec3 envSpecularClr = textureLod(environment.specularMap,R,roughness*MAX_REFELCTION_LOD).rgb;

    vec3 F = Frehsnel_Schlick(clamp(dot(N,V),0,1),F0,roughness);
    vec2 envBRDF = texture(environment.brdfMap,vec2(max(dot(N,V),0),roughness)).rg;
    vec3 specular = envSpecularClr*(F*envBRDF.x+envBRDF.y);

    vec3 kD = 1-F;
    vec3 irradiance = texture(environment.irradianceMap,N).rgb;
    vec3 diffuse = irradiance*albedo;
    vec3 ambient = (kD*diffuse+specular)*ao;

    return ambient;
}
void main()
{
    vec3 worldPos = texture(texPosition,texCoord).xyz;
    vec3 normal = texture(texNormal,texCoord).xyz;
    vec3 albedo = texture(texAlbedo,texCoord).rgb;
    vec3 pbr = texture(texPbr,texCoord).rgb;
    float metallic = pbr.x;
    float roughness = pbr.y;
    float ao = pbr.z*texture(environment.texSSAO,texCoord).r;



    vec3 N = normal;
    vec3 V = normalize(camPos-worldPos);

    vec3 F0 = mix(vec3(0.04),albedo,metallic);
    vec3 Lo = texture(texCanvas,texCoord).rgb;
    if(length(N)>0.5)
    {
        switch(renderStep)
        {
            case RENDER_STEP_ENV:Lo+=renderEnvironemnt(N,V,F0,albedo,metallic,roughness,ao);break;
            case RENDER_LIGHTS:Lo+=renderLight(worldPos,N,V,F0,albedo,metallic,roughness);break;
        }
    }
    FragColor = Lo;    
    
}



float NormalDistribution_GGX_TR(vec3 N,vec3 H,float roughness)
{
    float a = roughness*roughness;
    float a2 = a*a;
    float ndh = max(dot(N,H),0);
    float ndh2 = ndh*ndh;

    float nom = a2;
    float denom = (ndh2*(a2-1.0)+1.0);
    denom = PI*denom*denom;
    return nom/denom;
}

float Geometry_GGX_Schlick(float NdotV,float roughness)
{
    float a = roughness+1.0;
    float k = (a*a)/8.0;

    float denom = NdotV*(1.0-k)+k;
    return NdotV/denom;
}

float Geometry_Smith(vec3 N,vec3 V,vec3 L,float roughness)
{
    float NdotV = max(dot(N,V),0.0);
    float NdotL = max(dot(N,L),0.0);
    float ggx1 = Geometry_GGX_Schlick(NdotV,roughness);
    float ggx2 = Geometry_GGX_Schlick(NdotL,roughness);
    return ggx1*ggx2;
}

vec3 Frehsnel_Schlick(float HdotV,vec3 F0,float roughness)
{
    return F0+(max(vec3(1.0-roughness),F0)-F0)*pow(1.0-HdotV,5.0);
}