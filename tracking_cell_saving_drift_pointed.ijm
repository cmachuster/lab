//Dialog.create("Drift Correction");
//Dialog.addString("reference ROIs ?", "0.10.19.28");
//Dialog.show();
//drift=Dialog.getString();
original=getTitle();
sl=nSlices();
run("Set Measurements...", "center stack redirect=None decimal=3");
run("Properties...", "channels=1 slices=1 frames="+sl+" unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1 frame=[50.37 sec]");
dia=45;
dir=getDirectory("image");
dir_save=dir+"/Rois/";
File.makeDirectory(dir_save);
///Dealing with the drift ///////////
points=roiManager("count");
x_pos=newArray(points);
y_pos=newArray(points);
frame=newArray(points);
roi_drift=newArray(sl);
x_drift=newArray(sl);
y_drift=newArray(sl);
drift2=newArray(points);
roi_drift=newArray(sl);

//drift per frame
///points coordinates
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

///// corresponding ROIs
roi=roiManager("count");
counter=0;
for (w=0;w<roi;w++)
{
	for (c=0;c<points;c++)
	{
		roiManager("Select", w);
		if (Roi.contains(x_pos[c], y_pos[c])==1 && getSliceNumber==frame[c])
		{
			drift2[counter]=w;
			counter++;
		}
	}
}

//calculating drift

for (jj=1;jj<lengthOf(drift2);jj++)
{
	roiManager("Select", drift2[jj-1]);roiManager("Measure");
	x_drift_ref=getResult("XM");
	y_drift_ref=getResult("YM");
	if (isOpen("Results")==true)
	{selectWindow("Results");run("Close");}
	roiManager("Select", drift2[jj]);roiManager("Measure");
	x_drift2=getResult("XM");
	y_drift2=getResult("YM");
	if (isOpen("Results")==true)
	{selectWindow("Results");run("Close");}
	x_drift[jj-1]=x_drift2-x_drift_ref;
	y_drift[jj-1]=y_drift2-y_drift_ref;
	
	
}


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

//// How many cells at each frame
Array.getStatistics(FR, min, max, mean, stdDev);
max_slide=max;
if (max>=0) {cell_per_frame=newArray(max_slide);}
for (q=0;q<r;q++)
{
	for (qq=1;qq<=max_slide;qq++)
	{
		if (FR[q]==qq) 
		{
			cell_per_frame[qq-1]=cell_per_frame[qq-1]+1;
		}
	}
}
Array.getStatistics(cell_per_frame, min, max, mean, stdDev);
max_cell=max;

///// Measuring distances between cells to track
prev=2000;
for (t=0;t<r;t++)
{
	for (tt=1;tt<=max_slide;tt++)
	{
		if (FR[t]==tt) 
		{
			xref=XM[t]+x_drift[tt-1];yref=YM[t]+y_drift[tt-1];
			for (u=t+1;u<r;u++)
			{
				if (FR[u]==tt+1)
				{
					xpos=XM[u];ypos=YM[u];
					int=(xref-xpos)*(xref-xpos)+(yref-ypos)*(yref-ypos);
					dist=sqrt(int);
					if (dist<dia/2 && dist<prev)
					{
						track=u;
						dist=prev;
						List.set(t,track); 
					}
					//else {track="";List.set(t,track);}
				 
				}
				
			}
		}
	}
}

//List.getList;
//// linking pairs from the list
for (count=0;count<10000;count++)
{
ls=List.size;
test=newArray(max_slide);
Array.fill(test, 2000);

test[0]=count;

for (p=1;p<max_slide;p++)
{
	if (List.get(test[p-1])!="") {
	test[p]=List.get(test[p-1]);List.set(test[p-1],"");}
}
//List.clear();

/// trim the array
inc=0;
for (j=0;j<lengthOf(test);j++)
{
	if (test[j]==2000) {test=Array.trim(test,j);}
}


//Array.show(test);
if (lengthOf(test)>1){
roiManager("Select", test);
roiManager("Save Selected", dir_save+"cell_"+count+".zip");

//roiManager("Delete");
}

}
selectWindow("ROI Manager");run("Close");