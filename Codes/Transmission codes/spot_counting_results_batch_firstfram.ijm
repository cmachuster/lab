im=getDirectory("image");
segment_dir=im+"phase/segments/";
roi_dir=im+"phase/Rois/";
//roi_dir=getDirectory("ROI folder ?");
roi_files=getFileList(roi_dir);
files=lengthOf(roi_files);
segment_files=getFileList(segment_dir);
first=getTitle();
//setSlice(5);
run("Duplicate...", "duplicate frames=5");
test=getTitle();
run("Z Project...", "projection=[Max Intensity]");
selectWindow(first);close();
selectWindow(test);close();
spots=getTitle();


run("Properties...", "channels=1 slices=1 frames=1 unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1");

run("Image Sequence...", "open="+segment_dir+""+segment_files[4]+" number=1 file=0005_segments sort");
title=getTitle();

//extract ROI from segmented file
run("Split Channels");
imageCalculator("OR create stack", ""+title+" (red)",""+title+" (green)");
merge=getTitle();
selectWindow(title+" (red)");
close()
selectWindow(title+" (blue)");
close()
selectWindow(title+" (green)");
close()
selectWindow(merge);
setAutoThreshold("Otsu");

setOption("BlackBackground", false);
run("Convert to Mask", "method=Otsu background=Light calculate");
run("Invert", "stack");
run("Erode", "stack");
run("Duplicate...", " ");
run("Analyze Particles...", "size=50-Infinity exclude clear add stack");

close(); close();


//Fill the list with spot quantities

selectWindow(spots);
r=roiManager("count");
count=newArray(r);
for (a=0;a<r;a++)
{
	roiManager("Select", a);
	
	run("Duplicate...", " ");run("Clear Outside");run("Select None");
	run("Invert");
	run("Analyze Particles...", "display exclude clear");
	close();
	count[a]=nResults();
}
	Array.show(count);
	selectWindow("ROI Manager");
	run("Close");
	selectWindow("Results");
	run("Close");
	close();


