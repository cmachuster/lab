n=nImages;
selectImage(1);
one=getTitle();
dir=getDirectory("image");
run("Erode", "stack");
selectImage(2);
two=getTitle();
run("Erode", "stack");


imageCalculator("AND create stack", one,two);
saveAs("Tiff", dir+"coloc.tif");
close();close();close();