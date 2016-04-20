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
	selectWindow("Results");run("Close");
	Array.getStatistics(frame, min, max, mean, stdDev);
	
	
	for (g=0;g<=max;g++)
	{counter=0;
		for (gg=0;gg<count;gg++)
		{
			if (frame[gg]==g)
			{
				setResult("X_POS", counter, x_pos[gg]);
				setResult("Y_POS", counter, y_pos[gg]);
				counter++;
			}		
		}	
		updateResults();
		saveAs("Results", detect_fluo+"Fluo"+ch+"_image_"+g+".xls");
		selectWindow("Results");run("Close");
	}
	
}


