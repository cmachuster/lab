//get origin file names
origin=getDirectory("Origin Folder");
orifiles=getFileList(origin);
files=lengthOf(orifiles);
destination=getDirectory("Where to Save");

for (b=0;b<files;b++)
{
		open(origin+orifiles[b]);
		n=nSlices();
		title=getTitle();
		size=lengthOf(title);
		pos=substring(title, size-5, size-4);
		name=substring(title, 0, size-4);
		
		run("Grays");
		run("Z Project...", "projection=[Max Intensity] all");
		max=getTitle();
		selectWindow(title);
		close();
		saveAs("Tiff", destination+title);
		close();		
}