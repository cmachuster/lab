//dir_ori=getDirectory("Origin Directory");
dir_final=getDirectory("Destination Directory");
Dialog.create("Cropper");
Dialog.addNumber("Number of slices", 7);
Dialog.show();
slice=Dialog.getNumber();
//Crop and split channels + save files with extensions in the designated folder
test=getTitle();
size=lengthOf(test);
pos=substring(test, size-5, size-4);
name=substring(test, 0, size-4);
n=nSlices();


run("Crop");
run("Duplicate...", "duplicate channels=2");
wrongphase=getTitle();
run("Slice Keeper", "first=1 last="+n+" increment="+slice);
run("Save", "save="+dir_final+""+name+"-phase.tif");
phase=getTitle();
selectWindow(wrongphase);
close();
selectWindow(test);
run("Duplicate...", "duplicate channels=1");
run("Save", "save="+dir_final+""+name+"-YFP.tif");
fluo=getTitle();
selectWindow(test);
close();



//Color + Combine images + Save the resulting image

selectImage(phase);
resetMinAndMax();
run("Grays");
run("RGB Color");
selectImage(fluo);
m=nSlices();	
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices="+slice+" frames="+m/slice+" display=Grayscale");
selectImage(fluo);
run("Z Project...", "projection=[Max Intensity] all");
run("Grays");
run("Save", "save="+dir_final+""+name+"-YFP_proj.tif");
setSlice(10);
resetMinAndMax();
run("Yellow");
run("RGB Color");
fluoproj=getTitle();
selectImage(fluo);
close();

imageCalculator("Add create stack", phase,fluoproj);
merged=getTitle();
n=nSlices();
run("Combine...", ""+phase+" "+fluoproj+"");
run("Combine...", "stack1=[Combined Stacks] stack2=["+merged+"]");
makeRectangle(15, 11, 43, 25);
run("Properties...", "channels=1 slices="+n+" frames=1 unit=um pixel_width=0.13 pixel_height=0.13 voxel_depth=0.13");
run("Colors...", "foreground=white background=red selection=yellow");
run("Time Stamper", "starting=0 interval=20 x=15 y=36 font=25 decimal=0 anti-aliased or=min");
run("Scale Bar...", "width=10 height=4 font=14 color=White background=None location=[Lower Right] bold label");
run("Save", "save="+dir_final+""+name+"-combined.tif");