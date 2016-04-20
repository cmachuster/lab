bin=getTitle();
n=nSlices();
run("Set Measurements...", "center redirect=None decimal=3");
run("Properties...", "channels=1 slices="+n+" frames=1 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1");


run("Duplicate...", "duplicate");

run("Invert", "stack");
run("Analyze Particles...", "pixel exclude clear add stack");
r=roiManager("count");
roi=newArray(r);
for (a=0;a<r;a++)
{
	roi[a]=a;
}


xmass1=newArray(r);
ymass1=newArray(r);
frame1=newArray(r);


roiManager("Select",roi);
roiManager("Measure");

for (b=0;b<r;b++)
{
	roiManager("Select",roi[b]);
	xmass1[b]=getResult("XM", b);
	ymass1[b]=getResult("YM", b);
	frame1[b]=getSliceNumber();
}

close();
selectWindow("ROI Manager");
run("Close");
selectWindow("Results");
run("Close");

selectWindow(bin);

for (c=0;c<r;c++)
{
	setSlice(frame1[c]);
	drawRect(xmass1[c]-3, ymass1[c]-3, 7, 7);
}
