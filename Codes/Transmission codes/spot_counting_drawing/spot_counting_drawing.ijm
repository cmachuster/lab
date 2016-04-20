n=nSlices();
run("Properties...", "channels=1 slices="+n+" frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
r=roiManager("count");
title=getTitle();
results=newArray(r);
frame=newArray(r);

for (a=0;a<r;a++)
{
	setBatchMode(true);
	selectWindow(title);
	roiManager("Select", a);
	frame[a]=getSliceNumber();
	run("Duplicate...", " ");run("Clear Outside");run("Select None");
	run("Invert");
	run("Analyze Particles...", "display exclude clear");
	spot_number=nResults();
	
	results[a]=spot_number;
	//close();
}
selectWindow("ROI Manager");
run("Close");
Array.show("Results",frame,results);
setBatchMode(false);
close();
////////////////////////////////////////////////////////////////////////////////////////////////////
q=nResults();
time=newArray(20);
spot=newArray(20);
Array.fill(time, -1);
Array.fill(spot, -1);
newImage("Untitled", "16-bit white", 1100, 200, 1);
xstart=50;
ystart=100;
multiplier=4;


//fill result arrays

for (p=0;p<q;p++)
{
	if (getResult("frame",p)>0)
	{
		slice=getResult("frame",p);
		time[slice-1]=slice;
		spot[slice-1]=getResult("results",p);
	}
}

//start drawing spot lines
shift=0;
for(w=0;w<20;w++)
{
	if (time[w]>0)
	{
		value=spot[w];
		run("Colors...", "foreground=black background=black selection=yellow");
		makeLine(xstart+shift, ystart, xstart+shift+50, ystart,multiplier*value);
		run("Clear", "slice");
		shift=shift+50;
	}
	else
	{
		value=spot[w];
		run("Colors...", "foreground=white background=white selection=yellow");
		makeLine(xstart+shift, ystart, xstart+shift+50, ystart,multiplier*value);
		run("Clear", "slice");
		shift=shift+50;
	}	
}
run("Select None");

//draw frame marquers
shift=0;
height=10;
run("Colors...", "foreground=black background=black selection=yellow");
for (v=0;v<=20;v++)
{
	makeLine(xstart+shift,ystart,xstart+shift,ystart-height,1);
	run("Clear", "slice");
	shift=shift+50;
}
run("Select None");
//add frame number
num=newArray(20);
for (x=0;x<20;x++)
{
	num[x]=x+1;
}

x_text_start=70;
y_text_start=85;
setForegroundColor(0, 0, 0);
setFont("SansSerif", 10, " antialiased");
setColor("black");
shift=0;
for (aa=0;aa<20;aa++)
{
	drawString(num[aa], x_text_start+shift, y_text_start);
	shift=shift+50;
}

selectWindow("Results");
run("Close");