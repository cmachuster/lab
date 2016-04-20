dir_ori=getDirectory("Origin Directory");
orifi=getFileList(dir_ori);
files=lengthOf(orifi);
dir=getDirectory("Where to Save");



for (a=0;a<files;a++)
{
open(""+dir_ori+""+orifi[a]+"");	
dir_phase=dir+"phase/";
dir_yfp=dir+"YFP/";
dir_cfp=dir+"CFP/";
File.makeDirectory(dir_yfp);
File.makeDirectory(dir_cfp);
File.makeDirectory(dir_phase);

title=getTitle();
size=lengthOf(title);
name=substring(title, 0, size-4);
n=nSlices();
run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices="+n/3+" frames=1 display=Grayscale");
hyper=getTitle();

run("Duplicate...", "duplicate channels=1");
run("Grays");
phase=getTitle();



selectWindow(hyper);
run("Duplicate...", "duplicate channels=2");
run("Grays");
yfp=getTitle();


selectWindow(hyper);
run("Duplicate...", "duplicate channels=3");
run("Grays");
cfp=getTitle();


selectWindow(hyper);
close();


selectWindow(phase);
run("Save", "save="+dir_phase+""+name+"-phase.tif");
close();

selectWindow(yfp);
run("Bio-Formats Exporter", "save="+dir_yfp+""+name+"-YFP.ome.tif compression=Uncompressed");
close();

selectWindow(cfp);
run("Bio-Formats Exporter", "save="+dir_cfp+""+name+"-CFP.ome.tif compression=Uncompressed");
close();


}