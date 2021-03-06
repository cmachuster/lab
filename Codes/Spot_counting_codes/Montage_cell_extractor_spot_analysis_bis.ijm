Stack.getDimensions(width, height, channels, slices, frames);
//Dialog Creation
//Dialog.create("Montage Exctractor")
//Dialog.addString("Which Channel is the phase ?", 3);
//Dialog.addString("Which Slice to extract ?",5);
//Dialog.addString("Montage size N x N",3);
//Dialog.show();
phase_cha=channels;
frame=round(slices/2);
montage=getHeight()/1080;
original=getTitle();
destination=getDirectory("image");
destination2=destination+substring(original,0,lengthOf(original)-4);
File.makeDirectory(destination2);


//Exctract Phase Images
phase_dir=destination2+"/phase/";
File.makeDirectory(phase_dir);

run("Duplicate...", "duplicate channels="+phase_cha+" slices="+frame);
run("Montage to Stack...", "images_per_row="+montage+" images_per_column="+montage+" border=0");
run("Image Sequence... ", "format=TIFF name=phase save="+phase_dir+"phase0000.tif");
close();close();

//Extract projected fluo images

for (a=1;a<=channels;a++)
{
	if (a!=phase_cha)
	{
		fluo_dir=destination2+"/Fluo"+a+"/";
		File.makeDirectory(fluo_dir);
		run("Duplicate...", "duplicate channels="+a);
		run("Z Project...", "projection=[Max Intensity]");
		run("Montage to Stack...", "images_per_row="+montage+" images_per_column="+montage+" border=0");
		run("Image Sequence... ", "format=TIFF name=fluo"+a+" save="+fluo_dir+"fluo"+a+"0000.tif");
		close();close();close();
		
	}
}
//close();
/// Exctract cells from phase
files=getFileList(phase_dir);
cell_dir=destination2+"/cells/";
File.makeDirectory(cell_dir);
for (z=0;z<lengthOf(files);z++)
{
	open(phase_dir+files[z]);
	title=getTitle();
	size=lengthOf(title);
	pos=substring(title, size-5, size-4);	
	name=substring(title, 0, size-4);

	//Phantasting
	run("32-bit");
	run("PHANTAST", "sigma=1.20 epsilon=0.03 do new");
	run("Invert");
	mask=getTitle();
	//run("Analyze Particles...", "size=500-Infinity circularity=0.20-1.00 exclude clear include add");
	run("Analyze Particles...", "size=500-Infinity exclude clear include add");
	//cleaning holes
	n=roiManager("count");
	ROI=newArray(n);
	run("Colors...", "foreground=white background=black selection=yellow");
	//filling ROI array
	for (a=0;a<n;a++)
	{
		ROI[a]=a;
	}
	for (b=0;b<n;b++)
	{
		roiManager("Select", ROI[b]);
		run("Clear", "slice");
	}
	roiManager("Show None");run("Select None");
	run("Watershed");
	run("Analyze Particles...", "size=800-Infinity exclude clear include add");
	selectWindow(mask);close();
	n1=roiManager("count");
	max_cell=0;
	if (n1>max_cell){max_cell=n1;}
	ROI1=newArray(n1);
	//filling ROI array
	for (a=0;a<n1;a++)
	{
		ROI1[a]=a;
	}
	//Saving ROIs
if (lengthOf(ROI1)==0)
{
	makeRectangle(0, 0, 1, 1);
	roiManager("Add");
	makeRectangle(0, 0, 1, 2);
	roiManager("Add");
	roiManager("Select", newArray(0,1));
	roiManager("Save", cell_dir+name+"_empty.zip");
	selectWindow(title);close();
	selectWindow("ROI Manager");run("Close");
}
else
{
	roiManager("Select", ROI1);
	roiManager("Save", cell_dir+name+".zip");
selectWindow(title);close();
selectWindow("ROI Manager");run("Close");
}
}

//// Spot Analysis
coloc_dir=destination2+"/coloc/";
File.makeDirectory(coloc_dir);
for (ch=1;ch<channels;ch++)
{
	
	fluo_dir=destination2+"/Fluo"+ch+"/";
	files=getFileList(fluo_dir);
	detect_fluo=fluo_dir+"/Analysis/";
	File.makeDirectory(detect_fluo);
	run("Image Sequence...", "open="+fluo_dir+"fluo20000.tif sort");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=1 frames="+lengthOf(files)+" display=Grayscale");
	runMacro("C:\\Users\\machu\\Documents\\Fiji.app\\macros\\trackmate.py");
	close();
	count=nResults();
	x_pos=newArray(count);
	y_pos=newArray(count);
	frame=newArray(count);
	for (a=0;a<count;a++)
	{
		x_pos[a]=getResult("X_POS",a);
		y_pos[a]=getResult("Y_POS",a);
		frame[a]=getResult("Frame",a);
	}
	saveAs("Results", detect_fluo+"Fluo"+ch+".xls");
	selectWindow("Results");run("Close");
	Array.getStatistics(frame, min, max, mean, stdDev);
	//create bin image for upcoming coloc analysis
	newImage("fluo"+ch, "8-bit black", width/montage, height/montage, lengthOf(files));
	for (k=0;k<count;k++)
	{
	setSlice(frame[k]+1);
	fillOval(x_pos[k]-1, y_pos[k]-1, 3, 3);
	}
	saveAs("Tiff", coloc_dir+"fluo"+ch+".tif");
	close();
	
}
///////Analysing coloc
files=getFileList(coloc_dir);
detect_coloc=coloc_dir+"/Analysis/";
File.makeDirectory(detect_coloc);
for (cc=0;cc<2;cc++)
{
	open(coloc_dir+files[cc]);
	sl=nSlices;
}

imageCalculator("AND create stack", "fluo1.tif","fluo2.tif");
coloc=getTitle();
selectWindow("fluo1.tif");close();
selectWindow("fluo2.tif");close();
selectWindow(coloc);
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=1 frames="+sl+" display=Color");
runMacro("C:\\Users\\machu\\Documents\\Fiji.app\\macros\\trackmate.py");
close();
count=nResults();
x_pos=newArray(count);
y_pos=newArray(count);
frame=newArray(count);
for (a=0;a<count;a++)
{
	x_pos[a]=getResult("X_POS",a);
	y_pos[a]=getResult("Y_POS",a);
	frame[a]=getResult("Frame",a);
}
if(lengthOf(x_pos)>0){
saveAs("Results", detect_coloc+"coloc"+".xls");
selectWindow("Results");run("Close");
Array.getStatistics(frame, min, max, mean, stdDev);}

//close();

//////////////////Detecting spots per cells/////////////////////////////
run("Image Sequence...", "open="+phase_dir+"phase0000.tif sort");
files=getFileList(cell_dir);
//store spot matrixes
//fluo1
open(destination2+"/Fluo1/Analysis/Fluo1.xls");
j=nResults();
x1=newArray(j);
y1=newArray(j);
frame1=newArray(j);
for (hh=0;hh<j;hh++)
{
	x1[hh]=getResult("X_POS",hh);
	y1[hh]=getResult("Y_POS",hh);
	frame1[hh]=getResult("Frame",hh)+1;
}
selectWindow("Results");run("Close");
//fluo2
open(destination2+"/Fluo2/Analysis/Fluo2.xls");
j=nResults();
x2=newArray(j);
y2=newArray(j);
frame2=newArray(j);
for (hh=0;hh<j;hh++)
{
	x2[hh]=getResult("X_POS",hh);
	y2[hh]=getResult("Y_POS",hh);
	frame2[hh]=getResult("Frame",hh)+1;
}
selectWindow("Results");run("Close");
//coloc
if (File.exists(destination2+"/coloc/Analysis/coloc.xls")>0){
open(destination2+"/coloc/Analysis/coloc.xls");
j=nResults();
xc=newArray(j);
yc=newArray(j);
framec=newArray(j);
for (hh=0;hh<j;hh++)
{
	xc[hh]=getResult("X_POS",hh);
	yc[hh]=getResult("Y_POS",hh);
	framec[hh]=getResult("Frame",hh)+1;
}
selectWindow("Results");run("Close");}

///ROI containing
//for fluo2
for (ro=0;ro<lengthOf(files);ro++)
{
	setSlice(ro+1);
	roiManager("Open", cell_dir+files[ro]);
	cel=roiManager("count");
	region=newArray(cel);
	for (roi=0;roi<cel;roi++)
	{
		roiManager("select", roi);
		for (spot=0;spot<lengthOf(x2);spot++)
		{
			if (Roi.contains(x2[spot], y2[spot])==1)
				{	
					region[roi]=region[roi]+1;
					
				}
		}	
	}
	for (bb=0;bb<cel;bb++)
	{
		setResult(files[ro],bb,region[bb]);	
	}
	for (bb=cel;bb<max_cell;bb++) {setResult(files[ro],bb,"-100");}
	selectWindow("ROI Manager");run("Close");
	updateResults();
}
saveAs("Results", destination2+"/analysis_fluo2.xls");
selectWindow("Results");run("Close");

//for fluo1
for (ro=0;ro<lengthOf(files);ro++)
{
	setSlice(ro+1);
	roiManager("Open", cell_dir+files[ro]);
	cel=roiManager("count");
	region=newArray(cel);
	for (roi=0;roi<cel;roi++)
	{
		roiManager("select", roi);
		for (spot=0;spot<lengthOf(x1);spot++)
		{
			if (Roi.contains(x1[spot], y1[spot])==1)
				{	
					region[roi]=region[roi]+1;
					
				}
		}	
	}
	for (bb=0;bb<cel;bb++)
	{
		setResult(files[ro],bb,region[bb]);	
	}
	for (bb=cel;bb<max_cell;bb++) {setResult(files[ro],bb,"-100");}
	selectWindow("ROI Manager");run("Close");
	updateResults();
}
saveAs("Results", destination2+"/analysis_fluo1.xls");
selectWindow("Results");run("Close");

//for coloc
if (File.exists(destination2+"/coloc/Analysis/coloc.xls")>0){
for (ro=0;ro<lengthOf(files);ro++)
{
	setSlice(ro+1);
	roiManager("Open", cell_dir+files[ro]);
	cel=roiManager("count");
	region=newArray(cel);
	for (roi=0;roi<cel;roi++)
	{
		roiManager("select", roi);
		for (spot=0;spot<lengthOf(xc);spot++)
		{
			if (Roi.contains(xc[spot], yc[spot])==1)
				{	
					region[roi]=region[roi]+1;
					
				}
		}	
	}
	for (bb=0;bb<cel;bb++)
	{
		setResult(files[ro],bb,region[bb]);	
	}
	for (bb=cel;bb<max_cell;bb++) {setResult(files[ro],bb,"-100");}
	selectWindow("ROI Manager");run("Close");
	updateResults();
}
saveAs("Results", destination2+"/analysis_coloc.xls");
selectWindow("Results");run("Close");}

close();
