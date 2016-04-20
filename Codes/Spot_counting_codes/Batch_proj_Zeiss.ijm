dir=getDirectory("Origin Directory");
orifi=getFileList(dir);
files=lengthOf(orifi);

dir2="C:\\Users\\machu\\Desktop\\temp\\"

for (a=0;a<files;a++)
{
	//setBatchMode(true);
	nd=indexOf(orifi[a], ".nd");
	if (nd>=0)
	{
		run("Bio-Formats Windowless Importer", "open="+dir+""+orifi[a]+"");
		im=getTitle();
		getDimensions(width, height, channels, slices, frames);
		label=getInfo("slice.label");
		ind=indexOf(label, "-");
		chan=substring(label, ind+1, lengthOf(label));
		chan_name=split(chan,"/");
		for (b=1;b<=channels;b++)
		{
			dir_temp=dir+chan_name[b-1]+"/";
			File.makeDirectory(dir_temp);
			if (chan_name[b-1]=="TRANS")
			{
				selectWindow(im);
				run("Duplicate...", "duplicate channels="+b+" slices="+round(slices/2));
				saveAs("Tiff", dir_temp+im);
				close();
				
			}
			else {
				selectWindow(im);
				run("Duplicate...", "duplicate channels="+b);
				run("Z Project...", "projection=[Max Intensity]");
				saveAs("Tiff", dir_temp+im);
				close();close();
			}
		}
	close();
	}

}
