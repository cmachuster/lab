ref=getSliceNumber();
dir=getDirectory("image");
dir_roi=dir+"/Rois/";
files=getFileList(dir_roi);
original=getTitle();
n=nSlices()
run("Properties...", "channels=1 slices=1 frames="+n+" unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1 frame=[50.57 sec]");
run("Set Measurements...", "center stack redirect=None decimal=3");
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
roiManager("Open", dir+substring(original,0,lengthOf(original)-4)+".zip");
roi=roiManager("count");

roiManager("deselect");
roiManager("Measure");

r=nResults();
XM=newArray(r);
YM=newArray(r);
FR=newArray(r);


for (e=0;e<r;e++)
{
	XM[e]=getResult("XM",e);
	YM[e]=getResult("YM",e);
	FR[e]=getResult("Slice",e);
}
if (isOpen("Results")==true)
{selectWindow("Results");run("Close");}






track=newArray(n);
Array.fill(track,1000000);
////Getting roi from clicked regions
for (b=0;b<roi;b++)
{
	roiManager("Select", b);
	for (c=0;c<points;c++)
	{
		if (Roi.contains(x_pos[c], y_pos[c])==1 && getSliceNumber==frame[c])
		{
			pos=frame[c]-1;
			track[pos]=b;
			last=b;
			
		}
	}
}
///Extrapolating rois from clicked regions

xref=XM[last];
yref=YM[last];
tref=FR[last];

for (j=0;j<r;j++)
{
	xpos=XM[j];ypos=YM[j];
	int=(xref-xpos)*(xref-xpos)+(yref-ypos)*(yref-ypos);
	dist=sqrt(int);
	if (dist<10 && dist!=0 && FR[j]==tref+1)
	{
		track[pos+1]=j;
		pos++;
		last=j;
		xref=XM[last];
		yref=YM[last];
		tref=FR[last];
	}
}
//trim the track array
Array.sort(track);
for (w=n-1;w>=0;w--)
{
	if (track[w]==1000000)
	{
		track=Array.trim(track, w);
	}
}


roiManager("Select", track);

roiManager("Save Selected", dir_roi+"cell_"+test+1+".zip");
selectWindow("ROI Manager");run("Close");

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