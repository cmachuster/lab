title=getTitle();
size=lengthOf(title);
name=substring(title, 0, size-4);
//Isolate cell with the line
//getLine(x1, y1, x2, y2, lineWidth);
//makeRectangle(x1-5, y1-5, x2-x1+10, y2-y1+10);
//run("Duplicate...", " ");
//run("Gaussian Blur...", "sigma=3");
//makeLine(x1, y1, x2, y2, 1);


run("Plot Profile");
Plot.getValues(x, y);

test=Array.findMaxima(y, 50);
Array.sort(test);

if (test.length>3)
{
	print("too much edges");
	Array.print(test);
	selectWindow("Plot of "+name);
	run("Close");
	exit();
}
else
{
	bud=test[1]-test[0];
	mother=test[2]-test[1];
	ratio=bud/mother;
}

selectWindow("Plot of "+name);
Array.print(test);
run("Close");
print(ratio);