ref=getSliceNumber();
dir=getDirectory("image");
dir_roi=dir+"/Rois/";
files=getFileList(dir_roi);
original=getTitle();
n=nSlices()
run("Properties...", "channels=1 slices=1 frames="+n+" unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1 frame=[50.57 sec]");

/////get cells to delete coordinates
points=roiManager("count");
//x_pos=newArray(points);
//y_pos=newArray(points);
//frame=newArray(points);

for (a=0;a<points;a++)
{
	roiManager("Select", a);
	Roi.getCoordinates(xpoints, ypoints);
	x_pos=xpoints[0];
	y_pos=ypoints[0];
	frame=getSliceNumber();
}
selectWindow("ROI Manager");run("Close");

for (b=0;b<lengthOf(files);b++)
{
	roiManager("Open", dir_roi+files[b]);
	cells=roiManager("count");
	for (c=0;c<cells;c++)
	{
		roiManager("Select", c);
		if (Roi.contains(x_pos, y_pos)==1 && getSliceNumber==frame)
		{
			File.delete(dir_roi+files[b]);
			selectWindow("Log");run("Close");
		}
	}
	selectWindow("ROI Manager");run("Close");
}


////redrawing tracks
close();
open(dir+original);
run("RGB Color");
files=getFileList(dir_roi);
colors=newArray("Grays","Green","Blue","Cyan","Yellow","Magenta","White");
setBatchMode(true);
counter=0;
for (a=0;a<lengthOf(files);a++)
{
	roiManager("Open", dir_roi+files[a]);
	roiManager("Select", 0);
	run("Colors...", "foreground=red background=black selection=yellow");	
	run("Fill", "slice");
	cells=roiManager("count");
	run("Colors...", "foreground="+colors[counter]+" background=black selection=yellow");
	to_fill=newArray(cells-1);
	for (b=0;b<lengthOf(to_fill);b++){to_fill[b]=b+1;}
	roiManager("Select", to_fill);
	roiManager("Fill");
	to_delete=newArray(cells);
	for (b=0;b<lengthOf(to_delete);b++){to_delete[b]=b;}
	roiManager("Select", to_delete);
	roiManager("Delete");
	counter++;
	if (counter>=lengthOf(colors)) {counter=0;}
}
