im=getDirectory("image");
getDimensions(width, height, channels, slices, frames);
roi_dir=im+"phase/Rois/";
//roi_dir=getDirectory("ROI folder ?");
roi_files=getFileList(roi_dir);
files=lengthOf(roi_files);
n=nSlices();
run("Properties...", "channels=1 slices="+slices+" frames="+frames+" unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
title=getTitle();


prout=newArray(frames);
for(z=0;z<frames;z++)
{
	prout[z]=z+1;
}
//Make a negative list
for (v=0;v<files;v++)
{
	for (w=0;w<n;w++)
	{
		truc=roi_files[v];
		taille=lengthOf(truc);
		truc=substring(truc,0,taille-4);
		List.set(truc+"_frame_"+w+1, -1);
	}
}
//Fill the list with spot quantities
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
		//spot=0;
		selectWindow(title);
		roiManager("Select", a);
		kk=getInfo("selection.name");
		name_roi=substring(kk,2,4);
		if(substring(name_roi,0,1)==0) {name_roi=substring(name_roi,1,2);}
		//Stack.getPosition(channel, slice, frame);
		//Stack.setPosition(channel, 1, name_roi);
		//run("Duplicate...", "duplicate frames="+name_roi);
		//run("Clear Outside", "stack");
		run("Select None");
		run("Invert", "stack");
		for (jj=1;jj<=slices;jj++)
		{
			setSlice(jj);
			run("Analyze Particles...", "display exclude clear stack");
			spot=nResults();
		}
		List.set(name+"_frame_"+name_roi, spot);
		
	}
	selectWindow("ROI Manager");
	run("Close");
	setBatchMode(false);
	close();
}

//Display the table
Array.show("Results",prout);
for (h=0;h<frames;h++)
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