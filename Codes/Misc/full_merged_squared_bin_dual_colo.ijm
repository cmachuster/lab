//get origin binaries file names
oribin1=getDirectory("Binaries Folder for Fluo 1");
orifibin1=getFileList(oribin1);
binfiles1=lengthOf(orifibin1);
oribin2=getDirectory("Binaries Folder for Fluo 2");
orifibin2=getFileList(oribin2);
binfiles2=lengthOf(orifibin2);

//detect binaries files with specific suffixes + save position
endbin1=newArray(binfiles1);

for (a=0;a<binfiles1;a++)
{
	suffix=endsWith(orifibin1[a],"roi.binary.tif");
	suffixpos=endsWith(orifibin1[a],"roi.binary.tif");
	if (suffix==1)
	{
		endbin1[a]=1;
	}
}


//get origin phase file names
oripha=getDirectory("Phase Folder");
orifipha=getFileList(oripha);

//Destination folder
dir=getDirectory("Where to Save");

// Open Files from folder and merge

for (c=0;c<binfiles1;c++)
{
	if (endbin1[c]==1)
	{
	//Fluo 1 mass center detection and drawing
	open(""+oribin1+""+orifibin1[c]+"");
	test1=getTitle();
	size1=lengthOf(test1);
	name1=substring(test1, 0, size1-19);
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
	selectWindow(test1);
	run("Colors...", "foreground=green background=green selection=yellow");
	run("Red");
	run("RGB Color");
	for (e=0;e<r;e++)
	{
		setSlice(frame1[e]);
		drawRect(xmass1[e]-3, ymass1[e]-3, 7, 7);
	}
	
	//Fluo 2 mass center detection and drawing
	open(""+oribin2+""+orifibin2[c]+"");
	test2=getTitle();
	size2=lengthOf(test2);
	name2=substring(test2, 0, size2-19);
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
	xmass2=newArray(r);
	ymass2=newArray(r);
	frame2=newArray(r);
	roiManager("Select",roi);
	roiManager("Measure");
	for (b=0;b<r;b++)
	{
		roiManager("Select",roi[b]);
		xmass2[b]=getResult("XM", b);
		ymass2[b]=getResult("YM", b);
		frame2[b]=getSliceNumber();
	}
	close();
	selectWindow("ROI Manager");
	run("Close");
	selectWindow("Results");
	run("Close");
	selectWindow(test2);
	run("Colors...", "foreground=green background=green selection=yellow");
	run("Green");
	run("RGB Color");
	for (e=0;e<r;e++)
	{
		setSlice(frame1[e]);
		drawRect(xmass1[e]-3, ymass1[e]-3, 7, 7);
	}
	
//Open Phase Image
	namephase=name1+"phase.tif";
	open(""+oripha+""+orifipha[c]+"");
	run("Grays");
	run("RGB Color");
	imagepha=getTitle();
//Merge Images
	
	imageCalculator("Add create stack", test1,test2);
	merge=getTitle();
	selectWindow(test1);close();
	selectWindow(test2);close();
	imageCalculator("Add create stack", merge,imagepha);
	selectWindow(merge);close();
	selectWindow(imagepha);close();
	run("Save", "save="+dir+""+name1+"mergedspot.tif");
	close();

	
	
	}

}

