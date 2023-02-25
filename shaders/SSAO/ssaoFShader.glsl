#version 330 core


in vec2 texCoord;
out vec3 FragColor;

struct Camera
{
    vec3 position;
    mat4 view;
    mat4 projection;
};

uniform sampler2D texPosition;
uniform sampler2D texNormal;
uniform sampler2D texNoise;
uniform sampler1D texSSAOKernel;
uniform Camera camera;
const float radius = 1;

void main()
{
    int kernelCount = textureSize(texSSAOKernel,0);
    vec2 noiseScale = textureSize(texPosition, 0)/textureSize(texNoise, 0);
    vec3 pos = texture(texPosition,texCoord).xyz;
    vec3 normal = texture(texNormal,texCoord).xyz;
    vec3 noise = texture(texNoise,texCoord*noiseScale).xyz;

    vec3 tangent = normalize(noise-normal*dot(noise,normal));
    vec3 bitangent = cross(normal,tangent); 
    mat3 TBN = mat3(tangent,bitangent,normal);
    float occlusion = 0;

    float kernelStep = 1.0/kernelCount;
    if(dot(normal,normal) <= 0.1)
       FragColor = vec3(1);
    else
    {
        for(int i = 0;i<kernelCount;++i)
        {
            vec3 kernel = texture(texSSAOKernel,i*kernelStep).xyz;
            vec3 sample = TBN*kernel;
            sample = pos+sample*radius;
            vec4 samplePos = vec4(sample,1);
            
            samplePos = camera.view*samplePos;
            float sampleDepth = -samplePos.z;
            samplePos = camera.projection*samplePos;
            vec2 viewCoord = samplePos.xy/samplePos.w;
            viewCoord = viewCoord *0.5+0.5;
            float viewDepth = texture(texPosition,viewCoord).a;
            vec3 viewNorm = texture(texNormal,viewCoord).xyz;
            if(length(viewNorm) > 0.8)
            {
                float radiusCheck = smoothstep(0,1,radius/abs(sampleDepth-viewDepth));
                occlusion += ((viewDepth < sampleDepth+0.01)?1.0:0.0)*radiusCheck;
            }
        }
        occlusion = 1.0-occlusion/kernelCount;

        FragColor = vec3(pow(occlusion,2));
        
    }
    //FragColor = texture(texSSAOKernel,texCoord.x).xyz;
}
