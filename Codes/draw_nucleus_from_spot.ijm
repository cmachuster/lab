x=98; y=113;
spacer=20;
getStatistics(area, mean, min, max, std, histogram);

//Make star
//Horizontal line
makeLine(x-spacer, y, x+spacer, y);
hor=getProfile();

for (a=0;a<hor.length-1;a++)
{
	if (hor[a]<=mean && hor[a+1]>=mean)
	{x1=a;}
	if (hor[a]>=mean && hor[a+1]<=mean)
	{x2=a;}
}
hor_x1=x-spacer+x1;
hor_x2=x-spacer+x2;
hor_y1=y;
hor_y2=y;
//vertical line
makeLine(x, y-spacer, x, y+spacer);
ver=getProfile();

for (b=0;b<ver.length-1;b++)
{
	if (ver[b]<=mean && ver[b+1]>=mean)
	{y1=b;}
	if (ver[b]>=mean && ver[b+1]<=mean)
	{y2=b;}
}
ver_y1=y-spacer+y1;
ver_y2=y-spacer+y2;
ver_x1=x;
ver_x2=x;
//diagonal line 1 = /
spacer_dia=20/cos(PI/4);
makeLine(x-spacer, y+spacer, x+spacer, y-spacer);
dia1=getProfile();
for (c=0;c<dia1.length-1;c++)
{
	if (dia1[c]<=mean && dia1[c+1]>=mean)
	{dia1_pos1=c;}
	if (dia1[c]>=mean && dia1[c+1]<=mean)
	{dia1_pos2=c;}
}

dia1_x1=x-(cos(PI/4)*(spacer_dia-dia1_pos1));
dia1_y1=y+(cos(PI/4)*(spacer_dia-dia1_pos1));
dia1_x2=x+(cos(PI/4)*(dia1_pos2-spacer_dia));
dia1_y2=y-(cos(PI/4)*(dia1_pos2-spacer_dia));

//diagonal line 2 = \
makeLine(x-spacer, y-spacer, x+spacer, y+spacer);
dia2=getProfile();
for (d=0;d<dia2.length-1;d++)
{
	if (dia2[d]<=mean && dia2[d+1]>=mean)
	{dia2_pos1=d;}
	if (dia2[d]>=mean && dia2[d+1]<=mean)
	{dia2_pos2=d;}
}

dia2_x1=x-(cos(PI/4)*(spacer_dia-dia2_pos1));
dia2_y1=y-(cos(PI/4)*(spacer_dia-dia2_pos1));
dia2_x2=x+(cos(PI/4)*(dia2_pos2-spacer_dia));
dia2_y2=y+(cos(PI/4)*(dia2_pos2-spacer_dia));




makePolygon(hor_x1, hor_y1, dia2_x1, dia2_y1, ver_x1, ver_y1, dia1_x2, dia1_y2, hor_x2, hor_y2, dia2_x2, dia2_y2, ver_x2, ver_y2, dia1_x1, dia1_y1);
run("Fit Spline");
//print(dia2_y2);
//print(dia1_y2);





