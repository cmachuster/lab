dir=getDirectory("CFP Folder ?");
files=getFileList(dir);
par=File.getParent(dir);

cell_dir=par+"/nuclei/";
File.makeDirectory(cell_dir);

for (a=0;a<lengthOf(dir)-1;a++)
{
	open(dir+files[a]);
	im=getTitle();
	run("Duplicate...", " ");
	dup=getTitle();
	run("Subtract Background...", "rolling=50");
	run("Smooth");
	setAutoThreshold("Otsu dark");
	run("Convert to Mask");
	run("Watershed");
	run("Analyze Particles...", "size=1.36-Infinity circularity=0.10-1.00 exclude clear include add");
	count=roiManager("count");
	to_save=newArray(count);
	for (b=0;b<count;b++) {to_save[b]=b;}
	roiManager("select", to_save);
	roiManager("Save", cell_dir+substring(files[a], 0, lengthOf(files[a])-4)+".zip");
	selectWindow("ROI Manager");run("Close");
	close();
	close();
}
