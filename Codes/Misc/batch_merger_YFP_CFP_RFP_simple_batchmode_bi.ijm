dir_ori=getDirectory("Origin Directory");
dir_fin=getDirectory("Destination Directory");
Dialog.create("Splitter");
Dialog.addNumber("Number of slices", 9);
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
	run("Stack to Hyperstack...", "order=xyczt(default) channels=4 slices="+slice+" frames="+n/slice/4+" display=Grayscale");

	run("Duplicate...", "duplicate channels=4 slices=5");
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
	run("Duplicate...", "duplicate channels=3");
	run("Save", "save="+dir_fin+""+name+"-RFP.tif");
	rfp=getTitle();
	selectWindow(test);
	close();

//Project fluo channels and save in different folders

	dir_yfp=dir_fin+"YFP/";
	dir_cfp=dir_fin+"CFP/";
	dir_rfp=dir_fin+"RFP/";
	File.makeDirectory(dir_yfp);
	File.makeDirectory(dir_cfp);
	File.makeDirectory(dir_rfp);
	selectImage(yfp);
	
	run("Z Project...", "projection=[Max Intensity] all");
	run("Grays");
	run("Save", "save="+dir_yfp+""+name+"-YFP_proj.tif");
	selectImage(cfp);
	
	run("Z Project...", "projection=[Max Intensity] all");
	run("Grays");
	run("Save", "save="+dir_cfp+""+name+"-CFP_proj.tif");
	selectImage(rfp);
	
	run("Z Project...", "projection=[Max Intensity] all");
	run("Grays");
	run("Save", "save="+dir_rfp+""+name+"-RFP_proj.tif");
	setBatchMode(false);
	close();
}
beep();
print("Images splitted !!!!");