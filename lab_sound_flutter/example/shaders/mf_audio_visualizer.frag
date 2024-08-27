#version 460 core
#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

uniform vec2 iResolution;
uniform float iTime;
uniform sampler2D iChannel0;

// https://www.shadertoy.com/view/fl2XD3
// Reuse some code to calculate ray direction from shader created by inigo quilez - iq/2019
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

const float PI = 3.14159265;

const vec3 lightDir = vec3(-0.577, 0.577, 0.577);
float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
                 43758.5453123);
}

float smoothMin(float d1, float d2, float k){
    float h = exp(-k * d1) + exp(-k * d2);
    return -log(h) / k;
}

float sdSphere( in vec3 p, in float r )
{
    return length(p)-r;
}

float dFn(vec3 p){
    const float div = 7.;
    const float an = 2.*PI/div;
    float index = round(atan(p.y,p.x)/an);
    float pick = (index+1.)/div;
    vec4 spect = texture(iChannel0, vec2(pick,0.));
    float angrot = index*an;
    vec3 q = p;
    q.xy = mat2(cos(angrot),-sin(angrot),
                sin(angrot), cos(angrot))*q.xy;

    float r = 1.5;
    float lenxy = r*spect.x ;
    float d = sdSphere( abs(q) - vec3(lenxy, 0, .5*sqrt(pow(r,2.) - lenxy)), .2*lenxy );
    float d2 = sdSphere( p , 1. );
    return smoothMin(d, d2, 20.0);
}

vec3 norm(vec3 p){
    float d = 0.001;
    return normalize(vec3(
                         dFn(p + vec3(  d, 0.0, 0.0)) - dFn(p + vec3( -d, 0.0, 0.0)),
                         dFn(p + vec3(0.0,   d, 0.0)) - dFn(p + vec3(0.0,  -d, 0.0)),
                         dFn(p + vec3(0.0, 0.0,   d)) - dFn(p + vec3(0.0, 0.0,  -d))
                     ));
}

mat3 setCamera( in vec3 ro, in vec3 ta, float cr )
{
    vec3 cw = normalize(ta-ro);
    vec3 cp = vec3(sin(cr), cos(cr),0.0);
    vec3 cu = normalize( cross(cw,cp) );
    vec3 cv =          ( cross(cu,cw) );
    return mat3( cu, cv, cw );
}

vec4 march(vec2 p){

    vec4 spect = texture(iChannel0, vec2(0,0.));
    spect = spect-.5;

    float rotate = spect.x*.5*PI + 1.5*iTime;
    vec3 target = vec3( 0.0, 0.0, 0.0 );
    float r = 5.;
    vec3 cPos = target + vec3( r*cos(rotate), 1.5*cos(.3*rotate), r*sin(rotate) );
    mat3 direction = setCamera( cPos, target, 0. );
    float fl = 2.0;
    vec3 ray = direction * normalize( vec3(p,fl) );

    float distance = 0.0;
    float rLen = 0.0;
    vec3  rPos = cPos;
    for(int i = 0; i < 64; i++){
        distance = dFn(rPos);
        rLen += distance;
        rPos = cPos + ray * rLen*.5;
    }

    vec4 col = vec4(0);
    if(abs(distance) < 0.001){
        vec3 normal = norm(rPos);
        float diff = clamp(dot(lightDir, normal), 0., 1.0);
        col = vec4(vec3(1.007*normal), 1.0);
    }else{
        col += vec4(0.5 + 0.5*cos(iTime+p.xyx+vec3(0,2,4)), 0);
    }
    return col;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = (fragCoord.xy * 2.0 - iResolution.xy) / iResolution.y;
    fragColor = march(p);
}

void main() {
    vec2 fragCoord = FlutterFragCoord();
    mainImage(fragColor, vec2(fragCoord.x, iResolution.y - fragCoord.y));
}
