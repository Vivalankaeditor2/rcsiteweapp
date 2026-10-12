package com.rev_creations.rcsite;

import java.text.DecimalFormat;
import java.text.NumberFormat;

import com.maxmind.geoip.Location;

public class LocationBean{
	
	private Location location ;
	private String regionName;


	public LocationBean(Location location) {
		super();
		this.location = location;
		setRegionName();
	}

	public String getRegionName() {
		return regionName;
	}



	public void setRegionName() {
		if(location.region!=null){
			location.region = location.region.trim();
		
		
		 if (location.region.matches("((-|\\+)?[0-9]+(\\.[0-9]+)?)+")) {  
			 NumberFormat formatter = new DecimalFormat("##00");
			 int i = Integer.parseInt(location.region);
			 location.region= formatter.format(i);
		           
		   } 
		if(location.region!=null && !location.region.equalsIgnoreCase("0") && location.region.length()>0){
			this.regionName = com.maxmind.geoip.regionName.regionNameByCode(location.countryCode,location.region);
		}
		}else{
			this.regionName = "";
		}
	}

	public Location getLocation() {
		return location;
	}



	public void setLocation(Location location) {
		this.location = location;
	}



	public String getCountryCode() {
		return location.countryCode;
	}

	public String getCountryCodeLower() {
		if(location.countryCode!=null) {
			return location.countryCode.toLowerCase();
			}else {
				return "ca";
			}
	}

	public void setCountryCode(String countryCode) {
		location.countryCode = countryCode;
	}



	public String getCountryName() {
		return location.countryName;
	}



	public void setCountryName(String countryName) {
		location.countryName = countryName;
	}



	public String getRegion() {
		return location.region;
	}



	public void setRegion(String region) {
		location.region = region;
	}



	public String getCity() {
		return location.city;
	}



	public void setCity(String city) {
		location.city = city;
	}



	public String getPostalCode() {
		return location.postalCode;
	}



	public void setPostalCode(String postalCode) {
		location.postalCode = postalCode;
	}



	public float getLatitude() {
		return location.latitude;
	}



	public void setLatitude(float latitude) {
		location.latitude = latitude;
	}



	public float getLongitude() {
		return location.longitude;
	}



	public void setLongitude(float longitude) {
		location.longitude = longitude;
	}



	public int getDma_code() {
		return location.dma_code;
	}



	public void setDma_code(int dmaCode) {
		location.dma_code = dmaCode;
	}



	public int getArea_code() {
		return location.area_code;
	}



	public void setArea_code(int areaCode) {
		location.area_code = areaCode;
	}



	public int getMetro_code() {
		return location.metro_code;
	}



	public void setMetro_code(int metroCode) {
		location.metro_code = metroCode;
	}



	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

	
}
