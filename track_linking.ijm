dir=getDirectory("image");
dir_roi=dir+"/Rois/";
files=getFileList(dir_roi);
original=getTitle();
n=nSlices()
run("Properties...", "channels=1 slices=1 frames="+n+" unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1 frame=[50.57 sec]");
///getting last name in the folder
test=0;
for (v=0;v<lengthOf(files);v++)
{
	last_roi=files[v];
	short=substring(last_roi, 0, lengthOf(last_roi)-4);
	num=substring(short,indexOf(short, "_")+1,lengthOf(short));
	num=parseInt(num);
	if (num>test) {test=num;}
}

/////getting tracks to link

roiManager("Select", 0);
Roi.getCoordinates(xpoints, ypoints);
x_old=xpoints[0];
y_old=ypoints[0];
frame_old=getSliceNumber();

roiManager("Select", 1);
Roi.getCoordinates(xpoints, ypoints);
x_new=xpoints[0];
y_new=ypoints[0];
frame_new=getSliceNumber();

selectWindow("ROI Manager");run("Close");

for (a=0;a<lengthOf(files);a++)
{
	roiManager("Open", dir_roi+files[a]);
	cells=roiManager("count");
	for (b=0;b<cells;b++)
	{
		roiManager("Select", b);
		if (Roi.contains(x_old, y_old)==1 && getSliceNumber==frame_old)
		{
			track_old=files[a];
		}
		if (Roi.contains(x_new, y_new)==1 && getSliceNumber==frame_new)
		{
			track_new=files[a];
		}
	}
	selectWindow("ROI Manager");run("Close");
}

///measuring track gap
roiManager("Open", dir_roi+track_old);
count_old=roiManager("count");
roiManager("Select", count_old-1);
slice_old=getSliceNumber;
selectWindow("ROI Manager");run("Close");

roiManager("Open", dir_roi+track_new);
count_new=roiManager("count");
roiManager("Select", 0);
slice_new=getSliceNumber;
selectWindow("ROI Manager");run("Close");

gap=slice_new-slice_old-1;

/// Adding extra roi(s) and fusing
roiManager("Open", dir_roi+track_old);
count_old=roiManager("count");
roiManager("Select", count_old-1);roiManager("Add");
for (s=1;s<=gap;s++)
{
	setSlice(slice_old+s);
	roiManager("Update");
	
}
roiManager("Open", dir_roi+track_new);
roiManager("Sort");

///saving corrected track

File.delete(dir_roi+track_new);
selectWindow("Log");run("Close");
saving=roiManager("count"); to_save=newArray(saving);
for (j=0;j<saving;j++) {to_save[j]=j;}
roiManager("select", to_save);
roiManager("Save", dir_roi+track_old);

selectWindow("ROI Manager");run("Close");
