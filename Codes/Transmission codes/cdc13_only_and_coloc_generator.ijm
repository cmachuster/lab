im=getDirectory("image");
selectImage(1);
test=getTitle();
if (indexOf(test,"CFP")>=0) {cfp=test; selectImage(2); yfp=getTitle();} else {yfp=test; selectImage(2); cfp=getTitle;}

selectWindow(cfp);
run("Duplicate...", "duplicate");
cfp2=getTitle();
selectWindow(cfp);
run("Erode", "stack");
run("Erode", "stack");
imageCalculator("Subtract create stack", yfp,cfp);
cdc13_only=getTitle();

selectWindow(cdc13_only);
saveAs("Tiff", im+"cdc13_ONLY.tif");
close();

selectWindow(yfp);
run("Erode", "stack");
selectWindow(cfp2);
run("Erode", "stack");
imageCalculator("AND create stack", yfp,cfp2);
coloc=getTitle();
saveAs("Tiff", im+"coloc.tif");
close();

selectWindow(cfp);close();
selectWindow(cfp2);close();
selectWindow(yfp);close();