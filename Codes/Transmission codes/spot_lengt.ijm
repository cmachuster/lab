
measure=getDirectory("Analysis Folder");
measure_files=getFileList(measure);
files=lengthOf(measure_files);
for (res=0;res<files;res++)
{
	spot=indexOf(measure_files[res], "coloc");
	excel=indexOf(measure_files[res], ".xls");
	if (spot>=0 && excel>=0)
	{
	open(measure+measure_files[res]);
	}
}

r=nResults();

//find number of columns
limit=0;
for (a=1;a<=300;a++)
{
	test=getResult("cell_"+a, 0);
	if (isNaN(test)==false) {limit=limit+1;}
}

//make track array
tracks=newArray(r*limit);
array_count=0;
track_count=0;
for (b=1;b<=limit;b++)
{
	for (c=0;c<r;c++)
	{
		value=getResult("cell_"+b,c);
		if (value>0)
		{
			track_count=track_count+1;
			tracks[array_count]=track_count;
		}
		else {track_count=0;array_count++;}
	}
}
Array.sort(tracks);


//trim track array to keep relevant values
zero=0;
for (d=0;d<r*limit;d++)
{
	if (tracks[d]==0) {zero=zero+1;}
}
final_tracks=Array.slice(tracks,zero,r*limit);
//Array.show("spot durations",final_tracks);
//selectWindow("Results");run("Close");

//convert tracks in time

for (k=0;k<final_tracks.length;k++)
{
	final_tracks[k]=final_tracks[k]*10;
}
Array.show("spot durations",final_tracks);
selectWindow("Results");run("Close");