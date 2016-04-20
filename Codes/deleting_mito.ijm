dir=getDirectory("Mito Mask Folder ?");
run("Colors...", "foreground=black background=black selection=yellow");
files=getFileList(dir);
temp=File.getParent(dir);
fluo_dir=temp+"/YFP_mid/";
fluofiles=getFileList(fluo_dir);

 
mito_only=temp+"/mito_only/";
File.makeDirectory(mito_only);
no_mito=temp+"/no_mito/";
File.makeDirectory(no_mito);

for (a=0;a<lengthOf(files);a++)
{
		open(dir+files[a]);
		mask=getTitle();
		run("Create Selection");
		open(fluo_dir+fluofiles[a]);
		run("Restore Selection");
		run("Clear", "slice");
		run("Select None");
		saveAs("Tiff", mito_only+substring(files[a],0,lengthOf(files[a])-4)+"_mitoONLY.tif");
		close();
		open(fluo_dir+fluofiles[a]);
		run("Restore Selection");
		run("Make Inverse");
		run("Clear", "slice");
		run("Select None");
		saveAs("Tiff", no_mito+substring(files[a],0,lengthOf(files[a])-4)+"_NOmito.tif");
		close();close();
}
