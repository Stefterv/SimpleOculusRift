import SimpleOculusRift.*;
SimpleOculusRift oculusRiftDev;

void setup_oculus(){
	println(this);
	oculusRiftDev = new SimpleOculusRift(this,SimpleOculusRift.RenderQuality_High);
	oculus.setup();
	frameRate(75);
}
Oculus oculus = new Oculus();
class Oculus{
	float yRot;
	float xRot;
	float zRot;
	JSONObject data;
	Runtime rt;
	Process pr;
	PMatrix3D rotation;
	Oculus(){

	}
	void setup(){

		thread("update_oculus");
	}
	void update(){
		while(true){
			try{
				data = loadJSONObject("http://localhost:50000");
				yRot = data.getJSONObject("euler").getFloat("y"); // A
				xRot = data.getJSONObject("euler").getFloat("p"); // B
				zRot = data.getJSONObject("euler").getFloat("r"); //Y
				float x = data.getJSONObject("quat").getFloat("x"); //Y
				float y = data.getJSONObject("quat").getFloat("y"); //Y
				float z = data.getJSONObject("quat").getFloat("z"); //Y
				float w = data.getJSONObject("quat").getFloat("w"); //Y
				float xx = x * x;
				float xy = x * y;
				float xz = x * z;
				float xw = x * w;

				float yy = y * y;
				float yz = y * z;
				float yw = y * w;

				float zz = z * z;
				float zw = z * w;

				float m00  = 1 - 2 * ( yy + zz );
				float m01  =     2 * ( xy - zw );
				float m02 =     2 * ( xz + yw );

				float m10  =     2 * ( xy + zw );
				float m11  = 1 - 2 * ( xx + zz );
				float m12  =     2 * ( yz - xw );

				float m20  =     2 * ( xz - yw );
				float m21  =     2 * ( yz + xw );
				float m22 = 1 - 2 * ( xx + yy );

				PMatrix3D rotation = new PMatrix3D(
					m00, m01, m02, 0,
					m10, m11, m12, 0,
					m20, m21, m22, 0,
					0, 0, 0, 1
				);
				this.rotation = rotation;
				PVector pos = new PVector(
					data.getJSONObject("position").getFloat("x"),
					data.getJSONObject("position").getFloat("y"),
					data.getJSONObject("position").getFloat("z")
				);
				rotation.translate(pos.x,pos.y,pos.z);
				rotation.invert();
			}catch(Exception e){

			}
			delay(20);
		}
	}
	void draw(){
		scale(0.5,1);
		applyMatrix(oculus.rotation);
	}
}
void update_oculus(){
	oculus.update();
}