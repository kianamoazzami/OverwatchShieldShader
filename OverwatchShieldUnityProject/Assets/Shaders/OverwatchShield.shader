Shader "ShaderProject/OverwatchShield"
{
	Properties
	{
		//_[Name](“[Inspector Name]”, [Type]) = [DefaultValue]

		//expose the color of the shield to the unity editor 
		_Color("Color", COLOR) = (0, 0, 0, 0) //COLOR will give a wheel to select the color
		_PulseTex("Hex Pulse Texture", 2D) = "white" {}
		_PulseIntensity ("Hex Pulse Intensity", float) = 3.0
	}
	SubShader
	{
		Tags {"RenderType" = "Transparent" "Queue" = "Transparent"} //render opaque objects before transparent objects in the render queue
		Cull Off //turn off culling, default set to Back
		//different blend types: https://docs.unity3d.com/Manual/SL-Blend.html
		Blend SrcAlpha One //SrcAlpha is the alpha value (transparency) of the source, One will multiply the destination (background colours) by one 

		Pass
		{
			HLSLPROGRAM

			//#pragma [Function Type] [Function Name]
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			//input parameter for vertex function 
			//mesh data taken in as an input to the vertex function
			//data stored in the mesh 
			struct appdata
			{
				//variable syntax:
				//[Type] [Name] : [Vertex Attribute];
				//common atributes: POSITION, COLOR, TEXCOORD0, TANGENT, NORMAL
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0; //retrieve uv coords from the mesh 
			};

			sampler2D _PulseTex;
			float4 _PulseTex_ST; //stores the tiling and offset values
			float _PulseIntensity;

			//return of vertex function; input of fragment function 
			//v2f -- vertex to fragment 
			struct v2f
			{
				//for GPU rasterizer to know which variable contains the vertex position (in clip space), it must be of type float4 and marked with SV_POSITION
				//rasterizer generates fragments based on this 
				// can add additional variables to this struct-- but they’ll be interpolated across each triangle based on the output of the 3 vertices’ vertex functions
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0; 
			};

			float4 _Color;

			v2f vert (appdata v)
			{
				//vertex position in object space
				//* model matrix = world space
				//* view matrix = camera space
				//* projection matrix = clip space

				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex); //transform from object space into clip space; UnityCG.cginc
				o.uv = TRANSFORM_TEX(v.uv, _PulseTex); // function adjusts the uv coords based on tiling and offset settings (stored in _PulseTex_ST)
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target //color value for fragment
			{
				fixed4 pulseTex = tex2D(_PulseTex, i.uv); // get texture (color value) using the uv coords 
    			fixed4 pulseTerm = pulseTex * _Color * _PulseIntensity; // blend the grey value of the texture with the color
				//final output
				return fixed4(pulseTerm.rgb, _Color.a); // add blended value to the existing colour rgb
			}

			ENDHLSL
		}
	}
}
