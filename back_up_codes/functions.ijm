//choose a directory and get name of the opened image (without extension)
dir=getDirectory("Choose a Directory");
test=getTitle();
size=lengthOf(test);
name=substring(test, 0, size-4);
//get string from the image name
pos=substring(test, size-5, size-4);
// Save image in the specified directory with a suffix (i.e. "-phase.tif")
run("Save", "save="+dir+""+name+"-phase.tif");


---------------------------------------------------

//sort images depending on their names

image=nImages();
yellow=newArray(image);
phase=newArray(image);
for (a=1;a<=image;a++)
{
selectImage(a);
win=getTitle();
yfp=endsWith(win,"YFP.tif");
pha=endsWith(win,"phase.tif");
yellow[a-1]=yfp;
phase[a-1]=pha;
}
