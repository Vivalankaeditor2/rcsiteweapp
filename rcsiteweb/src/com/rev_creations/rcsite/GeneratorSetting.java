package com.rev_creations.rcsite;

import java.util.Calendar;
import java.util.Date;

public class GeneratorSetting {
	public int limit;
	public int interval;
	public Date nextTime;
	
	public GeneratorSetting(int limit, int interval, Date nextTime ) {
		super();
		this.interval = interval;
		this.nextTime = nextTime;
		this.limit = limit;
		
	}
	
	public GeneratorSetting(int limit, int interval ) {
		super();
		this.interval = interval;
		this.nextTime = Calendar.getInstance().getTime();
		this.limit = limit;

		
	}
	public int getInterval() {
		return interval;
	}

	public void setInterval(int interval) {
		this.interval = interval;
	}

	public Date getNextTime() {
		return nextTime;
	}

	public void setNextTime(Date nextTime) {
		this.nextTime = nextTime;
	}

	public int getLimit() {
		return limit;
	}

	public void setLimit(int limit) {
		this.limit = limit;
	}





	
	
}
