//get origin binaries file names
oribin1=getDirectory("Binaries Folder for Fluo 1");
orifibin1=getFileList(oribin1);
binfiles1=lengthOf(orifibin1);
oribin2=getDirectory("Binaries Folder for Fluo 2");
orifibin2=getFileList(oribin2);
binfiles2=lengthOf(orifibin2);

//get origin phase file names
oripha=getDirectory("Phase Folder");
orifipha=getFileList(oripha);

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

// Open Files from folder and detect

for (c=0;c<binfiles1;c++)
{
	if (endbin1[c]==1)
	{
	open(""+oribin1+""+orifibin1[c]+"");
	bincfp=getTitle;
	open(""+oribin2+""+orifibin2[c]+"");
	binyfp=getTitle;
	n=nSlices();
	run("Properties...", "channels=1 slices="+n+" frames=1 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1");
	run("Set Measurements...", "center redirect=None decimal=3");
	run("Invert", "stack");

//Detect Region in binaries 1
	selectWindow(bincfp);
	run("Analyze Particles...", "pixel show=Nothing exclude clear add stack");
	n1=nResults();
	X1_centroid=newArray(n1);
	Y1_centroid=newArray(n1);
	frame1=newArray(n1);
//Save Mass Center in Arrays for binaries 1
	for (r=0;r<=n1-1;r++)
		{
			X1_centroid[r]=getResultString("XM", r);
			Y1_centroid[r]=getResultString("YM", r);
			roiManager("select", r);
			frame1[r]=getSliceNumber();
		}

//Detect Region in binaries 2
	selectWindow(binyfp);
	run("Analyze Particles...", "pixel show=Nothing exclude clear add stack");
	n2=nResults();
	X2_centroid=newArray(n2);
	Y2_centroid=newArray(n2);
	frame2=newArray(n2);
//Save Mass Center in Arrays for binaries 1
	for (r=0;r<=n2-1;r++)
		{
			X2_centroid[r]=getResultString("XM", r);
			Y2_centroid[r]=getResultString("YM", r);
			roiManager("select", r);
			frame2[r]=getSliceNumber();
		}

//Detect Colocalisation
	distances=newArray(n1*n2);
	for (a=0;a<n1;a++)
	{
		for (b=0;b<n2;b++)
		{
			xdif=X1_centroid[a]-X2_centroid[b];
			ydif=Y1_centroid[a]-Y2_centroid[b];
			sqdist=(xdif*xdif)+(ydif*ydif);
			distances[a+b]=sqrt(sqdist);
			
		}
	}





}