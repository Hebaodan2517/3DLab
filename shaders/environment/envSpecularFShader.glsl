#version 330 core



const float PI = 3.141592653589;

float RadicalInverse_VDC(uint bits)
{
    bits = (bits << 16u) | (bits >> 16u);
    bits = ((bits & 0x55555555u) << 1u) | ((bits & 0xAAAAAAAAu) >> 1u);
    bits = ((bits & 0x33333333u) << 2u) | ((bits & 0xCCCCCCCCu) >> 2u);
    bits = ((bits & 0x0F0F0F0Fu) << 4u) | ((bits & 0xF0F0F0F0u) >> 4u);
    bits = ((bits & 0x00FF00FFu) << 8u) | ((bits & 0xFF00FF00u) >> 8u);
    return float(bits) * 2.3283064365386963e-10; // / 0x100000000
}

vec2 Hammersley(uint i,uint N)
{
    return vec2(float(i)/float(N),RadicalInverse_VDC(i));
}

vec3 ImportanceSamplingGGX(vec2 Xi,vec3 N,float roughness)
{
    float a = roughness*roughness;

    float theta = 2.0*PI*Xi.x;
    float cosPhi = sqrt((1.0-Xi.y)/(1.0+(a*a-1.0)*Xi.y));
    float sinPhi = sqrt(1.0-cosPhi*cosPhi);

    vec3 H = vec3(cos(theta)*sinPhi,sin(theta)*sinPhi,cosPhi);

    vec3 up = abs(N.z)<0.999?vec3(0,0,1):vec3(1,0,0);
    vec3 tangent = normalize(cross(up,N));
    vec3 bitangent = normalize(cross(N,tangent));

    vec3 sampleVec = tangent * H.x+bitangent*H.y+N*H.z;
    return normalize(sampleVec);

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

out vec3 FragColor;
in vec3 textureDir;
uniform samplerCube cubeMap;
uniform float roughness;
uniform float resolution;

void main()
{
    vec3 N = normalize(textureDir);
    vec3 R = N;
    vec3 V = R;

    const uint SAMPLE_COUNT = 4096u;
    float totalWeight = 0;
    vec3 filterColor = vec3(0);
    for(uint i = 0u;i<SAMPLE_COUNT;++i)
    {
        vec2 Xi = Hammersley(i,SAMPLE_COUNT);
        vec3 H = ImportanceSamplingGGX(Xi,N,roughness);
        vec3 L = normalize(2.0*dot(V,H)*H-V);

        float NdotL = max(dot(N,L),0);
        float NdotH = max(dot(N,H),0);
        float D = NormalDistribution_GGX_TR(N,H,roughness);
        float pdf = (D*NdotH/(4.0*NdotH))+0.0001;

        float saTexel = 4.0*PI/(6.0*resolution*resolution);
        float saSample = 1.0/(float(SAMPLE_COUNT)*pdf+0.0001);

        float mipLevel = roughness == 0.0?0.0:0.5*log2(saSample/saTexel);
        if(NdotL > 0)
        {
            filterColor += texture(cubeMap,L,mipLevel).rgb*NdotL;
            totalWeight += NdotL;
        }
    }
    filterColor = filterColor / totalWeight;
    //filterColor = texture(cubeMap,textureDir).rgb;
    FragColor = filterColor;
}
