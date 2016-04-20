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
