// Settings

// Delcarations
PShader edges;

// Setup
void setup(){
	size(displayWidth, displayHeight,P3D);
	background(0);
	setup_oculus();
}

void draw(){
	println(frameRate);
	oculusRiftDev.draw();
}
void onDrawScene(int eye){

	oculus.draw();
	lights();

	noFill();
	stroke(255);
	box(10);

	pushMatrix();
	translate(0,0,-1.5);
	fill(255);
	noStroke();
	box(0.5);
	popMatrix();

}