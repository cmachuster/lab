dir=getDirectory("parent folder");
roi_dir=dir+"/cells/";
nuc_dir=dir+"/nuclei/";
fluo_dir=dir+"/YFP_mid/";
fluofiles=getFileList(fluo_dir);
roifiles=getFileList(roi_dir);
nucfiles=getFileList(nuc_dir);
run("Set Measurements...", "mean center integrated redirect=None decimal=3");
run("Colors...", "foreground=black background=black selection=yellow");





for (a=0;a<lengthOf(roifiles);a++)
{
	open(fluo_dir+fluofiles[a]);
	run("Properties...", "channels=1 slices=1 frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
	roiManager("Open", nuc_dir+nucfiles[a]);
	roiManager("Measure");
	r=nResults();
	x_nuc=newArray(r);
	y_nuc=newArray(r);
	nuc_int=newArray(r);
	cyto_int=newArray(r);
	for (b=0;b<r;b++)
	{
		x_nuc[b]=getResult("XM",b);
		y_nuc[b]=getResult("YM",b);
		nuc_int[b]=getResult("Mean",b);
	}
	roiManager("Fill");
	selectWindow("Results");run("Close");
	selectWindow("ROI Manager");run("Close");
	roiManager("Open", roi_dir+roifiles[a]);
	roi=roiManager("count");
	to_keep=newArray(roi);
	Array.fill(to_keep,100000);
	counter=0;
	for (c=0;c<roi;c++)
	{
		
		roiManager("Select", c);
		
		for (d=0;d<r;d++)
		{
			if (Roi.contains(x_nuc[d], y_nuc[d])==1)
			{
				
				to_keep[counter]=c;
				counter++;
			}
			
		}
		
	}
	///removing duplicates
	for (e=1;e<roi;e++) {if (to_keep[e]==to_keep[e-1]){counter=counter-1; to_keep[e]=10000000;}} 
	Array.sort(to_keep);
	to_keep2=Array.trim(to_keep, counter);
	Array.print(to_keep2);
	roiManager("Select", to_keep2);
	roiManager("Save Selected", roi_dir+roifiles[a]);
	selectWindow("ROI Manager");run("Close");
	
	close();
}

