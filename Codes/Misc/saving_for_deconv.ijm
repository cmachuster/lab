dir_ori=getDirectory("Origin Directory");
orifi=getFileList(dir_ori);
files=lengthOf(orifi);
for (a=0;a<files;a++)
{
	open(""+dir_ori+""+orifi[a]+"");
	n=nSlices();
	title=getTitle();
	size=lengthOf(title);
	name=substring(title, 0, size-4);

	
	dir="C:\\Users\\machu\\Desktop\\test\\";

	run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=9 frames="+n/9+" display=Grayscale");
	run("Bio-Formats Exporter", "save="+dir+""+name+".ome.tif compression=Uncompressed");
	
	close();
}