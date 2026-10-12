package com.rev_creations.rcsite;

import java.io.IOException;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.maxmind.geoip.Location;
import com.maxmind.geoip.LookupService;
import com.maxmind.geoip.regionName;
import com.maxmind.geoip.timeZone;

public class LocationUtil {
	private static LookupService lookupService;
	private static SortedMap countryMap;
	private static int count ;

	private final static String[] countryCode = { "--", "AP", "EU", "AD", "AE",
			"AF", "AG", "AI", "AL", "AM", "AN", "AO", "AQ", "AR", "AS", "AT",
			"AU", "AW", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI",
			"BJ", "BM", "BN", "BO", "BR", "BS", "BT", "BV", "BW", "BY", "BZ",
			"CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN",
			"CO", "CR", "CU", "CV", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM",
			"DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FI", "FJ",
			"FK", "FM", "FO", "FR", "FX", "GA", "GB", "GD", "GE", "GF", "GH",
			"GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT", "GU", "GW",
			"GY", "HK", "HM", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IN",
			"IO", "IQ", "IR", "IS", "IT", "JM", "JO", "JP", "KE", "KG", "KH",
			"KI", "KM", "KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC",
			"LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD",
			"MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS",
			"MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF",
			"NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ", "OM", "PA", "PE",
			"PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW",
			"PY", "QA", "RE", "RO", "RU", "RW", "SA", "SB", "SC", "SD", "SE",
			"SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "ST",
			"SV", "SY", "SZ", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TM",
			"TN", "TO", "TL", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM",
			"US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF",
			"WS", "YE", "YT", "RS", "ZA", "ZM", "ME", "ZW", "A1", "A2", "O1",
			"AX", "GG", "IM", "JE", "BL", "MF" };

	private final static String[] countryName = { "N/A", "Asia/Pacific Region",
			"Europe", "Andorra", "United Arab Emirates", "Afghanistan",
			"Antigua and Barbuda", "Anguilla", "Albania", "Armenia",
			"Netherlands Antilles", "Angola", "Antarctica", "Argentina",
			"American Samoa", "Austria", "Australia", "Aruba", "Azerbaijan",
			"Bosnia and Herzegovina", "Barbados", "Bangladesh", "Belgium",
			"Burkina Faso", "Bulgaria", "Bahrain", "Burundi", "Benin",
			"Bermuda", "Brunei Darussalam", "Bolivia", "Brazil", "Bahamas",
			"Bhutan", "Bouvet Island", "Botswana", "Belarus", "Belize",
			"Canada", "Cocos (Keeling) Islands",
			"Congo, The Democratic Republic of the",
			"Central African Republic", "Congo", "Switzerland",
			"Cote D'Ivoire", "Cook Islands", "Chile", "Cameroon", "China",
			"Colombia", "Costa Rica", "Cuba", "Cape Verde", "Christmas Island",
			"Cyprus", "Czech Republic", "Germany", "Djibouti", "Denmark",
			"Dominica", "Dominican Republic", "Algeria", "Ecuador", "Estonia",
			"Egypt", "Western Sahara", "Eritrea", "Spain", "Ethiopia",
			"Finland", "Fiji", "Falkland Islands (Malvinas)",
			"Micronesia, Federated States of", "Faroe Islands", "France",
			"France, Metropolitan", "Gabon", "United Kingdom", "Grenada",
			"Georgia", "French Guiana", "Ghana", "Gibraltar", "Greenland",
			"Gambia", "Guinea", "Guadeloupe", "Equatorial Guinea", "Greece",
			"South Georgia and the South Sandwich Islands", "Guatemala",
			"Guam", "Guinea-Bissau", "Guyana", "Hong Kong",
			"Heard Island and McDonald Islands", "Honduras", "Croatia",
			"Haiti", "Hungary", "Indonesia", "Ireland", "Israel", "India",
			"British Indian Ocean Territory", "Iraq",
			"Iran, Islamic Republic of", "Iceland", "Italy", "Jamaica",
			"Jordan", "Japan", "Kenya", "Kyrgyzstan", "Cambodia", "Kiribati",
			"Comoros", "Saint Kitts and Nevis",
			"Korea, Democratic People's Republic of", "Korea, Republic of",
			"Kuwait", "Cayman Islands", "Kazakhstan",
			"Lao People's Democratic Republic", "Lebanon", "Saint Lucia",
			"Liechtenstein", "Sri Lanka", "Liberia", "Lesotho", "Lithuania",
			"Luxembourg", "Latvia", "Libyan Arab Jamahiriya", "Morocco",
			"Monaco", "Moldova, Republic of", "Madagascar", "Marshall Islands",
			"Macedonia", "Mali", "Myanmar", "Mongolia", "Macau",
			"Northern Mariana Islands", "Martinique", "Mauritania",
			"Montserrat", "Malta", "Mauritius", "Maldives", "Malawi", "Mexico",
			"Malaysia", "Mozambique", "Namibia", "New Caledonia", "Niger",
			"Norfolk Island", "Nigeria", "Nicaragua", "Netherlands", "Norway",
			"Nepal", "Nauru", "Niue", "New Zealand", "Oman", "Panama", "Peru",
			"French Polynesia", "Papua New Guinea", "Philippines", "Pakistan",
			"Poland", "Saint Pierre and Miquelon", "Pitcairn Islands",
			"Puerto Rico", "" + "Palestinian Territory", "Portugal", "Palau",
			"Paraguay", "Qatar", "Reunion", "Romania", "Russian Federation",
			"Rwanda", "Saudi Arabia", "Solomon Islands", "Seychelles", "Sudan",
			"Sweden", "Singapore", "Saint Helena", "Slovenia",
			"Svalbard and Jan Mayen", "Slovakia", "Sierra Leone", "San Marino",
			"Senegal", "Somalia", "Suriname", "Sao Tome and Principe",
			"El Salvador", "Syrian Arab Republic", "Swaziland",
			"Turks and Caicos Islands", "Chad", "French Southern Territories",
			"Togo", "Thailand", "Tajikistan", "Tokelau", "Turkmenistan",
			"Tunisia", "Tonga", "Timor-Leste", "Turkey", "Trinidad and Tobago",
			"Tuvalu", "Taiwan", "Tanzania, United Republic of", "Ukraine",
			"Uganda", "United States Minor Outlying Islands", "United States",
			"Uruguay", "Uzbekistan", "Holy See (Vatican City State)",
			"Saint Vincent and the Grenadines", "Venezuela",
			"Virgin Islands, British", "Virgin Islands, U.S.", "Vietnam",
			"Vanuatu", "Wallis and Futuna", "Samoa", "Yemen", "Mayotte",
			"Serbia", "South Africa", "Zambia", "Montenegro", "Zimbabwe",
			"Anonymous Proxy", "Satellite Provider", "Other", "Aland Islands",
			"Guernsey", "Isle of Man", "Jersey", "Saint Barthelemy",
			"Saint Martin" };

	private static void createCountryMap() {
        HashMap<String,String> map = new HashMap<String,String>(); 
        ValueComparator bvc =  new ValueComparator(map); 
		countryMap = new TreeMap(bvc);
		for (int i = 0; i < countryCode.length; i++) {
			map.put(countryCode[i], countryName[i]);
			//countryMap.put(countryCode[i], countryName[i]);

		}
		countryMap.putAll(map); 


	}

	/**
	 * @param session
	 * @param request
	 */
	public LocationUtil() {
		count=1;
		System.out.println("count::::::::"+count);
		try {
			if( lookupService==null){
			lookupService = new LookupService(
					Config.getValue("geocityfile"),
					LookupService.GEOIP_MEMORY_CACHE);
			}

		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("IO Exception");
		}
		createCountryMap();

	}
	/**
	 * @param session
	 * @param request
	 */
	public LocationUtil(boolean withLookUp) {

		createCountryMap();

	}
	public Location getLocation(String ip) {
		/*
		 * request.getCookies(); if(cookie ){ getlocation from databse; }else{
		 * from gioip; }
		 */
		Location location = new Location();
		// String ip =request.getRemoteAddr();

		try {
			// 68.212.190.142 206.190.37.53 174.95.45.7
			location = lookupService.getLocation(ip);
			System.out.println("get location ip: " + ip);
		} catch (Exception e) {
			System.out.println("Exception");
		}
		if (location == null) {
			location = new Location();
			location.countryCode = "CA";
			location.countryName = "Canada";
			location.region = "ON";
			location.city = "Toronto";

		}
		return location;
	}

	public static SortedMap getCountryMap() {
		return countryMap;
	}
	
	public static String getCountryName(String countryCode) {
		return (String)countryMap.get(countryCode);
	}

	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		LocationUtil locationUtil = new LocationUtil(false);
		HttpServletRequest request = null;
		// 82.128.84.44 174.95.45.7 216.89.80.101 216.89.80.101
		Location location = locationUtil.getLocation("216.89.80.101");
		String regionNamec = regionName.regionNameByCode("AE", "01");
		Iterator iterator = locationUtil.countryMap.keySet().iterator();

		while (iterator.hasNext()) {
			Object key = iterator.next();
			Object value = locationUtil.countryMap.get(key);
			System.out.println(key + " :" + value);
		}

	}

}

class ValueComparator implements Comparator { 
	 
	  Map base; 
	  public ValueComparator(Map base) { 
	      this.base = base; 
	  } 
	 
	  public int compare(Object a, Object b) { 
	 
		  return ((String)base.get(a)).compareTo((String)base.get(b));
	   /*
		  if((String)base.get(a)).compareTo((String)base.get(b))) { 
	      return 1; 
	    } else if((Double)base.get(a) == (Double)base.get(b)) { 
	      return 0; 
	    } else { 
	      return -1; 
	    } 
	    */
	  } 
	} 

