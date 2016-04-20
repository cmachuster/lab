//get origin binaries file names
oribin=getDirectory("Binaries Folder");
orifibin=getFileList(oribin);
binfiles=lengthOf(orifibin);

//detect binaries files with specific suffixes + save position
endbin=newArray(binfiles);

for (a=0;a<binfiles;a++)
{
	suffix=endsWith(orifibin[a],"roi.binary.tif");
	suffixpos=endsWith(orifibin[a],"roi.binary.tif");
	if (suffix==1)
	{
		endbin[a]=1;
	}
}

//get origin phase file names
oripha=getDirectory("Phase Folder");
orifipha=getFileList(oripha);

//Destination folder
dir=getDirectory("Where to Save");

// Open Files from folder and merge

for (c=0;c<binfiles;c++)
{
	if (endbin[c]==1)
	{
	open(""+oribin+""+orifibin[c]+"");
	test=getTitle();
	size=lengthOf(test);
	name=substring(test, 0, size-27);
	run("Red");
	run("RGB Color");

	namephase=name+"phase.tif";
	open(""+oripha+""+namephase+"");
	run("Grays");
	run("RGB Color");
	imagepha=getTitle();
	imageCalculator("Add create stack", test,imagepha);
	run("Save", "save="+dir+""+name+"-mergedspot.tif");
	close();
	selectWindow(test);
	close();
	selectWindow(imagepha);
	close();
	
	}

}

