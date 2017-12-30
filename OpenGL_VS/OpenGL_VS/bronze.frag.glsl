# version 120
// 
// David Tu
// david.tu2@csu.fullerton.edu
// 
// A toy program which renders a teapot and two light sources. 
//
//

// These are passed from the vertex shader to here, the fragment shader
// In later versions of GLSL these are 'in' variables.
varying vec3 myNormal;
varying vec4 myVertex;

// These are passed in from the CPU program
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;
uniform vec4 light0_position;
uniform vec4 light0_color;
uniform vec4 light1_position;
uniform vec4 light1_color;

// The color of each fragment is based on the formula C=W((cos0 + 1)/2)^P where 0 is the angle between the 
//eye vector and the reflection vector, R. This is done for every color component. For red, W = P = 1. For 
//green, W = 1 and P = 2. For blue, W = 1 and P = 20. R = 2N(N*L) - L
vec4 ComputeGoldLight (const in vec3 direction, const in vec4 lightcolor, const in vec3 normal, const in vec3 eyedirn){
  float nDotL = dot(normal, direction);
  vec3 R = normalize((2 * normal * nDotL) - direction);  
  float rDotE = dot(eyedirn, R);

  float red = pow((rDotE + 1)/2, 1);
  float green = pow((rDotE + 1)/2, 2);
  float blue = pow((rDotE + 1)/2, 20);
  
  vec4 retval = lightcolor;
  retval.r = red;
  retval.g = green;
  retval.b = blue;
  return retval;
}      

void main (void){
  // They eye is always at (0,0,0) looking down -z axis 
  // Also compute current fragment position and direction to eye 
  const vec3 eyepos = vec3(0,0,0);
  vec4 _mypos = modelViewMatrix * myVertex;
  vec3 mypos = _mypos.xyz / _mypos.w;
  vec3 eyedirn = normalize(eyepos - mypos);

  // Compute normal, needed for shading. 
  vec4 _normal = normalMatrix * vec4(myNormal, 0.0);
  vec3 normal = normalize(_normal.xyz);

  // Light 0, point
  vec3 position0 = light0_position.xyz / light0_position.w;
  vec3 direction0 = normalize (position0 - mypos);
  vec4 color0 = ComputeGoldLight(direction0, light0_color, normal, eyedirn) ;

  // Light 1, point
  vec3 position1 = light1_position.xyz / light1_position.w;
  vec3 direction1 = normalize(position1 - mypos);
  vec4 color1 = ComputeGoldLight(direction1, light1_color, normal, eyedirn) ;
    
  gl_FragColor = color0 + color1;
}
