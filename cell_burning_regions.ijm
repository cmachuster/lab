dir=getDirectory("image");
original=getTitle();

n=nSlices();
run("RGB Color");
run("Colors...", "foreground=yellow background=black selection=yellow");
roiManager("Open", dir+substring(original,0,lengthOf(original)-4)+".zip");
run("Properties...", "channels=1 slices=1 frames="+n+" unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1 frame=[50.57 sec]");

roi=roiManager("count");
for (d=0;d<roi;d++)
{
	roiManager("Select", d);
	run("Draw","slices");
		
}
selectWindow("ROI Manager");run("Close");