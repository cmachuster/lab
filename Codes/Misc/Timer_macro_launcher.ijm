getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
//Create Macro choice Dialog Box
Dialog.create("Timer");
Dialog.addString("Name of the macro file","cropper");
Dialog.show();
mac=Dialog.getString();

//Create Timer Dialog Box
Dialog.create("Timer");
Dialog.addNumber("Day", dayOfMonth);
Dialog.addNumber("Hour", hour);
Dialog.addNumber("Minutes", minute+1);
Dialog.show();
dayt=Dialog.getNumber();
hourt=Dialog.getNumber();
minutet=Dialog.getNumber();

//Select Waiting Time
int=86400;
daytowait=dayt-dayOfMonth;
if (daytowait>0)
{
	int=int*daytowait;
}
//Start Waiting
for (t=1;t<=int;t++)
{
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);	
	if (dayOfMonth==dayt)
	{
		if (minute==minutet)
		{
			if (hour==hourt)
			{
				runMacro("C:\\Users\\machu\\Desktop\\Codes\\"+mac+".ijm");
				exit();
			}
		}
	else 
	{
		wait(1000);
	}
	}
}