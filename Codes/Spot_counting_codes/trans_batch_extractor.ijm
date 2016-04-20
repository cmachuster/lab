//get origin file names
origin=getDirectory("Origin Folder");
orifiles=getFileList(origin);
files=lengthOf(orifiles);
destination=getDirectory("Where to Save");
frame=getString("Which Slice to extract ?",8);

for (b=0;b<files;b++)
{
		open(origin+orifiles[b]);
		n=nSlices();
		title=getTitle();
		size=lengthOf(title);
		pos=substring(title, size-5, size-4);
		name=substring(title, 0, size-4);
		
		run("Grays");
		setSlice(frame);
		run("Duplicate...", " ");
		selectWindow(title);
		close();
		saveAs("Tiff", destination+title);
		close();		
}