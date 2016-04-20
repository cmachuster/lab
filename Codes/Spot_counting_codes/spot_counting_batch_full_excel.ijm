roi_dir=getDirectory("ROI Folder");
fluo_dir=getDirectory("Spot Folder");
fluofiles=getFileList(fluo_dir);
roifiles=getFileList(roi_dir);
files=lengthOf(roifiles);
//destination=getDirectory("Where to Save");
cellnum=newArray(files);
name=newArray(files);
count=0;
//setBatchMode(true);
run("Image Sequence...", "open="+fluo_dir+fluofiles[0]+" file=binary sort");
origin=getTitle();
for (b=0;b<files;b++)
{
	roiManager("Open", roi_dir+roifiles[b]);
	selectWindow(origin);
	name[b]=getInfo("slice.label");
	run("Duplicate...", " ");
	n=nSlices();
	run("Properties...", "channels=1 slices="+n+" frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
	r=roiManager("count");
	cellnum[b]=r;
	title=getTitle();
	
	roi=newArray(r);
	for (a=0;a<r;a++)
	{
		
		roi[a]=a;
		spot_number=0;
		selectWindow(title);
		roiManager("Select", a);
		run("Duplicate...", " ");run("Clear Outside");run("Select None");
		run("Invert");
		run("Analyze Particles...", "display exclude clear");
		spot_number=nResults();
		List.set(name[b]+"_"+a, spot_number);
		count=count+1;
		close();
	}
	
	roiManager("Select", roi);
	roiManager("Delete");
	selectWindow(origin);
	run("Next Slice [>]");
	
}
selectWindow("Results");run("Close");
for (m=0;m<files;m++)
{
	
	num=cellnum[m];
	Array.getStatistics(cellnum, min, max, mean, stdDev);
	
	for (j=0;j<max;j++)
	{
		setResult(name[m],j,"");
	}
	for (f=0;f<num;f++)
	{
		value=List.getValue(name[m]+"_"+f);
		setResult(name[m],f,value);
	}
}
close("\\Others");
close();
updateResults()
print(count+" cells counted");