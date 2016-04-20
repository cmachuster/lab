cell_dia=50;
frame_max=25;

r=nResults();
frame=newArray(r);
xroi=newArray(r);
yroi=newArray(r);
cell_num=newArray(r);
//Get information from the tracking.csv file
for (a=0;a<r;a++)
{
	frame[a]=getResult("Frame_number",a);
	xroi[a]=getResult("Position_X",a);
	yroi[a]=getResult("Position_Y",a);
	cell_num[a]=getResult("Cell_number",a);
}

///////////////////////////looking for appearing cells/////////////////////////////////////////////////
max_cell_per_frame=newArray(frame_max); //Maximal amount of cell at each frame

for (b=1;b<=frame_max;b++)
{	
	for (c=0;c<r;c++)
	{	
		if (frame[c]==b)
		{
			max_cell_per_frame[b-1]=cell_num[c];
		}
	}
}

new_cell_num=newArray(max_cell_per_frame[frame_max-1]-max_cell_per_frame[0]+1);
new_cell_frame=newArray(max_cell_per_frame[frame_max-1]-max_cell_per_frame[0]+1);
count=0;
for (dif=1;dif<frame_max;dif++)
{
	new=max_cell_per_frame[dif]-max_cell_per_frame[dif-1];
	if (new>0)
	{
		for (g=1;g<=new;g++)
		{
			new_cell_num[count]=max_cell_per_frame[dif-1]+g;
			new_cell_frame[count]=dif+1;
			//List.set(max_cell_per_frame[dif-1]+g, dif); //List giving cell number of the new cells and their frame-1 of appearence
			count++;
		}
	}
}
//Array.print(new_cell_num);
//Array.print(new_cell_frame);


////////////////////////Measure distance between new cells and surrounding cells//////////////////////////////////
xref=newArray(new_cell_num.length);
yref=newArray(new_cell_num.length);

for (k=0;k<new_cell_num.length;k++)
{
	cell_ref=new_cell_num[k];
	frame_ref=new_cell_frame[k];
	for (n=0;n<r;n++)
	{
		if (frame[n]==frame_ref && cell_num[n]==cell_ref)
		{
			xref[k]=xroi[n];//appearing cell
			yref[k]=yroi[n];//coorindates Array
		}
	}
}

//distance in apearig frame

for (w=0;w<new_cell_num.length;w++)
{
	count=0;
	for (m=0;m<r;m++)
	{
		if (frame[m]-1==new_cell_frame[w])
		{
			slice=new_cell_frame[w];
			dx = xref[w]-xroi[m]; dy = yref[w]-yroi[m];
			length = sqrt(dx*dx+dy*dy);
			List.set(cell_num[m], length);
			count++;
		}
		
		
		
	
	}
}


List.getList;






















