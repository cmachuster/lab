dir=getDirectory("Mito folder ?");
files=getFileList(dir);
temp=File.getParent(dir);
 
mito_mask=temp+"/mito_mask_deconv/";
File.makeDirectory(mito_mask);


for (a=0;a<lengthOf(files);a++)
{
	if (indexOf(files[a],"extracted.tif")>0)
	{
		open(dir+files[a]);
		setAutoThreshold("Otsu dark");
		setOption("BlackBackground", false);
		run("Convert to Mask");
		run("Invert");
		saveAs("Tiff", mito_mask+substring(files[a],0,lengthOf(files[a])-14)+"_mask.tif");
		close();
	}	
}
