#version 460 core
#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

uniform vec2 iResolution;
uniform float iTime;
uniform sampler2D iChannel0;

float tf(float x) {
    return (pow(2., x + 1.));
}

float s(float x) {return x*x;}

float cubicInterp(float x, float y_m1, float y_0, float y_1, float y_2) {
    float a = 2.*y_1 + y_m1 - 0.5*(y_2 + 5. * y_0);
    float b = 0.5*(y_2 - 3.*y_1 + 3.*y_0 - y_m1);
    return y_0 + 0.5*(y_1 - y_m1) * x + a * x*x + b * x*x*x;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;

    float fracY = fract(8. * uv.y - .5);

    float xCoord = floor(tf(uv.x + floor(8. * uv.y - 1.5)));
    float prevRow =
    cubicInterp(
        fract(tf(uv.x + floor(8. * uv.y - 1.5))),
        texture(iChannel0, vec2((xCoord - 1.) / 512., 0.)).x,
        texture(iChannel0, vec2((xCoord - 0.) / 512., 0.)).x,
        texture(iChannel0, vec2((xCoord + 1.) / 512., 0.)).x,
        texture(iChannel0, vec2((xCoord + 2.) / 512., 0.)).x
    );

    xCoord = floor(tf(uv.x + floor(8. * uv.y - 0.5)));
    float currentRow = cubicInterp(
        fract(tf(uv.x + floor(8. * uv.y - 0.5))),
        texture(iChannel0, vec2((xCoord - 1.) / 512., 0.)).x,
        texture(iChannel0, vec2((xCoord - 0.) / 512., 0.)).x,
        texture(iChannel0, vec2((xCoord + 1.) / 512., 0.)).x,
        texture(iChannel0, vec2((xCoord + 2.) / 512., 0.)).x
    );

    xCoord = floor(tf(uv.x + floor(8. * uv.y + 0.5)));
    float nextRow = cubicInterp(
        fract(tf(uv.x + floor(8. * uv.y + 0.5))),
        texture(iChannel0, vec2((xCoord - 1.) / 512., 0.)).x,
        texture(iChannel0, vec2((xCoord - 0.) / 512., 0.)).x,
        texture(iChannel0, vec2((xCoord + 1.) / 512., 0.)).x,
        texture(iChannel0, vec2((xCoord + 2.) / 512., 0.)).x
    );

    xCoord = floor(tf(uv.x + floor(8. * uv.y + 1.5)));
    float nextStill = cubicInterp(
        fract(tf(uv.x + floor(8. * uv.y + 1.5))),
        texture(iChannel0, vec2((xCoord - 1.) / 512., 0.)).x,
        texture(iChannel0, vec2((xCoord - 0.) / 512., 0.)).x,
        texture(iChannel0, vec2((xCoord + 1.) / 512., 0.)).x,
        texture(iChannel0, vec2((xCoord + 2.) / 512., 0.)).x
    );

    //float prevRow = texture(iChannel0, vec2(tf(uv.x + floor(8. * uv.y - 1.5)) / 512., 0.)).x;
    //float currentRow = texture(iChannel0, vec2(tf(uv.x + floor(8. * uv.y - .5)) / 512., 0.)).x;
    //float nextRow = texture(iChannel0, vec2(tf(uv.x + floor(8. * uv.y + .5)) / 512., 0.)).x;
    //float nextStill = texture(iChannel0, vec2(tf(uv.x + floor(8. * uv.y + 1.5)) / 512., 0.)).x;

    float brightness = cubicInterp(
        fracY,
        prevRow,
        currentRow,
        nextRow,
        nextStill
    );

    fragColor = vec4(s(brightness));
    //fragColor = vec4(s(texelFetch(iChannel0, ivec2(tf(uv.x + floor(8. * uv.y)), 0), 0).x));

    //Uncomment the last line to remove smoothing.
}

void main() {
    vec2 fragCoord = FlutterFragCoord();
    mainImage(fragColor, vec2(fragCoord.x, iResolution.y - fragCoord.y));
}
