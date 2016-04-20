dir=getDirectory("parent folder");
fluo_dir=dir+"/Fluo1/save/";
mask_dir=dir+"/mito_mask/";

foci_out=dir+"/YFP_out/";
File.makeDirectory(foci_out);

file_fluo=getFileList(fluo_dir);
file_mask=getFileList(mask_dir);

count=0;
for (b=0;b<lengthOf(file_fluo);b++)
{
	if (indexOf(file_fluo[b],"binary.tif")>0)
	{
		open(fluo_dir+file_fluo[b]);
		fluo=getTitle();
		open(mask_dir+file_mask[count]);
		mask=getTitle();
		
		run("Invert");run("Dilate");
		imageCalculator("AND create", fluo,mask);
		out=getTitle();
		selectWindow(mask);close();
		selectWindow(fluo);close();
		selectWindow(out);
		saveAs("Tiff", foci_out+substring(file_mask[count],0,lengthOf(file_mask[count])-8)+"foci_out.tif");
		close();
		count++;
	}
}

