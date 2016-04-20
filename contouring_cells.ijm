dir=getDirectory("image");
dir_cell=dir+"Rois/";
rois=getFileList(dir_cell);
files=lengthOf(rois);
run("RGB Color");
run("Set Measurements...", "area mean center fit integrated redirect=None decimal=3");
run("Properties...", "channels=1 slices=1 frames=25 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1 frame=[50.72 sec]");
setFont("SansSerif", 18, " antialiased");
setColor("yellow");
run("Colors...", "foreground=yellow background=black selection=yellow");
setFont("SansSerif", 14, " antialiased");
for (a=0;a<files;a++)
{
	num=substring(rois[a], 5, lengthOf(rois[a])-4);
	roiManager("Open", dir_cell+rois[a]);
	n=roiManager("count");
	roiManager("Select", 0);
	run("Colors...", "foreground=red background=black selection=yellow");
	setColor("red");
	run("Draw","slices");
	//run("Measure");
	//x=getResult("XM");
	//y=getResult("YM");
	//selectWindow("Results");run("Close");
	//drawString(num, x-2, y-3);
	setBatchMode(true);
	for (b=1;b<n;b++)
	{
		run("Colors...", "foreground=yellow background=black selection=yellow");setColor("yellow");
		roiManager("Select", b);
		run("Draw","slices");
		//run("Measure");
		//x=getResult("XM");
		//y=getResult("YM");
		//selectWindow("Results");run("Close");
		//drawString(num, x-2, y-3);
	}
	to_delete=newArray(n);
	for(t=0;t<n;t++) {to_delete[t]=t;}
	roiManager("Select", to_delete);
	roiManager("Delete");
	
}
setBatchMode(false);
selectWindow("ROI Manager");run("Close");
setSlice(1);