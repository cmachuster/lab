Dialog.create("Sensitivity settings");
Dialog.addNumber("detection thresholding", 500);
Dialog.show();
sens=Dialog.getNumber();
original=getTitle();

//// Extract nuclei from the DAPI channel ////////////

run("Duplicate...", "duplicate channels=3");
dapi_stack=getTitle();
run("Subtract Background...", "rolling=100 stack");
run("Z Project...", "projection=[Max Intensity]");
selectWindow(dapi_stack);close();
setAutoThreshold("Li");
setOption("BlackBackground", false);
run("Convert to Mask");
//run("Invert");
run("Properties...", "channels=1 slices=1 frames=1 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1");
run("Analyze Particles...", "size=1500-Infinity exclude add");
close();


/////// Extract spots and intensities from the GFP (channel 2) channel //////////
run("Duplicate...", "duplicate channels=2");
gfp_stack=getTitle();
run("Subtract Background...", "rolling=50 stack");
run("Z Project...", "projection=[Max Intensity]");
gfp_flat=getTitle();
selectWindow(gfp_stack);close();

/// exclude spots out of the nuclei
c=roiManager("count");
array=newArray(c); for (x=0;x<c;x++) {array[x]=x;}
selectWindow(gfp_flat);
roiManager("Select", array);
roiManager("Combine"); run("Clear Outside");
run("Select None");
empty=getTitle();
/// Detect Maxima
run("Properties...", "channels=1 slices=1 frames=1 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1");
run("Find Maxima...", "noise="+sens+" output=List");
//close();
////// Saving points positions
n=nResults();
x_spot=newArray(n);
y_spot=newArray(n);

for (a=0;a<n;a++)
{
	x_spot[a]=getResult("X",a);
	y_spot[a]=getResult("Y",a);
}
selectWindow("Results"); run("Close");
////// get spot intensities from original Z proj
selectWindow(original);
run("Duplicate...", "duplicate channels=2");
gfp_stack=getTitle();
run("Z Project...", "projection=[Max Intensity]");
gfp_flat=getTitle();
run("Properties...", "channels=1 slices=1 frames=1 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1");
selectWindow(gfp_stack);close();
selectWindow(gfp_flat);
int=newArray(n);

for (b=0;b<n;b++)
{
	selectWindow(gfp_flat);
	int[b]=getPixel(x_spot[b],y_spot[b]);
}
//// getting background value
selectWindow(empty);
for (m=0;m<n;m++)
{
	makeOval(x_spot[m]-3, y_spot[m]-3, 5, 5);
	run("Clear", "slice");
}
run("Select None");
run("Measure");
back=getResult("Mean");
background=newArray(n); Array.fill(background,back);
close();
//close();
selectWindow("Results"); run("Close");
//// Display Results 
selectWindow(gfp_flat);
run("Duplicate...", " ");
disp=getTitle();
run("RGB Color");run("Colors...", "foreground=yellow background=black selection=yellow");
selectWindow(gfp_flat);close();	


for (t=0;t<n;t++)
{
	run("Colors...", "foreground=yellow background=black selection=yellow");
	drawOval(x_spot[t]-3, y_spot[t]-3, 5, 5);
}
roiManager("Select", array);roiManager("Combine");run("Draw");
selectWindow("ROI Manager");run("Close");

//selectWindow("Results"); run("Close");

Array.show("Intensities",int,background);