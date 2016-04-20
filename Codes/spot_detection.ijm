dir=getDirectory("image");
title=getTitle();
Dialog.create("spot detection");
Dialog.addNumber("radius", 3);
Dialog.addNumber("cutoff", 3);
Dialog.addNumber("per/abs", 0.10000);
Dialog.addCheckbox("finished ?", 0);
Dialog.show();
rad=Dialog.getNumber();
cut=Dialog.getNumber();
perabs=Dialog.getNumber();
done=Dialog.getCheckbox();
while (done==0)
{
run("Spot detection", "radius="+rad+" cutoff="+cut+" per/abs="+perabs);

open(dir+title+"det.csv");
r=nResults();
run("Colors...", "foreground=white background=white selection=yellow");
selectWindow(title);
for (a=0;a<r;a++)
{
	x=getResult("x",a);
	y=getResult("y",a);
	makeRectangle(x-2, y-2, 5, 5);
	roiManager("Add");
}

roiManager("Show All without labels");
selectWindow("ROI Manager");run("Close");
selectWindow("Results");run("Close");

Dialog.create("spot detection");
Dialog.addNumber("radius", rad);
Dialog.addNumber("cutoff", cut);
Dialog.addNumber("per/abs", perabs);
Dialog.addCheckbox("finished ?", done);
Dialog.show();
rad=Dialog.getNumber();
cut=Dialog.getNumber();
perabs=Dialog.getNumber();
done=Dialog.getCheckbox();
}