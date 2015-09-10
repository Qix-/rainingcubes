//
//  SIMDExtensions.h
//  RainingCubes
//
//  Created by Nick Zitzmann on 8/29/15.
//  Copyright © 2015 Nick Zitzmann. All rights reserved.
//

#ifndef SIMDExtensions_h
#define SIMDExtensions_h

#include <simd/simd.h>
#include <CoreFoundation/CoreFoundation.h>

CF_INLINE matrix_float4x4 matrix_from_perspective_fov_aspectLH(const float fovY, const float aspect, const float nearZ, const float farZ)
{
	float yscale = 1.0f / tanf(fovY * 0.5f); // 1 / tan == cot
	float xscale = yscale / aspect;
	float q = farZ / (farZ - nearZ);
	
	matrix_float4x4 m = {
		.columns[0] = { xscale, 0.0f, 0.0f, 0.0f },
		.columns[1] = { 0.0f, yscale, 0.0f, 0.0f },
		.columns[2] = { 0.0f, 0.0f, q, 1.0f },
		.columns[3] = { 0.0f, 0.0f, q * -nearZ, 0.0f }
	};
	
	return m;
}

CF_INLINE matrix_float4x4 matrix_from_translation(float x, float y, float z)
{
	matrix_float4x4 m = matrix_identity_float4x4;
	m.columns[3] = (vector_float4) { x, y, z, 1.0 };
	return m;
}

CF_INLINE matrix_float4x4 matrix_from_rotation(float radians, float x, float y, float z)
{
	vector_float3 v = vector_normalize(((vector_float3){x, y, z}));
	float cos = cosf(radians);
	float cosp = 1.0f - cos;
	float sin = sinf(radians);
	
	matrix_float4x4 m = {
		.columns[0] = {
			cos + cosp * v.x * v.x,
			cosp * v.x * v.y + v.z * sin,
			cosp * v.x * v.z - v.y * sin,
			0.0f,
		},
		
		.columns[1] = {
			cosp * v.x * v.y - v.z * sin,
			cos + cosp * v.y * v.y,
			cosp * v.y * v.z + v.x * sin,
			0.0f,
		},
		
		.columns[2] = {
			cosp * v.x * v.z + v.y * sin,
			cosp * v.y * v.z - v.x * sin,
			cos + cosp * v.z * v.z,
			0.0f,
		},
		
		.columns[3] = { 0.0f, 0.0f, 0.0f, 1.0f
		}
	};
	return m;
}

#endif /* SIMDExtensions_h */
