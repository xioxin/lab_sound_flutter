#version 460 core
#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

uniform vec2 iResolution;
uniform float iTime;
uniform sampler2D iChannel0;

// https://www.shadertoy.com/view/Dts3DN
const float tau = 2. * acos(-1.);

const vec3 forward = vec3(0., 0., 1.);
const vec3 up = vec3(0., 1., 0.);
const vec3 right = vec3(-1., 0., 0.);
const vec3 cam = vec3(0., 0., -2.0);

const float ptCt = 100.;
const float speed = 0.75;
const float sampCt = 20.;

float auAvg() {
    float sum = 0.;
    for (float i = 0.; i < sampCt; i+= 1.) {
        sum+= texture(iChannel0, vec2(i/sampCt, 1.)).x;
    }
    return sum/sampCt;
}

float spow(float x, float power) {
    return pow(abs(x), power) * sign(x);
}

float t;

float dist(vec3 rayDir) {
    float minDist = 99999.;
    float sphHeight = sin(spow(2. * (auAvg() - 0.5), 3.) * tau * 2. + t)*0.2;
    vec3 sph = vec3(0., sphHeight, 0.);

    for (float i = 0.; i < ptCt; i++) {
        float iNorm = i / ptCt;

        vec4 denoms = vec4(0.243453, 0.4234345, 0.2357797, 0.165777341);
        vec2 rand = mod(iNorm * vec2(1.3236574234, 0.934556756345), denoms.xy) / denoms.xy;
        rand = mod(rand.yx, denoms.zw)/denoms.zw;
        rand = mod(rand, denoms.xz)/denoms.xz;
        rand = mod(rand.yx, denoms.yw)/denoms.yw;

        float phi = acos(1. - fract(rand.x + t) * 2.);
        float theta = rand.y * tau + t * (rand.x + iNorm + 2.);

        float horz = sin(phi);
        vec3 sph2i = vec3(horz * cos(theta), cos(phi), horz * sin(theta));
        vec3 iPos = sph2i + sph;
        vec3 sph2cam = cam - sph;

        float segFrac =
        (dot(sph2cam, sph2i) - dot(sph2i, rayDir) * dot(sph2cam, rayDir))
        / (1. - dot(sph2i, rayDir) * dot(sph2i, rayDir));
        float bounce = abs(texture(iChannel0, vec2(iNorm, 1.)).x - 0.3)/1.5;
        segFrac = clamp(segFrac, bounce * 0.75 + 0.5, bounce + 0.75);


        float rayDist = dot(sph2i, rayDir) * segFrac - dot(sph2cam, rayDir);
        vec3 rayPos = cam + rayDir * rayDist;

        float iDist = length(rayPos - mix(sph, iPos, segFrac));
        minDist = min(iDist, minDist);
    }

    return minDist;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    t = iTime * speed;
    vec2 uv = (fragCoord/iResolution.xy * 2. - 1.);
    uv.x*= iResolution.x / iResolution.y;
    vec3 rayDir = normalize(uv.x * right + uv.y * up + forward);


    float d = dist(rayDir);
    if (d < 0.09 && d > 0.07) {
        fragColor = vec4(1., 1., 1., 1.);
    } else if (d > 0.2) {
        float bar = mod((t + uv.y + uv.x/4.) * 4., 1.0) < 0.1 ? 0.37 : 0.;

        fragColor = vec4(vec3(bar), 1.);
    } else {
        fragColor = vec4(0., 0., 0., 1.);
    }
}

void main() {
vec2 fragCoord = FlutterFragCoord();
mainImage(fragColor, vec2(fragCoord.x, iResolution.y - fragCoord.y));
}
