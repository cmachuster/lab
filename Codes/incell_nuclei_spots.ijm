dir=getDirectory("parent folder");
roi_dir=dir+"/cells/";
nuc_dir=dir+"/nuclei/";
fluo_dir=dir+"/Fluo2/save/";
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
	spot=newArray(300);Array.fill(spot,-100);
	for (b=0;b<r;b++)
	{
		x_nuc[b]=getResult("XM",b);
		y_nuc[b]=getResult("YM",b);
	}
	if (isOpen("Results")==true) {selectWindow("Results");run("Close");}
	count=0;
	for (g=0;g<r;g++)
	{
		roiManager("Select", g);
		run("Duplicate...", " ");run("Clear Outside");run("Select None");
		run("Invert");
		run("Analyze Particles...", "display exclude clear");
		spot[count]=nResults();
		count=count+1;
		close();	
	}
	if (isOpen("Results")==true) {selectWindow("Results");run("Close");}	
	selectWindow(fluo);
	selectWindow("ROI Manager");run("Close");
	roiManager("Open", roi_dir+roifiles[a]);
	roi=roiManager("count");
	if (isOpen("Results")==true) {selectWindow("Results");run("Close");}
	counter=0;
	for (c=0;c<roi;c++)
	{		
		roiManager("Select", c);
		for (d=0;d<r;d++)
		{
			if (Roi.contains(x_nuc[d], y_nuc[d])==1)
			{
				List.set("coloc_"+a+"_"+counter, spot[d]);
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
		setResult("coloc_"+fluofiles[m],h,-100);
		if (List.get("coloc_"+m+"_"+h)!=""){
		setResult("coloc_"+fluofiles[m],h,List.getValue("coloc_"+m+"_"+h));}
	}
}
updateResults();
saveAs("Results", dir+"nuclei_CFP.xls");
if (isOpen("Results")==true) {selectWindow("Results");run("Close");}