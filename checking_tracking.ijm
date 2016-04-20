///////// Coloring tracked cells//////////
/// Red cells are the new ones /////


dir=getDirectory("image");
dir_roi=dir+"/Rois/";
run("RGB Color");
files=getFileList(dir_roi);
colors=newArray("Grays","Green","Blue","Cyan","Yellow","Magenta","White","Orange");
setBatchMode(true);
counter=0;
for (a=0;a<lengthOf(files);a++)
{
	roiManager("Open", dir_roi+files[a]);
	roiManager("Select", 0);
	run("Colors...", "foreground=red background=black selection=yellow");	
	run("Fill", "slice");
	cells=roiManager("count");
	run("Colors...", "foreground="+colors[counter]+" background=black selection=yellow");
	to_fill=newArray(cells-1);
	for (b=0;b<lengthOf(to_fill);b++){to_fill[b]=b+1;}
	roiManager("Select", to_fill);
	roiManager("Fill");
	to_delete=newArray(cells);
	for (b=0;b<lengthOf(to_delete);b++){to_delete[b]=b;}
	roiManager("Select", to_delete);
	roiManager("Delete");
	counter++;
	if (counter>=lengthOf(colors)) {counter=0;}
}
setSlice(1);