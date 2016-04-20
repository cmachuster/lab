n=nSlices();
run("Select None");
dir=getDirectory("image");
original=getTitle();
run("Properties...", "channels=1 slices="+n+" frames=1 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1");
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=1 frames="+n+" display=Grayscale");
runMacro("C:\\Users\\cmach\\Documents\\Fiji.app\\macros\\trackmate.py");

selectWindow("Log");run("Close");
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
rois=getFileList(dir+"/Rois");
files=lengthOf(rois);
for (b=0;b<files;b++)
{
	roiManager("Open", dir+"/Rois/"+rois[b]);
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
			if (Roi.contains(x_pos[d], y_pos[d])==1 && getSliceNumber==frame[d])
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
saveAs("Results", dir+substring(original,0,lengthOf(original)-4)+".xls");
selectWindow("Results");run("Close");
