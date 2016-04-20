getSelectionCoordinates(x, y);
dist=x.length

// X axis for the plot

length=newArray(dist);
for (q=0;q<=dist-1;q++)
{
length[q]=q;
}

// Pixel values in RGB and put them into an array

// Red Values
arrr=newArray(dist);
for (a=0; a<=dist-1;a++)
{
r=getPixel(x[a], y[a]);
r=(r>>16)&0xff;
arrr[a]=r;
}
Array.getStatistics(arrr, min, max, mean, std);
max=max

// Green Values
arrg=newArray(dist);
for (a=0; a<=dist-1;a++)
{
g=getPixel(x[a], y[a]);
g=(g>>8)&0xff;
arrg[a]=g;
}

// Blue Values
arrb=newArray(dist);
for (a=0; a<=dist-1;a++)
{
b=getPixel(x[a], y[a]);
b=b&0xff;
arrb[a]=b;
}

//Create RGB Plot
Plot.create("Profile RED", "Contour Size", "Intensity");
Plot.setLimits(1, dist, 0, 255);
Plot.setColor("red");
Plot.add("curve",arrr);
Plot.setColor("cyan");
Plot.add("curve",arrg);
Plot.setColor("blue");
Plot.add("curve",arrb);
Plot.update();
list(arrr,arrg,arrb);



function list(a,b,c) {
	if (isOpen("Results")) {selectWindow("Results"); run("Close");}
	for (i=0; i<a.length; i++){
		setResult("Red", i, a[i]);
		setResult("Green", i, b[i]);
		setResult("Blue", i, c[i]);
	}
	updateResults();

selectWindow("Results");run("Close");
