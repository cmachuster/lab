//get origin binaries file names
oribin=getDirectory("Origin Folder");
orifibin=getFileList(oribin);
binfiles=lengthOf(orifibin);

// Open Files from folder and merge

for (c=0;c<binfiles;c++)
{
	
	open(""+oribin+""+orifibin[c]+"");
	test1=getTitle();
	size=lengthOf(test1);
	pos=substring(test1, size-5, size-4);
	name=substring(test1, 0, size-4);
	run("Bin...", "x=2 y=2 z=1 bin=Sum");
	run("Bio-Formats Exporter", "save="+oribin+name+".ome.tif compression=Uncompressed");
	close();
	
}

