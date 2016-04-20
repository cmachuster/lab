// This script extracts informations from the lineage and the cell tracking files
// It outputs the number of divisions after the mitosis in the daugter and the mother
// and the time it takes to perform the next division


measure=getDirectory("Analysis Folder");
measure_files=getFileList(measure);
files=lengthOf(measure_files);
blocker=5; //blocker is time limit in the time lapse, it means that we won't consider cells as blocked if they divided block time before the end of the movie
framer=25;//number of frame observed

observation=7;////timepoint when counting focis


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


//filling spot array

spot_dau=newArray(lin);
spot_mo=newArray(lin);

for (b=0;b<lin;b++)
{
	spot_dau[b]=getResult("cell_"+dau[b],7);
	spot_mo[b]=getResult("cell_"+mo[b],7);	
}
selectWindow("Results");run("Close");


Array.show(mo,dau,spot_mo,spot_dau);
