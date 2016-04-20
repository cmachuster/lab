im=getDirectory("image");
roi_dir=im+"phase/Rois/";
//roi_dir=getDirectory("ROI folder ?");
roi_files=getFileList(roi_dir);
files=lengthOf(roi_files);
n=nSlices();
run("Properties...", "channels=1 slices="+n+" frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
title=getTitle();

frame=newArray(20);
for(z=0;z<20;z++)
{
	frame[z]=z+1;
}
//Make an empty list
for (v=0;v<files;v++)
{
	for (w=0;w<n;w++)
	{
		truc=roi_files[v];
		taille=lengthOf(truc);
		truc=substring(truc,0,taille-4);
		List.set(truc+"_frame_"+w+1, 0);
	}
}
//Fill the list with spot quantities
run("Set Measurements...", "area mean redirect=None decimal=3");
for (zz=0;zz<files;zz++)
{
	roiManager("Open", roi_dir+roi_files[zz]);
	name=roi_files[zz];
	size=lengthOf(name);
	name=substring(name,0,size-4);
	r=roiManager("count");
	for (a=0;a<r;a++)
	{		
		setBatchMode(true);
		selectWindow(title);
		roiManager("Select", a);
		slice=getSliceNumber();
		run("Measure");
		spot=getResult("Area",0);
		List.set(name+"_frame_"+slice, spot);
		selectWindow("Results");
		run("Close");
		
	}
	selectWindow("ROI Manager");
	run("Close");
	setBatchMode(false);
	
}

//Display the table
Array.show("Results",frame);
for (h=0;h<n;h++)
{
	for (m=0;m<files;m++)
	{
		image=h+1;
		Array.sort(roi_files);
		test=roi_files[m];
		siz=lengthOf(test);
		test=substring(test,0,siz-4);
		value=List.getValue(test+"_frame_"+image);
		setResult(test,h,value);
	}
}
updateResults()