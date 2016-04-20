//get origin file names
origin=getDirectory("Origin Folder");
orifiles=getFileList(origin);
files=lengthOf(orifiles);

//detect files with specific suffixes
ends=newArray(files);
for (a=0;a<files;a++)
{
	suffix=endsWith(orifiles[a],"YFP.tif");
	if (suffix==1)
	{
		ends[a]=1;
	}
}
dir=getDirectory("Where to Save");
for (b=0;b<files;b++)
{
	if (ends[b]==1)
	{
		open(""+origin+""+orifiles[b]+"");
		title=getTitle();
		size=lengthOf(title);
		pos=substring(title, size-5, size-4);
		name=substring(title, 0, size-4);
	
		run("Grays");
		run("Z Project...", "all");
		max=getTitle();
		selectWindow(title);
		close();
		run("Save", "save="+dir+""+name+"-max.tif");
		close();	
	}
}