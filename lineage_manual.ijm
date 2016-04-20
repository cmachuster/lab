dir=getDirectory("image");
dir_roi=dir+"/Rois/";
files=getFileList(dir_roi);
original=getTitle();
n=nSlices()
height=getHeight();
width=getWidth();
run("Properties...", "channels=1 slices=1 frames="+n+" unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1 frame=[50.57 sec]");
if (isOpen("Results")==true)
	{n=nResults();}
else {n=0;}

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
frame_m=0;
roiManager("Select", 0);
Roi.getCoordinates(xpoints, ypoints);
x_mo=xpoints[0];
y_mo=ypoints[0];
frame_mo=getSliceNumber();

roiManager("Select", 1);
Roi.getCoordinates(xpoints, ypoints);
x_dau=xpoints[0];
y_dau=ypoints[0];
frame_dau=getSliceNumber();
if (roiManager("count")==3){
roiManager("Select", 2);
frame_m=getSliceNumber();}
selectWindow("ROI Manager");run("Close");
setBatchMode(true);
newImage("fluo1", "8-bit black", width, height, 25);
for (a=0;a<lengthOf(files);a++)
{
	roiManager("Open", dir_roi+files[a]);
	cells=roiManager("count");
	for (b=0;b<cells;b++)
	{
		roiManager("Select", b);
		if (Roi.contains(x_mo, y_mo)==1 && getSliceNumber==frame_mo)
		{
			mo_file=files[a];
		}
		if (Roi.contains(x_dau, y_dau)==1 && getSliceNumber==frame_dau)
		{
			dau_file=files[a];
		}
	}
	to_trash=newArray(cells);
	for (i=0;i<cells;i++) {to_trash[i]=i;}
	roiManager("Select", to_trash);
	roiManager("Delete");	
}
setBatchMode(false);
//selectWindow("ROI Manager");run("Close");
selectWindow("fluo1");close();
mo_cell=substring(mo_file,indexOf(mo_file,"_")+1,lengthOf(mo_file)-4);
dau_cell=substring(dau_file,indexOf(dau_file,"_")+1,lengthOf(dau_file)-4);

setResult("mother",n,mo_cell);
setResult("daughter",n,dau_cell);
setResult("frame_m",n,frame_m);

updateResults();


//////////burning done cells
roiManager("Open", dir_roi+mo_file);
roiManager("Open", dir_roi+dau_file);
roiManager("Sort");
////adjusting roi selection for mother
count_mo=roiManager("count");
inc=0;
for (c=0;c<count_mo;c++)
{
	roiManager("Select", c);
	if (getSliceNumber==frame_m) {inc=c;}
}
if (frame_m>0) {

to_remove=newArray(count_mo-1-inc);
incd=0;
for (cc=inc+1;cc<count_mo;cc++) {to_remove[incd]=cc;incd++;}
roiManager("Select", to_remove);
//Array.print(to_remove);
roiManager("Delete");}



to_fill=roiManager("count");
filling=newArray(to_fill);
for (t=0;t<to_fill;t++) {filling[t]=t;}
run("Colors...", "foreground=yellow background=black selection=yellow");
roiManager("Select", filling);
roiManager("Fill");
selectWindow("ROI Manager");run("Close");
setSlice(frame_mo);