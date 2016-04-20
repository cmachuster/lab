dir=getDirectory("Choose a Directory");
//Crop and split channels + save files with extensions in the designated folder
test=getTitle();
size=lengthOf(test);
pos=substring(test, size-5, size-4);
name=substring(test, 0, size-4);



run("Crop");

//Extract and save Phase
run("Duplicate...", "duplicate channels=2");
badphase=getTitle();
nphase=nSlices();
run("Slice Keeper", "first=1 last="+nphase+" increment=7");
phase=getTitle();
selectWindow(badphase);
close();
run("Save", "save="+dir+""+name+"-phase.tif");


//Extract and save Fluo
selectWindow(test);
run("Duplicate...", "duplicate channels=1");
nfluo=nSlices();
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=7 frames="+nfluo/7+" display=Grayscale");
fluo=getTitle();
run("Save", "save="+dir+""+name+"-YFP.tif");
selectWindow(test);
close();



//Color + Combine images + Save the resulting image

selectImage(phase);
resetMinAndMax();
run("Grays");
run("RGB Color");
selectImage(fluo);	
run("Z Project...", "all");
run("Save", "save="+dir+""+name+"-YFP_proj.tif");
setSlice(10);
resetMinAndMax();
run("Yellow");
run("RGB Color");
fluoproj=getTitle();
selectImage(fluo);
close();

imageCalculator("Add create stack", phase,fluoproj);
merged=getTitle();
run("Combine...", ""+phase+" "+fluoproj+"");
n=nSlices();
run("Combine...", "stack1=[Combined Stacks] stack2=["+merged+"]");
makeRectangle(15, 11, 43, 25);
run("Properties...", "channels=1 slices="+n+" frames=1 unit=um pixel_width=0.13 pixel_height=0.13 voxel_depth=0.13");
run("Time Stamper", "starting=0 interval=20 x=15 y=36 font=25 decimal=0 anti-aliased or=min");
run("Scale Bar...", "width=10 height=4 font=14 color=White background=None location=[Lower Right] bold label");
run("Save", "save="+dir+""+name+"-combined.tif");