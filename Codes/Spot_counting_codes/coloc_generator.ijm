//get origin binaries file names
oribin1=getDirectory("Binaries Folder for Fluo 1");
orifibin1=getFileList(oribin1);
binfiles1=lengthOf(orifibin1);
oribin2=getDirectory("Binaries Folder for Fluo 2");
orifibin2=getFileList(oribin2);
binfiles2=lengthOf(orifibin2);

//Destination folder
dir=getDirectory("Where to Save");

for (a=0;a<binfiles1;a++)
{
	bin1=indexOf(orifibin1[a], "roi.binary.tif");
	bin2=indexOf(orifibin2[a], "roi.binary.tif");
	if (bin1>=0)
	{
		open(oribin1+orifibin1[a]);
		run("Erode");
		title1=getTitle();
		size=lengthOf(title1);
		name=substring(title1, 0, size-4);
		if (bin2>=0)
		{
			open(oribin2+orifibin2[a]);
			run("Erode");
			title2=getTitle();
		}	
	imageCalculator("AND create", title1,title2);
	coloc=getTitle();
	selectWindow(title1);close();
	selectWindow(title2);close();
	selectWindow(coloc);
	run("Save", "save="+dir+"coloc"+name+".tif");
	close();
	}
	
	
}
