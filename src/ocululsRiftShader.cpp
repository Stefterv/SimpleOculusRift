/* 
 *----------------------------------------------------------------------------
 * SimpleOculusRift
 * ----------------------------------------------------------------------------
 * Copyright (C) 2014 Max Rheiner / Interaction Design Zhdk
 *
 * This file is part of SimpleOculusRift.
 *
 * SimpleOpenNI is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version (subject to the "Classpath" exception
 * as provided in the LICENSE.txt file that accompanied this code).
 *
 * SimpleOpenNI is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with SimpleOpenNI.  If not, see <http://www.gnu.org/licenses/>.
 * ----------------------------------------------------------------------------
 */


const char* oculusRiftVertexShader =
"#version 330 core\n"
"\n"
"layout(location = 0) in vec3 Position;\n"
"layout(location = 1) in vec2 TexCoord;\n"
"out vec2 oTexCoord;\n"
"\n"
"void main()\n"
"{\n"
"   gl_Position = vec4(Position, 1);\n"
"   oTexCoord = TexCoord;\n"
"};\n";

const char* oculusRiftFragmentShader =
"#version 330\n"
"\n"
"uniform vec2 LensCenter;\n"
"uniform vec2 ScreenCenter;\n"
"uniform vec2 Scale;\n"
"uniform vec2 ScaleIn;\n"
"uniform vec4 HmdWarpParam;\n"
"uniform sampler2D texture0;\n"
"in vec2 oTexCoord;\n"
"out vec4 outcolor;\n"
"\n"
"vec2 HmdWarp(vec2 in01)\n"
"{\n"
"   vec2  theta = (in01 - LensCenter) * ScaleIn; // Scales to [-1, 1]\n"
"   float rSq = theta.x * theta.x + theta.y * theta.y;\n"
"   vec2  theta1 = theta * (HmdWarpParam.x + HmdWarpParam.y * rSq + \n"
"                           HmdWarpParam.z * rSq * rSq + HmdWarpParam.w * rSq * rSq * rSq);\n"
"   return LensCenter + Scale * theta1;\n"
"}\n"
"void main()\n"
"{\n"
"   vec2 tc = HmdWarp(oTexCoord);\n"
"   if (!all(equal(clamp(tc, ScreenCenter-vec2(0.25,0.5), ScreenCenter+vec2(0.25,0.5)), tc)))\n"
"       outcolor = vec4(0);\n"
"   else\n"
"          outcolor = texture2D(texture0, tc);\n"
"};\n";
