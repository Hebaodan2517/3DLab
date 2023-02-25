#version 330 core

const float PI = 3.141592653589;

struct Material
{
    vec3 albedo;
    float metallic;
    float roughness;
    float ao;
};

struct PointLight
{
    vec3 color;
    vec3 position;
    vec3 attenuation;
};

uniform Material material;
uniform PointLight ptLight[4];
uniform samplerCube irradianceMap;
uniform samplerCube envSpecularMap;
uniform sampler2D brdfMap;
out vec4 FragColor;

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

in vec2 texCoord;
in vec3 camPos;
in vec3 worldPos;
in vec3 normal;



void main()
{
    vec3 N = normalize(normal);
    vec3 V = normalize(camPos-worldPos);

    vec3 F0 = mix(vec3(0.04),material.albedo,material.metallic);
    vec3 Lo = vec3(0);
    for(int i = 0;i<4;++i)
    {
        vec3 L = normalize(ptLight[i].position-worldPos);
        vec3 H = normalize(L+V);

        float dist = length(ptLight[i].position-worldPos);
        float attenuation = ptLight[i].attenuation.x/(dist*dist);

        vec3 radiance = ptLight[i].color*attenuation;

        float NDF = NormalDistribution_GGX_TR(N,H,material.roughness);
        float G = Geometry_Smith(N,V,L,material.roughness);
        vec3 F = Frehsnel_Schlick(clamp(dot(H,V),0,1),F0,material.roughness);
        vec3 nom = NDF*G*F;
        float denom = 4.0*max(dot(N,V),0.0)*max(dot(N,L),0)+0.001;

        vec3 specular = nom/denom;

        vec3 kD = vec3(1)-F;
        kD *= 1.0-material.metallic;

        Lo += (kD*material.albedo/PI+specular)*radiance*max(dot(N,L),0.0);
    }

    vec3 R = reflect(-V,N);

    const float MAX_REFELCTION_LOD  = 4.0;
    vec3 envSpecularClr = textureLod(envSpecularMap,R,material.roughness*MAX_REFELCTION_LOD).rgb;

    vec3 F = Frehsnel_Schlick(clamp(dot(N,V),0,1),F0,material.roughness);
    vec2 envBRDF = texture(brdfMap,vec2(max(dot(N,V),0),material.roughness)).rg;
    vec3 specular = envSpecularClr*(F*envBRDF.x+envBRDF.y);

    vec3 kD = 1-F;
    vec3 irradiance = texture(irradianceMap,N).rgb;
    vec3 diffuse = irradiance*material.albedo;
    vec3 ambient = (kD*diffuse+specular)*material.ao;
    Lo += ambient;


    Lo = Lo / (Lo + vec3(1.0));
    Lo = pow(Lo, vec3(1.0/2.2)); 
    FragColor = vec4(Lo,1);
}