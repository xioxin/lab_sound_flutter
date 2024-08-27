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

void main() {
    vec2 fragCoord = FlutterFragCoord();
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

    fragColor = vec4(c,1);
}



//
//void main(){
//    vec2 fragCoord = FlutterFragCoord();
//    vec2 uv = fragCoord.xy/iResolution.xy;
//
//    // quantize coordinates
//    const float bands = 30.0;
//    const float segs = 40.0;
//    vec2 p;
//    p.x = floor(uv.x*bands)/bands;
//    p.y = floor(uv.y*segs)/segs;
//
//    // read frequency data from first row of texture
//    float fft  = texture( iChannel0, vec2(p.x,0.0) ).x;
//
//    // led color
//    vec3 color = mix(vec3(0.0, 2.0, 0.0), vec3(2.0, 0.0, 0.0), sqrt(uv.y));
//
//    // mask for bar graph
//    float mask = (p.y < fft) ? 1.0 : 0.1;
//
//    // led shape
//    vec2 d = fract((uv - p) *vec2(bands, segs)) - 0.5;
//    float led = smoothstep(0.5, 0.35, abs(d.x)) *
//    smoothstep(0.5, 0.35, abs(d.y));
//    vec3 ledColor = led*color*mask;
//
//    // output final color
//    fragColor = vec4(ledColor, 1.0);
//}




//void main(){
//    float strength = 0.25;
//    float t = iTime/8.0;
//    vec3 col = vec3(0);
//    vec2 pos = FlutterFragCoord().xy/resolution.xy;
//    pos = 4.0*(vec2(0.5) - pos);
//    for(float k = 1.0; k < 7.0; k+=1.0){
//        pos.x += strength * sin(2.0*t+k*1.5 * pos.y)+t*0.5;
//        pos.y += strength * cos(2.0*t+k*1.5 * pos.x);
//    }
//    col += 0.5 + 0.5*cos(iTime+pos.xyx+vec3(0,2,4));
//    col = pow(col, vec3(0.4545));
//    fragColor = vec4(col,1.0);
//}