roi_dir=getDirectory("ROIS");
//im=getDirectory("image");
//roi_dir=im+"phase/Rois/";
//roi_dir=getDirectory("ROI folder ?");
roi_files=getFileList(roi_dir);
files=lengthOf(roi_files);
n=nSlices();
run("Properties...", "channels=1 slices="+n+" frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
title=getTitle();

color=newArray("White","Red","Green","Blue","Cyan","Magenta","Yellow");
contour=newArray(files);
mm=0;
for (kk=0;kk<files;kk++)
{
	if (mm==7) {mm=0;}
	contour[kk]=color[mm];
	mm++;
}


run("RGB Color");

//Fill the list with spot quantities

	for (zz=0;zz<files;zz++)
	{
		roiManager("Open", roi_dir+roi_files[zz]);
		name=roi_files[zz];
		size=lengthOf(name);
		name=substring(name,5,size-4);
		r=roiManager("count");	
		
		for (a=0;a<r;a++)
		{		
			
				run("Colors...", "foreground="+contour[zz]+" background=white selection=yellow");
				selectWindow(title);
				roiManager("Select", a);
				run("Measure");
				x=getResult("XM",0);
				y=getResult("YM",0);
				run("Draw", "slice");
				setFont("Serif", 12, "antiliased");
				drawString(name, x, y);
				selectWindow("Results");run("Close");
				
		
		//close();
		}	
selectWindow("ROI Manager");run("Close");
	}
