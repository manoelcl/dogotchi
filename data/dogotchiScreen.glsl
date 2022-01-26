uniform vec2 sketchSize;

uniform sampler2D texture;

uniform float u_numberColors;
uniform float u_resolution;


uniform float u_time;


void main(void) {
		
	vec2 uv1 = gl_FragCoord.xy / sketchSize.xy;
	float a = floor(uv1.x * sketchSize.x/u_resolution)/(sketchSize.x/u_resolution);
	float b = floor(uv1.y * sketchSize.y/u_resolution)/(sketchSize.y/u_resolution);
	vec2 uv = vec2(a,b);

	vec3 sourcePixel;
	
	uv -= vec2(.5,.5);
	uv = uv*1.2*(1./1.2+2.*uv.x*uv.x*uv.y*uv.y);
	uv += vec2(.5,.5);
	
	float result=.01;

	sourcePixel.r = .8*texture2D(texture, vec2(uv.x, uv.y)).g ;
	sourcePixel.g = texture2D(texture, vec2(uv.x, uv.y)).g * texture2D(texture, vec2(uv.x-0.1*result, uv.y)).r + texture2D(texture, vec2(uv.x, uv.y)).g;

	vec3 posterize = u_numberColors*sourcePixel;

	posterize = floor(posterize);
	posterize = posterize/u_numberColors;
	sourcePixel = posterize;
	
	float vigAmt=2.;
	float vignette = (1.-vigAmt*(uv1.y-.5)*(uv1.y-.5))*(1.-vigAmt*(uv1.x-.5)*(uv1.x-.5));
	sourcePixel *= vignette;
	gl_FragColor = vec4(sourcePixel,1.0);
	
}

