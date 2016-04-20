run("Point Tool...", "type=Hybrid color=Yellow size=Small add label");
//waitForUser("select cells to delete");
ref=getSliceNumber();
dir=getDirectory("image");
original=getTitle();
n=nSlices()
run("Properties...", "channels=1 slices=1 frames="+n+" unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1 frame=[50.57 sec]");

/////get cells to delete coordinates
points=roiManager("count");
x_pos=newArray(points);
y_pos=newArray(points);
frame=newArray(points);

for (a=0;a<points;a++)
{
	roiManager("Select", a);
	Roi.getCoordinates(xpoints, ypoints);
	x_pos[a]=xpoints[0];
	y_pos[a]=ypoints[0];
	frame[a]=getSliceNumber();
}
selectWindow("ROI Manager");run("Close");

/////Open cells and confront them with selected cells
roiManager("Open", dir+substring(original,0,lengthOf(original)-4)+".zip");

cells=roiManager("count");
to_delete=newArray(points);
for (b=0;b<cells;b++)
{
	for (c=0;c<points;c++)
	{
		roiManager("Select", b);
		if (Roi.contains(x_pos[c], y_pos[c])==1 && getSliceNumber==frame[c])
		{
			to_delete[c]=b;
		}
	}
}

//// delete cells and save the new selection
roiManager("Select", to_delete);
roiManager("Delete");
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