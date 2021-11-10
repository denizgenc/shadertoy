// Stolen from https://en.wikipedia.org/wiki/HSL_and_HSV#HSV_to_RGB
// The difference is that hue is [0, 1] and needs to be converted accordingly

vec3 hsv_to_rgb(float hue, float saturation, float value)
{
    float chroma = value * saturation;
    float h_prime = hue * 6.0;
    float x = chroma * (1.0 - abs((mod(h_prime, 2.0) - 1.0)));
    vec3 rgb = vec3(0.0, 0.0, 0.0); // default case
    if (h_prime >= 0.0 && h_prime <= 1.0) {
        rgb = vec3(chroma, x, 0.0);
    }
    if (h_prime > 1.0 && h_prime <= 2.0) {
        rgb = vec3(x, chroma, 0.0);
    }
    if (h_prime > 2.0 && h_prime <= 3.0) {
        rgb = vec3(0.0, chroma, x);
    }
    if (h_prime > 3.0 && h_prime <= 4.0) {
        rgb = vec3(0.0, x, chroma);
    }
    if (h_prime > 4.0 && h_prime <= 5.0) {
        rgb = vec3(x, 0.0, chroma);
    }
    if (h_prime > 5.0 && h_prime <= 6.0) {
        rgb = vec3(chroma, 0.0, x);
    }
    rgb += (value - chroma);
    return rgb;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Centre of the image
    vec2 centre = vec2(0.5,0.5);
    // Normalized pixel coordinates (from 0 to 1)
    vec2 pixel_uv = fragCoord/iResolution.xy;
    // pixel coordinate based on where it is relative to centre
    vec2 relative = pixel_uv - centre;
    
    // Saturation - length from centre, normalised 
    float saturation = length(relative)/length(vec2(0.5,0.5));
    
    // Angle from centre point, measured anti-clockwise from x axis
    // (converted from range [-pi, pi] to [0, 2pi])
    float angle = atan(relative.y, relative.x) + radians(180.0);
    
    // Hue: above angle, normalised
    float hue = angle/radians(360.0);
    
    // Value - we just want this at 1 for maximum colour
    float value = 1.0;

    hue = mod(hue + iTime, 1.0);

    vec3 col = hsv_to_rgb(hue, saturation, value);

    // Output to screen
    fragColor = vec4(col,1.0);
}
