//get origin binaries file names
oribin=getDirectory("Binaries Folder");
orifibin=getFileList(oribin);
binfiles=lengthOf(orifibin);
//detect binaries files with specific suffixes
endbin=newArray(binfiles);
for (a=0;a<binfiles;a++)
{
	suffix=endsWith(orifibin[a],"roi.binary.tif");
	if (suffix==1)
	{
		endbin[a]=1;
	}
}
//count position in binaries folder
size=0
for (ar=0;ar<=binfiles;ar++)
{
	suffix=endsWith(orifibin[a],"roi.binary.tif");
	if (suffix==1)
	{
		size++;
	}
}

//get origin phase file names
oripha=getDirectory("Phase Folder");
orifipha=getFileList(oripha);
phafiles=lengthOf(orifipha);
//detect phase files with specific suffixes
endphase=newArray(phafiles);
for (b=0;b<phafiles;b++)
{
	suffix=endsWith(orifipha[b],"-phase.tif");
	if (suffix==1)
	{
		endphase[b]=1;
	}
}

//Destination folder
//dir=getDirectory("Where to Save");

//Which origin directory is the biigest ?
if (phafiles>=binfiles)
{
	files=phafiles;
}
if (phafiles<=binfiles)
{
	files=binfiles;
}
// Open Files from folder and merge

for (c=0;c<files;c++)
{
	if (endbin[c]==1)
	{
		open(""+oribin+""+orifibin[c]+"");
		posbin=substring(orifibin[c], size-5, size-4);
		run("Red");
		run("RGB Color");
		for (d=0;d<=phafiles;d++)
		{
		posphase=substring(orifipha[d], size-5, size-4);
		if (posphase==posbin)
		{
			open(""+oripha+""+orifipha[c]+"");
			run("Grays");
			run("RGB Color");
		}
		}
	
	imageCalculator("Add create stack", orifibin[c],orifipha[c]);
	}

}

