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

float Geometry_GGX_Schlick(float NdotV,float roughness)
{
    float a = roughness;
    float k = (a*a)/2.0;

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

vec2 IntergrateBRDF(float NdotV,float roughness)
{
    vec3 V = vec3(sqrt(1.0-NdotV*NdotV),0,NdotV);

    float A = 0,B = 0;
    vec3 N = vec3(0,0,1);

    const uint SAMPLE_COUNT = 1024u;
    for(uint i = 0u;i<SAMPLE_COUNT;++i)
    {
        vec2 Xi = Hammersley(i,SAMPLE_COUNT);
        vec3 H = ImportanceSamplingGGX(Xi,N,roughness);
        vec3 L = normalize(2.0*dot(V,H)*H-V);

        float NdotL = max(L.z,0);
        float NdotH = max(H.z,0);
        float VdotH = max(dot(V,H),0);

        if(NdotL > 0.0)
        {
            float G = Geometry_Smith(N,V,L,roughness);
            float G_Vis = (G*VdotH)/(NdotH*NdotV);
            float Fc = pow(1-VdotH,5.0);

            A += (1.0-Fc)*G_Vis;
            B += Fc * G_Vis;
        }
    }
    A/=float(SAMPLE_COUNT);
    B/=float(SAMPLE_COUNT);
    return vec2(A,B);
}

in vec2 texCoord;
out vec2 FragColor;

void main()
{
    vec2 intergratedBRDF = IntergrateBRDF(texCoord.x,texCoord.y);
    FragColor = intergratedBRDF;
}