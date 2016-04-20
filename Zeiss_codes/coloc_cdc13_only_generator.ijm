dir=getDirectory("Folder to Analyse");
yfp_dir=dir+"YFP/save/";
cfp_dir=dir+"CFP/save/";

yfp_files=getFileList(yfp_dir);
cfp_files=getFileList(cfp_dir);

cdc13_dir=dir+"cdc13_only/";
File.makeDirectory(cdc13_dir);

coloc_dir=dir+"coloc/";
File.makeDirectory(coloc_dir);


for (a=0;a<lengthOf(yfp_files);a++)
{
	if (indexOf(yfp_files[a],"binary.tif")>0)
	{
		open(yfp_dir+yfp_files[a]);
		yfp=getTitle();
		open(cfp_dir+cfp_files[a]);
		cfp=getTitle();

		selectWindow(cfp);
		run("Duplicate...", "duplicate");
		cfp2=getTitle();
		selectWindow(cfp);
		run("Erode", "stack");
		run("Erode", "stack");
		imageCalculator("Subtract create stack", yfp,cfp);
		cdc13_only=getTitle();

		selectWindow(cdc13_only);
		saveAs("Tiff", cdc13_dir+substring(yfp,0,lengthOf(yfp)-19)+"cdc13_ONLY.tif");
		close();

		selectWindow(yfp);
		//run("Erode", "stack");
		selectWindow(cfp2);
		//run("Erode", "stack");
		imageCalculator("AND create stack", yfp,cfp2);
		coloc=getTitle();
		saveAs("Tiff", coloc_dir+substring(yfp,0,lengthOf(yfp)-19)+"coloc.tif");
		close();

		selectWindow(cfp);close();
		selectWindow(cfp2);close();
		selectWindow(yfp);close();
		
	}
}
