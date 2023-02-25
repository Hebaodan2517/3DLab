#version 330 core

in vec2 texCoord;
out vec3 FragColor;



//uniform vec2 textureSize;

const float weight[5] = float[] (0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);
uniform bool blurHorizontal;
uniform sampler2D texBlur;
uniform sampler1D texBlurKernel;

void main()
{             
    vec2 tex_offset = 1.0 / textureSize(texBlur, 0); // gets size of single texel
    int size = textureSize(texBlurKernel,0);
    float blur_offset = 1.0/size;
    vec3 result = texture(texBlur, texCoord).rgb * texture(texBlurKernel,0.0).r; // current fragment's contribution
    
    if(blurHorizontal)
    {
        for(int i = 1; i < size; ++i)
        {
            result += texture(texBlur, texCoord + vec2(tex_offset.x * i, 0.0)).rgb * texture(texBlurKernel,i*blur_offset).r;
            result += texture(texBlur, texCoord - vec2(tex_offset.x * i, 0.0)).rgb * texture(texBlurKernel,i*blur_offset).r;
        }
    }
    else
    {
        for(int i = 1; i < size; ++i)
        {
            result += texture(texBlur, texCoord + vec2(0.0, tex_offset.y * i)).rgb * texture(texBlurKernel,i*blur_offset).r;
            result += texture(texBlur, texCoord - vec2(0.0, tex_offset.y * i)).rgb * texture(texBlurKernel,i*blur_offset).r;
        }
    }
    FragColor = result;
}