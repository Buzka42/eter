#version 460 core
// Eter · The Calorie Cloud — spec 04 §1 / 06.
// Uniform order matters for Dart setFloat indices:
// 0,1: uSize · 2: uTime · 3: uFill · 4: uPulse · 5: uNight · 6: uBurst

#include <flutter/runtime_effect.glsl>

precision highp float;

uniform vec2 uSize;
uniform float uTime;   // seconds
uniform float uFill;   // 0..1 daily progress
uniform float uPulse;  // 0..1 beat envelope
uniform float uNight;  // 0 day · 1 night sky
uniform float uBurst;  // 0..1 milestone burst envelope

out vec4 fragColor;

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float vnoise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), u.x),
             mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x),
             u.y);
}

// 3-octave fBM (spec 04)
float fbm(vec2 p) {
  float v = 0.0;
  float a = 0.5;
  for (int i = 0; i < 3; i++) {
    v += a * vnoise(p);
    p *= 2.02;
    a *= 0.5;
  }
  return v;
}

void main() {
  vec2 frag = FlutterFragCoord().xy;
  vec2 uv = (frag - 0.5 * uSize) / min(uSize.x, uSize.y);
  float t = uTime * 0.02; // slow morph, spec: noise scroll 0.02/s

  // Pulse: scale 1.00 -> 1.06 (spec 04 §1)
  float scale = 1.0 + 0.06 * uPulse;
  vec2 p = uv / scale;

  // Domain warp: p + 0.35 * fbm(p + t)
  vec2 warp = vec2(fbm(p * 3.0 + t), fbm(p * 3.0 - t + 5.2));
  float n = fbm(p * 3.5 + 0.35 * warp + vec2(t * 0.6, 0.0));

  // Elliptic radial falloff (clouds are wider than tall)
  float r = length(p * vec2(1.0, 1.55));
  float radius = mix(0.28, 0.46, clamp(uFill, 0.0, 1.0));
  float body = n + 0.25 - smoothstep(radius * 0.55, radius, r);

  // Feathered edge: smoothstep 0.42 -> 0.58 (spec)
  float alpha = smoothstep(0.42, 0.58, body);
  float density = mix(0.55, 0.95, clamp(uFill, 0.0, 1.0)); // spec 06
  alpha *= density;

  // Palette (day mist / night-sky tinted)
  vec3 base = mix(vec3(1.0, 1.0, 1.0), vec3(0.86, 0.90, 0.98), uNight);
  vec3 shade = mix(vec3(0.82, 0.90, 0.97), vec3(0.55, 0.62, 0.80), uNight);

  // Inner glow toward mist0, stronger while pulsing / bursting
  float glow = smoothstep(0.5, 0.0, r) * (0.6 + 0.4 * uPulse + 0.6 * uBurst);
  vec3 col = mix(shade, base, clamp(n + glow * 0.6, 0.0, 1.0));

  // Faint gold rim (aura300) at the top edge
  float rim = smoothstep(radius, radius * 0.8, r) * smoothstep(0.0, 0.3, -p.y);
  col = mix(col, vec3(0.914, 0.812, 0.604), rim * 0.18 * (1.0 + uBurst));

  // Brightness: +8% per pulse beat, +20% on burst (spec)
  col *= 1.0 + 0.08 * uPulse + 0.20 * uBurst;

  fragColor = vec4(col * alpha, alpha); // premultiplied alpha
}
