run("Stack Splitter", "number=12");
for (a=0;a<12;a++)
{
title=getTitle();	
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=9 frames=25 display=Grayscale");
wait(500);
run("Z Project...", "projection=[Max Intensity] all");
run("Save", "save=C:\\Users\\machu\\Desktop\\cdc13_rfa1_mec1_sml1\\clone45\\S15\\deconv\\YFP\\YFP_"+title+".tif");
close();close();

}
close();