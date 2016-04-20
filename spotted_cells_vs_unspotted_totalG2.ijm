// This script extracts informations from the lineage and the cell tracking files
// It outputs the number of divisions after the mitosis in the daugter and the mother
// and the time it takes to perform the next division


measure=getDirectory("Analysis Folder");
measure_files=getFileList(measure);
files=lengthOf(measure_files);
blocker=5; //blocker is time limit in the time lapse, it means that we won't consider cells as blocked if they divided block time before the end of the movie
framer=25;//number of frame observed

//Extract information from lineage file
for (cells=0;cells<files;cells++)
{
	lineage=indexOf(measure_files[cells], "lineage");
	if (lineage>=0)
	{
	open(measure+measure_files[cells]);
	}
}
lin=nResults();
dau=newArray(lin);
mo=newArray(lin);
frame=newArray(lin);

for (a=0;a<lin;a++)
{
	dau[a]=getResult("daughter",a);
	mo[a]=getResult("mother",a);
	frame[a]=getResult("frame_m",a);
}


Array.getStatistics(dau, min, max, mean, stdDev);
cell_max=max;

//Analysis of spot matrix
for (res=0;res<files;res++)
{
	spot=indexOf(measure_files[res], "YFP");
	excel=indexOf(measure_files[res], ".xls");
	if (spot>=0 && excel>=0)
	{
	open(measure+measure_files[res]);
	}
}
mo_with=newArray(lin);
mo_without=newArray(lin);
dau_with=newArray(lin);
dau_without=newArray(lin);
apparition=newArray(lin);

//filling mitosis array
pre_spot=newArray(lin);
mit_dau=newArray(lin);
mit_mo=newArray(lin);
Array.fill(pre_spot, 100);


for (b=0;b<lin;b++)
{

	if (frame[b]>0)
	{
		
	pre_spot[b]=getResult("cell_"+mo[b],frame[b]-2);
	mit_dau[b]=getResult("cell_"+dau[b],frame[b]-1);
	mit_mo[b]=getResult("cell_"+mo[b],frame[b]-1);
	
	}
	//detection of the bud apparition
	for (p=1;p<framer;p++)
	{
		if (getResult("cell_"+dau[b],p)>=0 && getResult("cell_"+dau[b],p-1)<0)
		{
			
			apparition[b]=p+1;
		}
	}
}

spot_mo=newArray(lin);
spot_dau=newArray(lin);


//extraction spotted cell dividing or not

for (t=0;t<lin;t++)
{
	limit=apparition[t];
	finish=frame[t];
	if (finish==0) 
	{
		for (tt=limit;tt<framer;tt++)
		{
			if (getResult("cell_"+mo[t],tt)>0) {spot_mo[t]=1;}
			if (getResult("cell_"+dau[t],tt)>0) {spot_dau[t]=1;}
				
		}
	}
	else
	{
		scan=frame[t]-1-limit;
		if (scan>0)
		{
			for (yy=limit;yy<framer-scan;yy++)
			{
				if (getResult("cell_"+mo[t],yy)>0) {spot_mo[t]=1;}
				if (getResult("cell_"+dau[t],yy)>0) {spot_dau[t]=1;}
			}
		}
	}
	
	
}



final=newArray(lin);
G2=newArray(lin);
//filling result arrays

for (w=0;w<lin;w++)
{

	if (pre_spot[w]>0 && mit_dau[w]>0 && mit_mo[w]>0 && pre_spot[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="MD";}
	if (pre_spot[w]>0 && mit_dau[w]<=0 && mit_mo[w]>0 && pre_spot[w]<100)
	{mo_with[w]=mit_mo[w];dau_without[w]=1;final[w]="M";}
	if (pre_spot[w]>0 && mit_dau[w]>0 && mit_mo[w]<=0 && pre_spot[w]<100)
	{mo_without[w]=1;dau_with[w]=mit_dau[w];final[w]="D";}
	if (pre_spot[w]<=0 && mit_dau[w]>0 && mit_mo[w]>0 && pre_spot[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="MD";}
	if (pre_spot[w]<=0 && mit_dau[w]<=0 && mit_mo[w]>0 && pre_spot[w]<100)
	{mo_with[w]=mit_mo[w];dau_without[w]=1;final[w]="M";}
	if (pre_spot[w]<=0 && mit_dau[w]>0 && mit_mo[w]<=0 && pre_spot[w]<100)
	{mo_without[w]=1;dau_with[w]=mit_dau[w];final[w]="D";}
	if (pre_spot[w]<=0 && mit_dau[w]<=0 && mit_mo[w]<=0 && pre_spot[w]<100)
	{mo_without[w]=1;dau_without[w]=1;final[w]="none";}
	if (pre_spot[w]>0 && mit_dau[w]<=0 && mit_mo[w]<=0 && pre_spot[w]<100)
	{mo_without[w]=1;dau_without[w]=1;final[w]="unresolved";}
	if (frame[w]!=25 && frame[w]!=0)
	{G2[w]=frame[w]-apparition[w];}
}




selectWindow("Results");run("Close");



//Counting divisions
div_mo=newArray(lin);
div_dau=newArray(lin);
next_div_mo=newArray(lin);
next_div_dau=newArray(lin);

for (h=0;h<lin;h++)
{
	v=0;
	w=0;
	mother=mo[h];
	daughter=dau[h];
	time=frame[h];
	for (m=h+1;m<lin-1;m++)
	{
		if (mo[m]==mother)
		{		
			div_mo[h]=div_mo[h]+1;
			if (frame[m]>0)
			{
				List.set("a"+v,frame[m]-frame[h]);
				next_div_mo[h]=List.getValue("a"+0);
			}
			if (frame[m]==0)
			{ 
				if (20-frame[m]>blocker) //don't considerate divisions with less than 5 timepoint left as being blocked
			{
				List.set("a"+v,100);
				next_div_mo[h]=List.getValue("a"+0);
			}
			}
			v=v+1;
		}
		
		if (mo[m]==daughter)
		{
			div_dau[h]=div_dau[h]+1;
			if (frame[m]>0)
			{
			List.set(w,frame[m]-frame[h]);
			next_div_dau[h]=List.getValue(0);
			}
			if (frame[m]==0)
			{
				if (20-frame[m]>blocker) //don't considerate divisions with less than 5 timepoint left as being blocked
				{
				List.set(w,100);
				next_div_dau[h]=List.getValue(0);
				}
			}
			w=w+1;
		}
		
	}
}
Array.show(mo,dau,frame,apparition,spot_mo,spot_dau);
