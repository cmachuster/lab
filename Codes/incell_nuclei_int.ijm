dir=getDirectory("parent folder");
roi_dir=dir+"/cells/";
nuc_dir=dir+"/nuclei/";
fluo_dir=dir+"/YFP_mid/";
fluofiles=getFileList(fluo_dir);
roifiles=getFileList(roi_dir);
nucfiles=getFileList(nuc_dir);
run("Set Measurements...", "mean center integrated redirect=None decimal=3");
run("Colors...", "foreground=black background=black selection=yellow");
max=0;




for (a=0;a<lengthOf(roifiles);a++)
{
	open(fluo_dir+fluofiles[a]);
	fluo=getTitle();
	run("Properties...", "channels=1 slices=1 frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
	roiManager("Open", nuc_dir+nucfiles[a]);
	run("Select None");
	roiManager("Measure");
	r=nResults();
	x_nuc=newArray(300);
	y_nuc=newArray(300);
	nuc=newArray(300);Array.fill(nuc,-100);
	
	for (b=0;b<r;b++)
	{
		x_nuc[b]=getResult("XM",b);
		y_nuc[b]=getResult("YM",b);
		nuc[b]=getResult("Mean",b);
	}
	selectWindow("Results");run("Close");
	selectWindow(fluo);
	roiManager("Fill");
	selectWindow("ROI Manager");run("Close");
	roiManager("Open", roi_dir+roifiles[a]);
	roiManager("Measure");
	roi=nResults();
	cyto_int=newArray(300);Array.fill(cyto_int,-100);
	for (z=0;z<roi;z++) {cyto_int[z]=getResult("Mean",z);}
	selectWindow("Results");run("Close");
	counter=0;
	for (c=0;c<roi;c++)
	{
		
		roiManager("Select", c);
		for (d=0;d<r;d++)
		{
			if (Roi.contains(x_nuc[d], y_nuc[d])==1)
			{
				List.set("nuc_"+a+"_"+counter, nuc[d]);
				List.set("cyto_"+a+"_"+counter, cyto_int[c]);
				counter++;				
			}
				
		}
	}
	close();
	selectWindow("ROI Manager");run("Close");
	if (counter>max) {max=counter;}
}

//List.getList;
//Display the table


filling=newArray(max);
Array.show("Results",filling);Array.fill(filling,-100);
for (h=0;h<max;h++)
{
	for (m=0;m<lengthOf(fluofiles);m++)
	{
		if (List.get("nuc_"+m+"_"+h)!=""){
		setResult("nuc_"+fluofiles[m],h,List.getValue("nuc_"+m+"_"+h));}
		if (List.get("cyto_"+m+"_"+h)!=""){
		setResult("cyto_"+fluofiles[m],h,List.getValue("cyto_"+m+"_"+h));}
	}
}
updateResults()
saveAs("Results", dir+"cell_intensities.xls");
selectWindow("Results");run("Close");