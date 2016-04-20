run("Colors...", "foreground=white background=black selection=yellow");
dir_ori=getDirectory("Analysis Directory");
orifi=getFileList(dir_ori);
ori_files=lengthOf(orifi);
for (z=0;z<ori_files;z++)
{
 yfp=indexOf(orifi[z], "YFP");
 rfp=indexOf(orifi[z], "CFP");
 tif=indexOf(orifi[z], "binary.tif");
	if (tif>=0 && yfp>=0)
	{
	open(dir_ori+orifi[z]);
	YFP=getTitle();
	}
	if (tif>=0 && rfp>=0)
	{
	open(dir_ori+orifi[z]);
	RFP=getTitle();
	}
}
////////////////////////For YFP ///////////////////////////
selectWindow(YFP);
height=getHeight();
width=getWidth();
n=nSlices();
newImage("fluo1", "8-bit black", width, height, n);
fluo1=getTitle();
selectWindow(YFP);
run("Select None");
run("Properties...", "channels=1 slices="+n+" frames=1 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1");
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=1 frames="+n+" display=Grayscale");
runMacro("C:\\Users\\machu\\Documents\\Fiji.app\\macros\\trackmate.py");

//selectWindow("Log");run("Close");
count=nResults();
x_pos=newArray(count);
y_pos=newArray(count);
frame=newArray(count);

for (a=0;a<count;a++)
{
	x_pos[a]=getResult("X_POS",a);
	y_pos[a]=getResult("Y_POS",a);
	frame[a]=getResult("Frame",a);
}
selectWindow("Results");run("Close");

selectWindow(fluo1);
for (k=0;k<count;k++)
{
	setSlice(frame[k]+1);
	fillOval(x_pos[k]-1, y_pos[k]-1, 3, 3);
}


/////open Rois to confront them with spots
rois=getFileList(dir_ori+"/Rois");
files=lengthOf(rois);
for (b=0;b<files;b++)
{
	roiManager("Open", dir_ori+"/Rois/"+rois[b]);
	slides=roiManager("count");
	cell=newArray(n);Array.fill(cell, -1);
	roiManager("select", 0);
	ref=getSliceNumber();
	for(m=ref-1;m<n;m++) {cell[m]=0;}
	for (c=0;c<slides;c++)
	{
		roiManager("select", c);
		for (d=0;d<count;d++)
		{
			if (Roi.contains(x_pos[d], y_pos[d])==1 && getSliceNumber==frame[d]+1)
			{	
				cell[getSliceNumber-1]=cell[getSliceNumber-1]+1;
			}
		}
	}
	for (g=0;g<n;g++)
	{
		setResult(substring(rois[b],0,lengthOf(rois[b])-4), g, cell[g]);
	}
	selectWindow("ROI Manager");run("Close");
}
updateResults();
saveAs("Results", dir_ori+substring(YFP,0,lengthOf(YFP)-4)+".xls");
selectWindow("Results");run("Close");
selectWindow(YFP);
close();
////////////////////////For RFP ///////////////////////////
selectWindow(RFP);
n=nSlices();
newImage("fluo2", "8-bit black", width, height, n);
fluo2=getTitle();
selectWindow(RFP);
run("Select None");
run("Properties...", "channels=1 slices="+n+" frames=1 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1");
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=1 frames="+n+" display=Grayscale");
runMacro("C:\\Users\\machu\\Documents\\Fiji.app\\macros\\trackmate.py");

//selectWindow("Log");run("Close");
count=nResults();
x_pos=newArray(count);
y_pos=newArray(count);
frame=newArray(count);

for (a=0;a<count;a++)
{
	x_pos[a]=getResult("X_POS",a);
	y_pos[a]=getResult("Y_POS",a);
	frame[a]=getResult("Frame",a);
}
selectWindow("Results");run("Close");
selectWindow(fluo2);
for (k=0;k<count;k++)
{
	setSlice(frame[k]+1);
	fillOval(x_pos[k]-1, y_pos[k]-1, 3, 3);
}

/////open Rois to confront them with spots
rois=getFileList(dir_ori+"/Rois");
files=lengthOf(rois);
for (b=0;b<files;b++)
{
	roiManager("Open", dir_ori+"/Rois/"+rois[b]);
	slides=roiManager("count");
	cell=newArray(n);Array.fill(cell, -1);
	roiManager("select", 0);
	ref=getSliceNumber();
	for(m=ref-1;m<n;m++) {cell[m]=0;}
	for (c=0;c<slides;c++)
	{
		roiManager("select", c);
		for (d=0;d<count;d++)
		{
			if (Roi.contains(x_pos[d], y_pos[d])==1 && getSliceNumber==frame[d]+1)
			{	
				cell[getSliceNumber-1]=cell[getSliceNumber-1]+1;
			}
		}
	}
	for (g=0;g<n;g++)
	{
		setResult(substring(rois[b],0,lengthOf(rois[b])-4), g, cell[g]);
	}
	selectWindow("ROI Manager");run("Close");
}
updateResults();
saveAs("Results", dir_ori+substring(RFP,0,lengthOf(RFP)-4)+".xls");
selectWindow("Results");run("Close");
selectWindow(RFP);
close();

///////////Make coloc////////////////
imageCalculator("AND create stack", "fluo1","fluo2");
coloc=getTitle();
imageCalculator("Subtract create stack", "fluo1","fluo2");
cdc13_only=getTitle();
selectWindow(fluo1);close();
selectWindow(fluo2);close();
selectWindow(coloc);
run("Select None");
run("Properties...", "channels=1 slices="+n+" frames=1 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1");
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=1 frames="+n+" display=Grayscale");
runMacro("C:\\Users\\machu\\Documents\\Fiji.app\\macros\\trackmate.py");
if (isOpen("Log")==false){
//selectWindow("Log");run("Close");
count=nResults();
x_pos=newArray(count);
y_pos=newArray(count);
frame=newArray(count);

for (a=0;a<count;a++)
{
	x_pos[a]=getResult("X_POS",a);
	y_pos[a]=getResult("Y_POS",a);
	frame[a]=getResult("Frame",a);
}
selectWindow("Results");run("Close");


/////open Rois to confront them with spots
rois=getFileList(dir_ori+"/Rois");
files=lengthOf(rois);
for (b=0;b<files;b++)
{
	roiManager("Open", dir_ori+"/Rois/"+rois[b]);
	slides=roiManager("count");
	cell=newArray(n);Array.fill(cell, -1);
	roiManager("select", 0);
	ref=getSliceNumber();
	for(m=ref-1;m<n;m++) {cell[m]=0;}
	for (c=0;c<slides;c++)
	{
		roiManager("select", c);
		for (d=0;d<count;d++)
		{
			if (Roi.contains(x_pos[d], y_pos[d])==1 && getSliceNumber==frame[d]+1)
			{	
				cell[getSliceNumber-1]=cell[getSliceNumber-1]+1;
			}
		}
	}
	for (g=0;g<n;g++)
	{
		setResult(substring(rois[b],0,lengthOf(rois[b])-4), g, cell[g]);
	}
	selectWindow("ROI Manager");run("Close");
}
updateResults();
saveAs("Results", dir_ori+"coloc.xls");
selectWindow("Results");run("Close");
selectWindow(coloc);
close();
//////for cdc13_only//////////////
selectWindow(cdc13_only);
run("Select None");
run("Properties...", "channels=1 slices="+n+" frames=1 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1");
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=1 frames="+n+" display=Grayscale");
runMacro("C:\\Users\\machu\\Documents\\Fiji.app\\macros\\trackmate.py");
if (isOpen("Log")==false){
//selectWindow("Log");run("Close");
count=nResults();
x_pos=newArray(count);
y_pos=newArray(count);
frame=newArray(count);

for (a=0;a<count;a++)
{
	x_pos[a]=getResult("X_POS",a);
	y_pos[a]=getResult("Y_POS",a);
	frame[a]=getResult("Frame",a);
}
selectWindow("Results");run("Close");


/////open Rois to confront them with spots
rois=getFileList(dir_ori+"/Rois");
files=lengthOf(rois);
for (b=0;b<files;b++)
{
	roiManager("Open", dir_ori+"/Rois/"+rois[b]);
	slides=roiManager("count");
	cell=newArray(n);Array.fill(cell, -1);
	roiManager("select", 0);
	ref=getSliceNumber();
	for(m=ref-1;m<n;m++) {cell[m]=0;}
	for (c=0;c<slides;c++)
	{
		roiManager("select", c);
		for (d=0;d<count;d++)
		{
			if (Roi.contains(x_pos[d], y_pos[d])==1 && getSliceNumber==frame[d]+1)
			{	
				cell[getSliceNumber-1]=cell[getSliceNumber-1]+1;
			}
		}
	}
	for (g=0;g<n;g++)
	{
		setResult(substring(rois[b],0,lengthOf(rois[b])-4), g, cell[g]);
	}
	selectWindow("ROI Manager");run("Close");
}
updateResults();
saveAs("Results", dir_ori+"cdc13_only.xls");
selectWindow("Results");run("Close");
selectWindow(coloc);
close();



}
else {
	selectWindow("Log");run("Close");
	selectWindow(coloc);
	close();}