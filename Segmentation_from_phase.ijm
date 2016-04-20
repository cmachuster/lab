Dialog.create("Burning Regions");
Dialog.addCheckbox("burning regions after detections ?", true);
Dialog.show();
burn=Dialog.getCheckbox();
dir=getDirectory("image");
dir_save=dir+"/Rois/";
File.makeDirectory(dir_save);
original=getTitle();
run("Colors...", "foreground=yellow background=black selection=yellow");
//run("Gaussian Blur...", "sigma=1 stack");
n=nSlices();
y=getHeight();
x=getWidth();
setBatchMode(true);
newImage("Untitled", "16-bit black", x, y, n);
clone=getTitle();
setSlice(1);

for (a=1;a<=n;a++)
{
	selectWindow(original);
	setSlice(a);
	run("Duplicate...", " ");
	run("FFT");
	makeRectangle(0, 1019, 2048, 10);
	run("Clear", "slice");
	run("Select None");
	run("Inverse FFT");
	run("Copy");
	//close();
	selectWindow(clone);
	setSlice(a);
	run("Paste");
}
resetMinAndMax();

run("Gaussian Blur...", "sigma=2 stack");
//run("Minimum...", "radius=1 stack");
run("Multiply...", "value=4 stack");
run("Convert to Mask", "method=Li background=Default calculate");

/// removing speckles
run("Analyze Particles...", "size=0-120 circularity=0.30-1.00 exclude clear add stack");
run("Invert", "stack");

spec=roiManager("count");

for (b=0;b<spec;b++)
{
	roiManager("select", b);
	run("Clear", "slice");
}
run("Select None");
//selectWindow("ROI Manager"); run("Close");

//// Exctracting cells

run("Watershed", "stack");
setBatchMode(false);
run("Analyze Particles...", "size=130-4000 circularity=0.6-1.00 exclude clear add stack");
selectWindow(clone); close();

//// Enlarge ROIs

spec=roiManager("count");

for (b=0;b<spec;b++)
{
	roiManager("select", b);
	run("Enlarge...", "enlarge=2 pixel");
	run("Fit Ellipse");
	roiManager("Update");
}
run("Select None");
roiManager("Show None");

if (burn==true);
{
	roi=roiManager("count");
	for (c=0;c<roi;c++)
	{
		roiManager("Select", c);
		run("Draw","slices");
		
	}
}

roi=roiManager("count");
to_save=newArray(roi);
for (nn=0;nn<roi;nn++)
{
	to_save[nn]=nn;
}
roiManager("select", to_save);
roiManager("Save", dir+substring(original, 0, lengthOf(original)-4)+".zip");
selectWindow("ROI Manager");run("Close");