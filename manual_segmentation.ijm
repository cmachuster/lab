dir=getDirectory("image");
n=roiManager("count");
dir_cell=dir+"cells/";
File.makeDirectory(dir_cell);
run("Colors...", "foreground=yellow background=black selection=yellow");

////////// checking for doubles ///////////////////
roiManager("Select", 0);
for (d=1;d<n;d++)
{
	prev=getSliceNumber();
	roiManager("Select", d);
	a=getSliceNumber();
	if (a==prev) {roiManager("Delete");n=roiManager("count");}
}
n=roiManager("count");

///////// filling array //////////////////////////
select=newArray(n);
for (a=0;a<n;a++) {select[a]=a;}

roiManager("Select", select);

///////// check for already registered cells and save //////////////

rois=getFileList(dir_cell);
files=lengthOf(rois);
suf=newArray(files);
if (files>0) {
for (h=0;h<files;h++)
{
	text=substring(rois[h], 5, lengthOf(rois[h])-4);
	ad=parseFloat(text);
	suf[h]=text;
	Array.getStatistics(suf, min, max, mean, stdDev);
	
}
	roiManager("Save", dir+"/cells/cell_"+max+1+".zip");
}
else {roiManager("Save", dir+"/cells/cell_1.zip")};


////////// tag cells and empty the list //////////////////////
n=roiManager("count");
for (b=0;b<n;b++) {roiManager("Select", b);run("Draw","slices");}

roiManager("Select", select);
roiManager("Delete");
setSlice(1);