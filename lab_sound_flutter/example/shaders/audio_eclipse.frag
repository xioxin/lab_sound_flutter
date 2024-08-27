// https://www.shadertoy.com/view/MdsXWM

#version 460 core
#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

uniform vec2 iResolution;
uniform float iTime;
uniform sampler2D iChannel0;


const float dots = 40.; //number of lights
const float radius = .25; //radius of light ring
const float brightness = 0.02;

//convert HSV to RGB
vec3 hsv2rgb(vec3 c){
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
void mainImage( out vec4 fragColor, in vec2 fragCoord ) {

    vec2 p=(fragCoord.xy-.5*iResolution.xy)/min(iResolution.x,iResolution.y);
    vec3 c=vec3(0,0,0.1); //background color

    for(float i=0.;i<dots; i++){

        //read frequency for this dot from audio input channel
        //based on its index in the circle
        float vol =  texture(iChannel0, vec2(i/dots, 0.0)).x;
        float b = vol * brightness;

        //get location of dot
        float x = radius*cos(2.*3.14*float(i)/dots);
        float y = radius*sin(2.*3.14*float(i)/dots);
        vec2 o = vec2(x,y);

        //get color of dot based on its index in the
        //circle + time to rotate colors
        vec3 dotCol = hsv2rgb(vec3((i + iTime*10.)/dots,1.,1.0));

        //get brightness of this pixel based on distance to dot
        c += b/(length(p-o))*dotCol;
    }

    //black circle overlay
    float dist = distance(p , vec2(0));
    c = c * smoothstep(0.26, 0.28, dist);

//    fragColor = vec4(c,1);

//    // 背景色
//    vec4 bg = vec4(0.5, 0.2, 0.1, 1.0);
//    // 前景
//    vec4 fg = vec4(c, 1.0);
    float a = max(max(c.r, c.g), c.b);
    fragColor = vec4(c, a);
}

void main() {
    vec2 fragCoord = FlutterFragCoord();
    mainImage(fragColor, vec2(fragCoord.x, iResolution.y - fragCoord.y));
}
