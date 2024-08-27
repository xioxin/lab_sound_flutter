#version 460 core
#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

uniform vec2 iResolution;
uniform float iTime;
uniform sampler2D iChannel0;



void main() {
    vec2 fragCoord = FlutterFragCoord();
    mainImage(fragColor, vec2(fragCoord.x, iResolution.y - fragCoord.y));
}
