
dir=getDirectory("Choose a Directory");

win=getTitle();
size=lengthOf(win);
pos=substring(win, size-5, size-4);
name=substring(win, 0, size-4);
print(pos);
print(name);


run("Crop");
run("Duplicate...", "duplicate channels=2 slices=1");
run("Save", "save="+dir+""+name+"-phase.tif");
selectWindow(win);
run("Duplicate...", "duplicate channels=1");
run("Save", "save="+dir+""+name+"-YFP.tif");
selectWindow(win);
close();