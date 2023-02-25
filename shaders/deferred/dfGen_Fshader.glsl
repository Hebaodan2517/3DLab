#version 330 core

layout (location = 0) out vec4 gPosition;
layout (location = 1) out vec3 gNormal;
layout (location = 2) out vec3 gAlbedo;
layout (location = 3) out vec3 gPbr;

#define TEXTURE_GROUP_COUNT   2


struct Material
{
    bool defaultAlbedo;
    bool defaultMetallic;
    bool defaultRough;
    bool defaultAO;
    vec3 solidAlbedo;
    float solidMetallic;
    float solidRough;
    float solidAO;

    sampler2D texAlbedo[TEXTURE_GROUP_COUNT];
    sampler2D texMetallic[TEXTURE_GROUP_COUNT];
    sampler2D texRoughness[TEXTURE_GROUP_COUNT];
    sampler2D texAO[TEXTURE_GROUP_COUNT];
};

uniform Material material;

in vec2 texCoord;
in vec3 worldPos;
in vec3 normal;
in mat4 camView;


void main()
{
    float depth = -(camView*vec4(worldPos,1)).z;
    gPosition = vec4(worldPos,depth);
    gNormal = normal;

    vec3 albedo = vec3(0);
    if(material.defaultAlbedo)
        albedo = material.solidAlbedo;
    else
    {
        for(int i = 0;i<TEXTURE_GROUP_COUNT;++i)
            albedo += texture(material.texAlbedo[i],texCoord).r;
    }
    gAlbedo = albedo;

    float metallic = 0;
    if(material.defaultMetallic)
        metallic = material.solidMetallic;
    else
    {
        for(int i = 0;i<TEXTURE_GROUP_COUNT;++i)
            metallic += texture(material.texMetallic[i],texCoord).r;
    }

    float roughness = 0;
    if(material.defaultRough)
        roughness = material.solidRough;
    else
    {
        for(int i = 0;i<TEXTURE_GROUP_COUNT;++i)
            roughness += texture(material.texRoughness[i],texCoord).r;
    }  
    float AO = 0;
    if(material.defaultAO)
        AO = material.solidAO;
    else
    {
        for(int i = 0;i<TEXTURE_GROUP_COUNT;++i)
            AO += texture(material.texAO[i],texCoord).r;
    }  

    gPbr = vec3(metallic,roughness,AO);
}