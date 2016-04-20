//Extract ROI set from a CellStar phase analysed folder
//Will create a temp file on the desktop which has to be deleted afterward

dir_ori=getDirectory("CellStar directory");
segment_dir=dir_ori+"segments/";
tracking_dir=segment_dir+"tracking/";
segment_files=getFileList(segment_dir);

run("Image Sequence...", "open="+segment_dir+""+segment_files[4]+" file=segments sort");

title=getTitle();
frame=25;
//extract ROI from segmented file
run("Split Channels");
imageCalculator("OR create stack", ""+title+" (red)",""+title+" (green)");
merge=getTitle();
selectWindow(title+" (red)");
close()
selectWindow(title+" (blue)");
close()
selectWindow(title+" (green)");
close()
selectWindow(merge);
setAutoThreshold("Otsu");

setOption("BlackBackground", false);
run("Convert to Mask", "method=Otsu background=Light calculate");
run("Invert", "stack");
run("Erode", "stack");
run("Duplicate...", "duplicate range=1-"+frame);
run("Analyze Particles...", "size=30-Infinity exclude clear add stack");

close();
//close();

//save ROIs in a file
dir_temp="C:\\Users\\machu\\Desktop\\temp/";
File.makeDirectory(dir_temp);

roi=roiManager("count");
roi_frame=newArray(roi);
for (a=0;a<roi;a++)
{
		roi_frame[a]=a;
}
roiManager("Select", roi_frame);
roiManager("Save", ""+dir_temp+"RoiSet.zip");
selectWindow("ROI Manager");run("Close");
run("Select None");


open(tracking_dir+"tracking.csv");


n=nResults();

frame=newArray(n);
cell_num=newArray(n);
xpos=newArray(n);
ypos=newArray(n);

//Fill arrays
for (a=0;a<n;a++)
{
	frame[a]=getResult("Frame_number", a);
	cell_num[a]=getResult("Cell_number", a);
	xpos[a]=getResult("Position_X", a);
	ypos[a]=getResult("Position_Y", a);
}


//loading ROIs
roiManager("Open", dir_temp+"RoiSet.zip");
roi=roiManager("count");
dir_temp2=dir_temp+"Rois/";
File.makeDirectory(dir_temp2);
frame_roi=newArray(roi);
for (b=0;b<roi;b++)
{
	roiManager("Select", b);
	frame_roi[b]=getSliceNumber();
}

//Array.print(frame_roi);
//compare ROIs

for (c=0;c<roi;c++)
{
	for (d=0;d<n;d++)
	{
		if (frame[d]==frame_roi[c])
		{
			roiManager("Select", c);
			yes=Roi.contains(xpos[d], ypos[d]);
			//print(value);
			if (yes==1)
			{
				saveAs("Selection", ""+dir_temp2+"cell_"+cell_num[d]+"_frame_"+frame[d]+".roi");
			}
		}
	}
}



selectWindow("ROI Manager");
run("Close");

//re-open ROIs and pool them by cell
roi_dir=getFileList(dir_temp2);
roi_length=lengthOf(roi_dir);
test=newArray(roi_length);
cell_dir=dir_ori+"Rois/";
File.makeDirectory(cell_dir);

for (z=0;z<roi_length;z++)
{
	start=substring(roi_dir[z],5);
	index=indexOf(start,"_frame");
	number=substring(start,0,index);
	test[z]=number;
}
Array.getStatistics(test, min, max, mean, stdDev);
cellmax=max;

for (w=1;w<=cellmax;w++)
{
	for (y=0;y<roi_length;y++)
	{
		start=substring(roi_dir[y],5);
		index=indexOf(start,"_frame");
		number=substring(start,0,index);
		if (number==w)
		{
			open(""+dir_temp2+""+roi_dir[y]);
			roiManager("Add");
			q=roiManager("count");
			sorting=newArray(q);
			for (l=0;l<q;l++)
			{
				sorting[l]=l;
			}
			roiManager("Select", sorting);
			roiManager("Sort");
			roiManager("Select", sorting);
		}
	}
	roiManager("Save", ""+cell_dir+"cell_"+w+".zip");
	selectWindow("ROI Manager");
	run("Close");
}
close();
//File.delete(dir_temp);
selectWindow("Results");
run("Close");