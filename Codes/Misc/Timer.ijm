getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
//Create Dialog Box
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
				print ("Ca y est ça marche");
				exit();
			}
		}
	else 
	{
		wait(1000);
	}
	}
}