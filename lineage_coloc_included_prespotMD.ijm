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
pre_spot_mo=newArray(lin);
pre_spot_dau=newArray(lin);
mit_dau=newArray(lin);
mit_mo=newArray(lin);
Array.fill(pre_spot_mo, 100);Array.fill(pre_spot_dau, 100);



for (b=0;b<lin;b++)
{

	if (frame[b]>0)
	{
	pre_spot_dau[b]=getResult("cell_"+dau[b],frame[b]-2);	
	pre_spot_mo[b]=getResult("cell_"+mo[b],frame[b]-2);
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
selectWindow("Results");run("Close");

//filling coloc array
pre_coloc_dau=newArray(lin);
pre_coloc_mo=newArray(lin);
coloc_dau=newArray(lin);
coloc_mo=newArray(lin);
Array.fill(pre_coloc_mo, 100);Array.fill(pre_coloc_dau, 100);

for (res=0;res<files;res++)
{
	spot=indexOf(measure_files[res], "coloc");
	excel=indexOf(measure_files[res], ".xls");
	if (spot>=0 && excel>=0)
	{
	open(measure+measure_files[res]);
	}
}

for (bb=0;bb<lin;bb++)
{

	if (frame[bb]>0)
	{
	pre_coloc_dau[bb]=getResult("cell_"+dau[bb],frame[bb]-2);	
	pre_coloc_mo[bb]=getResult("cell_"+mo[bb],frame[bb]-2);
	coloc_dau[bb]=getResult("cell_"+dau[bb],frame[bb]-1);
	coloc_mo[bb]=getResult("cell_"+mo[bb],frame[bb]-1);
	
	}
}
selectWindow("Results");run("Close");


final=newArray(lin);
G2=newArray(lin);

//filling result arrays

//for cdc13 global
for (w=0;w<lin;w++)
{

	if (pre_spot_dau[w]<=0 && pre_spot_mo[w]>0 && mit_dau[w]>0 && mit_mo[w]>0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="PmMD";}
	if (pre_spot_dau[w]>0 && pre_spot_mo[w]<=0 && mit_dau[w]>0 && mit_mo[w]>0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="PdMD";}
	if (pre_spot_dau[w]>0 && pre_spot_mo[w]>0 && mit_dau[w]>0 && mit_mo[w]>0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="PmdMD";}

	if (pre_spot_dau[w]<=0 && pre_spot_mo[w]>0 && mit_dau[w]>0 && mit_mo[w]<=0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="PmD";}
	if (pre_spot_dau[w]>0 && pre_spot_mo[w]<=0 && mit_dau[w]>0 && mit_mo[w]<=0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="PdD";}
	if (pre_spot_dau[w]>0 && pre_spot_mo[w]>0 && mit_dau[w]>0 && mit_mo[w]<=0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="PmdD";}

	if (pre_spot_dau[w]<=0 && pre_spot_mo[w]>0 && mit_dau[w]<=0 && mit_mo[w]>0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="PmM";}
	if (pre_spot_dau[w]>0 && pre_spot_mo[w]<=0 && mit_dau[w]<=0 && mit_mo[w]>0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="PdM";}
	if (pre_spot_dau[w]>0 && pre_spot_mo[w]>0 && mit_dau[w]<=0 && mit_mo[w]>0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="PmdM";}
	
	if (pre_spot_dau[w]<=0 && pre_spot_mo[w]>0 && mit_dau[w]<=0 && mit_mo[w]<=0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="Pm";}
	if (pre_spot_dau[w]>0 && pre_spot_mo[w]<=0 && mit_dau[w]<=0 && mit_mo[w]<=0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="Pd";}
	if (pre_spot_dau[w]>0 && pre_spot_mo[w]>0 && mit_dau[w]<=0 && mit_mo[w]<=0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="Pmd";}

	if (pre_spot_dau[w]<=0 && pre_spot_mo[w]<=0 && mit_dau[w]<=0 && mit_mo[w]<=0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="none";}
	if (pre_spot_dau[w]<=0 && pre_spot_mo[w]<=0 && mit_dau[w]>0 && mit_mo[w]<=0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="D";}
	if (pre_spot_dau[w]<=0 && pre_spot_mo[w]<=0 && mit_dau[w]<=0 && mit_mo[w]>0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="M";}
	
	if (pre_spot_dau[w]<=0 && pre_spot_mo[w]<=0 && mit_dau[w]>0 && mit_mo[w]>0 && pre_spot_mo[w]<100 && pre_spot_dau[w]<100)
	{mo_with[w]=mit_mo[w];dau_with[w]=mit_dau[w];final[w]="MD";}
	
	if (frame[w]!=25 && frame[w]!=0)
	{G2[w]=frame[w]-apparition[w];}
}
//for coloc  "P" = pre_div cell "M"=present in mother cell after div "D"=present in daughter cell after div
coloc_pattern=newArray(lin);
for (ww=0;ww<lin;ww++)
{

	if (pre_coloc_dau[ww]<=0 && pre_coloc_mo[ww]>0 && coloc_dau[ww]>0 && coloc_mo[ww]>0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="PmMD";}
	if (pre_coloc_dau[ww]>0 && pre_coloc_mo[ww]<=0 && coloc_dau[ww]>0 && coloc_mo[ww]>0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="PdMD";}
	if (pre_coloc_dau[ww]>0 && pre_coloc_mo[ww]>0 && coloc_dau[ww]>0 && coloc_mo[ww]>0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="PmdMD";}

	if (pre_coloc_dau[ww]<=0 && pre_coloc_mo[ww]>0 && coloc_dau[ww]>0 && coloc_mo[ww]<=0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="PmD";}
	if (pre_coloc_dau[ww]>0 && pre_coloc_mo[ww]<=0 && coloc_dau[ww]>0 && coloc_mo[ww]<=0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="PdD";}
	if (pre_coloc_dau[ww]>0 && pre_coloc_mo[ww]>0 && coloc_dau[ww]>0 && coloc_mo[ww]<=0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="PmdD";}

	if (pre_coloc_dau[ww]<=0 && pre_coloc_mo[ww]>0 && coloc_dau[ww]<=0 && coloc_mo[ww]>0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="PmM";}
	if (pre_coloc_dau[ww]>0 && pre_coloc_mo[ww]<=0 && coloc_dau[ww]<=0 && coloc_mo[ww]>0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="PdM";}
	if (pre_coloc_dau[ww]>0 && pre_coloc_mo[ww]>0 && coloc_dau[ww]<=0 && coloc_mo[ww]>0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="PmdM";}

	if (pre_coloc_dau[ww]<=0 && pre_coloc_mo[ww]>0 && coloc_dau[ww]<=0 && coloc_mo[ww]<=0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="Pm";}
	if (pre_coloc_dau[ww]>0 && pre_coloc_mo[ww]<=0 && coloc_dau[ww]<=0 && coloc_mo[ww]<=0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="Pd";}
	if (pre_coloc_dau[ww]>0 && pre_coloc_mo[ww]>0 && coloc_dau[ww]<=0 && coloc_mo[ww]<=0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="Pmd";}

	if (pre_coloc_dau[ww]<=0 && pre_coloc_mo[ww]<=0 && coloc_dau[ww]<=0 && coloc_mo[ww]<=0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="none";}
	if (pre_coloc_dau[ww]<=0 && pre_coloc_mo[ww]<=0 && coloc_dau[ww]>0 && coloc_mo[ww]<=0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="D";}
	if (pre_coloc_dau[ww]<=0 && pre_coloc_mo[ww]<=0 && coloc_dau[ww]<=0 && coloc_mo[ww]>0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="M";}

	if (pre_coloc_dau[ww]<=0 && pre_coloc_mo[ww]<=0 && coloc_dau[ww]>0 && coloc_mo[ww]>0 && pre_coloc_mo[ww]<100 && pre_coloc_dau[ww]<100)
	{coloc_pattern[ww]="MD";}
	
}





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
Array.show(mo,dau,frame,final,div_mo,div_dau,next_div_mo,next_div_dau,G2,coloc_pattern);
