//setTool("oval");
//twaitForUser("add missing cells");
ref=getSliceNumber();
dir=getDirectory("image");
original=getTitle();
n=nSlices()
run("Properties...", "channels=1 slices=1 frames="+n+" unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1 frame=[50.57 sec]");

roiManager("Open", dir+substring(original,0,lengthOf(original)-4)+".zip");

roiManager("Sort");

saving=roiManager("count"); to_save=newArray(saving);
for (j=0;j<saving;j++) {to_save[j]=j;}
roiManager("select", to_save);
roiManager("Save", dir+substring(original, 0, lengthOf(original)-4)+".zip");

/// re-burning regions

close();
open(dir+original);
run("RGB Color");
run("Colors...", "foreground=yellow background=black selection=yellow");
n=nSlices()
run("Properties...", "channels=1 slices=1 frames="+n+" unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1 frame=[50.57 sec]");

roi=roiManager("count");
for (d=0;d<roi;d++)
{
	roiManager("Select", d);
	run("Draw","slices");
		
}
selectWindow("ROI Manager");run("Close");
setSlice(ref);