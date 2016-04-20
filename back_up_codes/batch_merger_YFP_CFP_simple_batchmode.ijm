dir_ori=getDirectory("Origin Directory");
dir_fin=getDirectory("Destination Directory");
Dialog.create("Splitter");
Dialog.addNumber("Number of slices", 7);
Dialog.show();
slice=Dialog.getNumber();
orifi=getFileList(dir_ori);
files=lengthOf(orifi);



for (a=0;a<files;a++)
{
	setBatchMode(true);
	run("Bio-Formats Windowless Importer", "open="+dir_ori+""+orifi[a]+"");
	//open(""+dir_ori+""+orifi[a]+"");
//Split channels + save files with extensions in the designated folder
	test=getTitle();
	size=lengthOf(test);
	pos=substring(test, size-5, size-4);
	name=substring(test, 0, size-4);
	n=nSlices();


	run("Duplicate...", "duplicate channels=3");
	run("Slice Keeper", "first=1 last="+n+" increment="+slice);
	run("Save", "save="+dir_fin+""+name+"-phase.tif");
	selectWindow(test);
	run("Duplicate...", "duplicate channels=1");
	run("Save", "save="+dir_fin+""+name+"-YFP.tif");
	yfp=getTitle();
	selectWindow(test);
	run("Duplicate...", "duplicate channels=2");
	run("Save", "save="+dir_fin+""+name+"-CFP.tif");
	cfp=getTitle();
	selectWindow(test);
	close();

//Project fluo channels and save in different folders

	dir_yfp=dir_fin+"YFP/";
	dir_cfp=dir_fin+"CFP/";
	File.makeDirectory(dir_yfp);
	File.makeDirectory(dir_cfp);
	selectImage(yfp);
	m=nSlices();	
	run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices="+slice+" frames="+m/slice+" display=Grayscale");
	selectImage(yfp);
	run("Z Project...", "projection=[Max Intensity] all");
	run("Grays");
	run("Save", "save="+dir_yfp+""+name+"-YFP_proj.tif");
	selectImage(cfp);
	m=nSlices();	
	run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices="+slice+" frames="+m/slice+" display=Grayscale");
	selectImage(cfp);
	run("Z Project...", "projection=[Max Intensity] all");
	run("Grays");
	run("Save", "save="+dir_cfp+""+name+"-CFP_proj.tif");
	setBatchMode(false);
	close();
}
beep();
print("Images splitted !!!!");