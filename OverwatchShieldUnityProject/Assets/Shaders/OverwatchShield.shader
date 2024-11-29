Shader "ShaderProject/OverwatchShield"
{
	Properties
	{
		//_[Name](“[Inspector Name]”, [Type]) = [DefaultValue]

		//expose the color of the shield to the unity editor 
		_Color("Color", COLOR) = (0, 0, 0, 0) //COLOR will give a wheel to select the color
		
	}
	SubShader
	{
		Cull Off //turn off culling, default set to Back
		Tags {"RenderType" = "Transparent" "Queue" = "Transparent"} //render opaque objects before transparent objects in the render queue
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
			struct appdata
			{
				//variable syntax:
				//[Type] [Name] : [Vertex Attribute];

				//common atributes: POSITION, COLOR, TEXCOORD0, TANGENT, NORMAL

				float4 vertex : POSITION;
			};

			//return of vertex function; input of fragment function 
			//v2f -- vertex to fragment 
			struct v2f
			{
				//for GPU rasterizer to know which variable contains the vertex position (in clip space), it must be of type float4 and marked with SV_POSITION
				//rasterizer generates fragments based on this 
				// can add additional variables to this struct-- but they’ll be interpolated across each triangle based on the output of the 3 vertices’ vertex functions
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				//vertex position in object space
				//x model matrix = world space
				//x view matrix = camera space
				//x projection matrix = clip space

				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex); //transform from object space into clip space; UnityCG.cginc
				return o;
			}

			float4 _Color;
			
			fixed4 frag (v2f i) : SV_Target //color value for fragment
			{
				//final output
				return _Color;
			}

			ENDHLSL
		}
	}
}
