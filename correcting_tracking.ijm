run("Point Tool...", "type=Hybrid color=Yellow size=Small add label");
//waitForUser("select cells to delete");

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

/////// link tracks
//n track cleaning
roiManager("Open", dir_roi+track_old);
count_old=roiManager("count");
for (n=count_old-1;n>=0;n--)
{
	roiManager("Select", n);
	if (getSliceNumber>frame_old)
	{
		to_delete=n;
	}
}

delete=newArray(count_old-to_delete);
if (lengthOf(delete)>0){
	inc=0;
for (j=to_delete;j<count_old;j++)
{
		delete[inc]=j;
		inc++;
}}

roiManager("Select", delete);
roiManager("Save Selected", dir_roi+"cell_"+test+1+".zip");
roiManager("Delete");


//n+1 track cleaning
roiManager("Open", dir_roi+track_new);
count_new=roiManager("count");
for (n=0;n<count_new;n++)
{
	roiManager("Select", n);
	if (getSliceNumber<=frame_new)
	{
		to_delete=n;
	}
}

delete=newArray(to_delete);
if (lengthOf(delete)>0){
for (j=0;j<to_delete;j++)
{
		delete[j]=j;
}}

///saving corrected track

File.delete(dir_roi+track_new);
selectWindow("Log");run("Close");
saving=roiManager("count"); to_save=newArray(saving);
for (j=0;j<saving;j++) {to_save[j]=j;}
roiManager("select", to_save);
roiManager("Save", dir_roi+track_old);

selectWindow("ROI Manager");run("Close");