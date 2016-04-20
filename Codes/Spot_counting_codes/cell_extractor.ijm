origin=getDirectory("Origin Folder");
orifiles=getFileList(origin);
files=lengthOf(orifiles);
destination=getDirectory("Where to Save");



for (z=0;z<files;z++)
{
	open(origin+orifiles[z]);
	title=getTitle();
	size=lengthOf(title);
	pos=substring(title, size-5, size-4);	
	name=substring(title, 0, size-4);

	//Phantasting
	run("32-bit");
	run("PHANTAST", "sigma=1.20 epsilon=0.03 do new");
	run("Invert");
	mask=getTitle();
	//run("Analyze Particles...", "size=500-Infinity circularity=0.20-1.00 exclude clear include add");
	run("Analyze Particles...", "size=500-Infinity exclude clear include add");
	//cleaning holes
	n=roiManager("count");
	ROI=newArray(n);
	run("Colors...", "foreground=white background=black selection=yellow");
	//filling ROI array
	for (a=0;a<n;a++)
	{
		ROI[a]=a;
	}
	for (b=0;b<n;b++)
	{
		roiManager("Select", ROI[b]);
		run("Clear", "slice");
	}
	roiManager("Show None");run("Select None");
	run("Watershed");
	run("Analyze Particles...", "size=800-Infinity exclude clear include add");
	selectWindow(mask);close();
	n1=roiManager("count");
	ROI1=newArray(n1);
	//filling ROI array
	for (a=0;a<n1;a++)
	{
		ROI1[a]=a;
	}
	//Saving ROIs
if (lengthOf(ROI1)==0)
{
	makeRectangle(0, 0, 1, 1);
	roiManager("Add");
	makeRectangle(0, 0, 1, 2);
	roiManager("Add");
	roiManager("Select", newArray(0,1));
	roiManager("Save", destination+name+"_empty.zip");
	selectWindow(title);close();
	selectWindow("ROI Manager");run("Close");
}
else
{
	roiManager("Select", ROI1);
	roiManager("Save", destination+name+".zip");
selectWindow(title);close();
selectWindow("ROI Manager");run("Close");
}
}