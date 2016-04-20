dir=getDirectory("parent folder");

nuc_dir=dir+"/nuclei/";
fluo_dir=dir+"/coloc/";
fluofiles=getFileList(fluo_dir);

nucfiles=getFileList(nuc_dir);
run("Set Measurements...", "mean center integrated redirect=None decimal=3");
run("Colors...", "foreground=black background=black selection=yellow");
max=0;



//getting nuclei positions
for (a=0;a<lengthOf(fluofiles);a++)
{
	open(fluo_dir+fluofiles[a]);
	fluo=getTitle();
	counter=0;
	run("Properties...", "channels=1 slices=1 frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
	roiManager("Open", nuc_dir+nucfiles[a]);
	run("Select None");
	roiManager("Measure");
	r=nResults();
	x_nuc=newArray(600);
	y_nuc=newArray(600);
	nuc=newArray(600);Array.fill(nuc,-100);
	
	for (b=0;b<r;b++)
	{
		x_nuc[b]=getResult("XM",b);
		y_nuc[b]=getResult("YM",b);		
	}
	selectWindow("Results");run("Close");
	for (q=0;q<r;q++)
	{
		roiManager("Select", q);
		run("Duplicate...", " ");run("Clear Outside");run("Select None");
		run("Invert");
		run("Analyze Particles...", "display exclude clear");
		nuc[q]=nResults();
		if (isOpen("Results")==true){
		selectWindow("Results");run("Close");}
		close();
		List.set("nuc_"+a+"_"+counter, nuc[q]);
		counter++;
	}
	
	close();
	selectWindow("ROI Manager");run("Close");
	if (counter>max) {max=counter;}
}

//List.getList;
//Display the table


filling=newArray(max);
//Array.show("Results",filling);Array.fill(filling,-100);
for (h=0;h<max;h++)
{
	for (m=0;m<lengthOf(fluofiles);m++)
	{
		if (List.get("nuc_"+m+"_"+h)!=""){
		setResult("nuc_"+fluofiles[m],h,List.getValue("nuc_"+m+"_"+h));}
		else {setResult("nuc_"+fluofiles[m],h,-100);}
		
	}
}
updateResults()
saveAs("Results", dir+"coloc_cell_nuc_spots.xls");
selectWindow("Results");run("Close");