//get origin binaries file names
oribin1=getDirectory("Binaries Folder for Fluo 1");
orifibin1=getFileList(oribin1);
binfiles1=lengthOf(orifibin1);
oribin2=getDirectory("Binaries Folder for Fluo 2");
orifibin2=getFileList(oribin2);
binfiles2=lengthOf(orifibin2);

//detect binaries files with specific suffixes + save position
endbin1=newArray(binfiles1);
endbin2=newArray(binfiles2);
for (a=0;a<binfiles1;a++)
{
	suffix=endsWith(orifibin1[a],"roi.binary.tif");
	suffixpos=endsWith(orifibin1[a],"roi.binary.tif");
	if (suffix==1)
	{
		endbin1[a]=1;
	}
}

for (b=0;b<binfiles2;b++)
{
	suffix=endsWith(orifibin2[b],"roi.binary.tif");
	suffixpos=endsWith(orifibin2[b],"roi.binary.tif");
	if (suffix==1)
	{
		endbin2[b]=1;
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
	setBatchMode(true);
	if (endbin1[c]==1)
	{
	open(""+oribin1+""+orifibin1[c]+"");
	test1=getTitle();
	size1=lengthOf(test1);
	name1=substring(test1, 0, size1-27);
	run("Red");
	run("RGB Color");
	open(""+oribin2+""+orifibin2[c]+"");
	test2=getTitle();
	size2=lengthOf(test2);
	name2=substring(test2, 0, size2-27);
	run("Green");
	run("RGB Color");

	namephase=name1+"phase.tif";
	open(""+oripha+""+namephase+"");
	run("Grays");
	resetMinAndMax();
	run("RGB Color");
	imagepha=getTitle();
	imageCalculator("Add create stack", test1,test2);
	dualbin=getTitle();
	imageCalculator("Add create stack", dualbin,imagepha);
	run("Save", "save="+dir+""+name1+"mergedspot.tif");
	selectWindow(imagepha);
	setBatchMode(false);
	close();
	
	}

}
beep();
print("Images Merged !!!");