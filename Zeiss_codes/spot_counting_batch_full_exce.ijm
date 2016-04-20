dir=getDirectory("parent folder");
roi_dir=dir+"/cells/";
fluo_dir=dir+"/YFP/save/";
fluofiles=getFileList(fluo_dir);
roifiles=getFileList(roi_dir);
files=lengthOf(roifiles);

analysis=dir+"/Analysis/";File.makeDirectory(analysis);



//destination=getDirectory("Where to Save");

count=0;
//setBatchMode(true);
run("Image Sequence...", "open=["+fluo_dir+fluofiles[0]+"] file=binary.tif sort");
origin=getTitle();
n=nSlices();
cellnum=newArray(n);
name=newArray(n);
for (b=0;b<n;b++)
{
	setSlice(b+1);
	test=getInfo("slice.label");
	test=substring(test,0,lengthOf(test)-18);
	test=test+"CFP";
	if (File.exists(roi_dir+test+".zip")==true){
	roiManager("Open", roi_dir+test+".zip");}
	selectWindow(origin);
	name[b]=getInfo("slice.label");
	run("Duplicate...", " ");
	run("Properties...", "channels=1 slices=1 frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
	r=roiManager("count");
	cellnum[b]=r;
	title=getTitle();
	
	roi=newArray(r);if(r>0){
	for (a=0;a<r;a++)
	{
		
		roi[a]=a;
		spot_number=0;
		selectWindow(title);
		roiManager("Select", a);
		run("Duplicate...", " ");run("Clear Outside");run("Select None");
		run("Invert");
		run("Analyze Particles...", "display exclude clear");
		spot_number=nResults();
		List.set(name[b]+"_"+a, spot_number);
		count=count+1;
		close();
	}
	
	roiManager("Select", roi);
	roiManager("Delete");}
	selectWindow(origin);
	run("Next Slice [>]");
	selectWindow("ROI Manager");run("Close");
}
if (isOpen("Results")==true){selectWindow("Results");run("Close");}
for (m=0;m<files;m++)
{
	
	num=cellnum[m];
	Array.getStatistics(cellnum, min, max, mean, stdDev);
	
	for (j=0;j<max;j++)
	{
		setResult(name[m],j,"-100");
	}
	for (f=0;f<num;f++)
	{
		value=List.getValue(name[m]+"_"+f);
		setResult(name[m],f,value);
	}
}
close("\\Others");
close();
updateResults();
//selectWindow("ROI Manager");run("Close");
if (isOpen("Results")==true){
	saveAs("Results", analysis+"YFP.xls");
	selectWindow("Results");run("Close");}
List.clear();

///////////////////////////////////////////////////////////////////////////////////////////////////

roi_dir=dir+"/cells/";
fluo_dir=dir+"/CFP/save/";
fluofiles=getFileList(fluo_dir);
roifiles=getFileList(roi_dir);
files=lengthOf(roifiles);
//destination=getDirectory("Where to Save");

count=0;
//setBatchMode(true);
run("Image Sequence...", "open=["+fluo_dir+fluofiles[0]+"] file=binary.tif sort");
origin=getTitle();
n=nSlices();
cellnum=newArray(n);
name=newArray(n);
for (b=0;b<n;b++)
{
	setSlice(b+1);
	test=getInfo("slice.label");
	test=substring(test,0,lengthOf(test)-18);
	test=test+"CFP";
	if (File.exists(roi_dir+test+".zip")==true){
	roiManager("Open", roi_dir+test+".zip");}
	selectWindow(origin);
	name[b]=getInfo("slice.label");
	run("Duplicate...", " ");
	run("Properties...", "channels=1 slices=1 frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
	r=roiManager("count");
	cellnum[b]=r;
	title=getTitle();
	
	roi=newArray(r);if(r>0){
	for (a=0;a<r;a++)
	{
		
		roi[a]=a;
		spot_number=0;
		selectWindow(title);
		roiManager("Select", a);
		run("Duplicate...", " ");run("Clear Outside");run("Select None");
		run("Invert");
		run("Analyze Particles...", "display exclude clear");
		spot_number=nResults();
		List.set(name[b]+"_"+a, spot_number);
		count=count+1;
		close();
	}
	
	roiManager("Select", roi);
	roiManager("Delete");}
	selectWindow(origin);
	run("Next Slice [>]");
	selectWindow("ROI Manager");run("Close");
}
if (isOpen("Results")==true){selectWindow("Results");run("Close");}
for (m=0;m<files;m++)
{
	
	num=cellnum[m];
	Array.getStatistics(cellnum, min, max, mean, stdDev);
	
	for (j=0;j<max;j++)
	{
		setResult(name[m],j,"-100");
	}
	for (f=0;f<num;f++)
	{
		value=List.getValue(name[m]+"_"+f);
		setResult(name[m],f,value);
	}
}
close("\\Others");
close();
updateResults();
//selectWindow("ROI Manager");run("Close");
if (isOpen("Results")==true){
	saveAs("Results", analysis+"CFP.xls");
	selectWindow("Results");run("Close");}
List.clear();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

roi_dir=dir+"/cells/";
fluo_dir=dir+"/coloc/";
fluofiles=getFileList(fluo_dir);
roifiles=getFileList(roi_dir);
files=lengthOf(roifiles);
//destination=getDirectory("Where to Save");

count=0;
//setBatchMode(true);
run("Image Sequence...", "open="+fluo_dir+fluofiles[0]+" file=coloc.tif sort");
origin=getTitle();
n=nSlices();
cellnum=newArray(n);
name=newArray(n);
for (b=0;b<n;b++)
{
	setSlice(b+1);
	test=getInfo("slice.label");
	test=substring(test,0,lengthOf(test)-5);
	test=test+"CFP";
	if (File.exists(roi_dir+test+".zip")==true){
	roiManager("Open", roi_dir+test+".zip");}
	selectWindow(origin);
	name[b]=getInfo("slice.label");
	run("Duplicate...", " ");
	run("Properties...", "channels=1 slices=1 frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
	r=roiManager("count");
	cellnum[b]=r;
	title=getTitle();
	
	roi=newArray(r);if(r>0){
	for (a=0;a<r;a++)
	{
		
		roi[a]=a;
		spot_number=0;
		selectWindow(title);
		roiManager("Select", a);
		run("Duplicate...", " ");run("Clear Outside");run("Select None");
		run("Invert");
		run("Analyze Particles...", "display exclude clear");
		spot_number=nResults();
		List.set(name[b]+"_"+a, spot_number);
		count=count+1;
		close();
	}
	
	roiManager("Select", roi);
	roiManager("Delete");}
	selectWindow(origin);
	run("Next Slice [>]");
	selectWindow("ROI Manager");run("Close");
}

if (isOpen("Results")==true){selectWindow("Results");run("Close");}
for (m=0;m<files;m++)
{
	
	num=cellnum[m];
	Array.getStatistics(cellnum, min, max, mean, stdDev);
	
	for (j=0;j<max;j++)
	{
		setResult(name[m],j,"-100");
	}
	for (f=0;f<num;f++)
	{
		value=List.getValue(name[m]+"_"+f);
		setResult(name[m],f,value);
	}
}
close("\\Others");
close();
updateResults();
//selectWindow("ROI Manager");run("Close");
if (isOpen("Results")==true){
	saveAs("Results", analysis+"coloc.xls");
	selectWindow("Results");run("Close");}
List.clear();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

roi_dir=dir+"/cells/";
fluo_dir=dir+"/cdc13_only/";
fluofiles=getFileList(fluo_dir);
roifiles=getFileList(roi_dir);
files=lengthOf(roifiles);
//destination=getDirectory("Where to Save");

count=0;
//setBatchMode(true);
run("Image Sequence...", "open="+fluo_dir+fluofiles[0]+" file=ONLY sort");
origin=getTitle();
n=nSlices();
cellnum=newArray(n);
name=newArray(n);
for (b=0;b<n;b++)
{
	setSlice(b+1);
	test=getInfo("slice.label");
	test=substring(test,0,lengthOf(test)-10);
	test=test+"CFP";
	if (File.exists(roi_dir+test+".zip")==true){
	roiManager("Open", roi_dir+test+".zip");}
	selectWindow(origin);
	name[b]=getInfo("slice.label");
	run("Duplicate...", " ");
	run("Properties...", "channels=1 slices=1 frames=1 unit=pixel pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
	r=roiManager("count");
	cellnum[b]=r;
	title=getTitle();
	
	roi=newArray(r);if(r>0){
	for (a=0;a<r;a++)
	{
		
		roi[a]=a;
		spot_number=0;
		selectWindow(title);
		roiManager("Select", a);
		run("Duplicate...", " ");run("Clear Outside");run("Select None");
		run("Invert");
		run("Analyze Particles...", "display exclude clear");
		spot_number=nResults();
		List.set(name[b]+"_"+a, spot_number);
		count=count+1;
		close();
	}
	
	roiManager("Select", roi);
	roiManager("Delete");}
	selectWindow(origin);
	run("Next Slice [>]");
	selectWindow("ROI Manager");run("Close");
}
if (isOpen("Results")==true){selectWindow("Results");run("Close");}
for (m=0;m<files;m++)
{
	
	num=cellnum[m];
	Array.getStatistics(cellnum, min, max, mean, stdDev);
	
	for (j=0;j<max;j++)
	{
		setResult(name[m],j,"-100");
	}
	for (f=0;f<num;f++)
	{
		value=List.getValue(name[m]+"_"+f);
		setResult(name[m],f,value);
	}
}
close("\\Others");
close();
updateResults();
//selectWindow("ROI Manager");run("Close");
if (isOpen("Results")==true){
	saveAs("Results", analysis+"cdc13_only.xls");
	selectWindow("Results");run("Close");}
List.clear();




