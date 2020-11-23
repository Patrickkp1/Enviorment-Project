capture log close
log using "/Users/patrickpoleshuk/Downloads/Environmennt_Project_log.smcl", replace

import delimited "/Users/patrickpoleshuk/Downloads/API_NY.GDP.PCAP.CD_DS2_en_csv_v2_1120951 2/API_NY.GDP.PCAP.CD_DS2_en_csv_v2_1120951.csv", varnames(1) clear 

forvalues x=5(1)64{
local y= `x'+1955
rename v`x' GDP`y' 
}
drop v65 worlddevel~s v3 v4
rename ïdatasource countryname
reshape long GDP, i(countryname) j(year)
sort countryname year
save "/Users/patrickpoleshuk/Downloads/GDP.dta", replace

*------------------------

import delimited "/Users/patrickpoleshuk/Desktop/API_GB.XPD.RSDV.GD.ZS_DS2_en_csv_v2_1120937 (1)/API_GB.XPD.RSDV.GD.ZS_DS2_en_csv_v2_1120937.csv", varnames(1) clear 
forvalues x=5(1)64{
local y= `x'+1955
rename v`x' RD`y' 
}
drop v65 worlddevel~s v3 v4
rename ïdatasource countryname
reshape long RD, i(countryname) j(year)
sort countryname year
save "/Users/patrickpoleshuk/Downloads/RD.dta", replace
*------------------------

import delimited "/Users/patrickpoleshuk/Desktop/API_AG.PRD.LVSK.XD_DS2_en_csv_v2_1125343/API_AG.PRD.LVSK.XD_DS2_en_csv_v2_1125343.csv", varnames(1) clear 

forvalues x=5(1)64{
local y= `x'+1955
rename v`x' LIVESTOCK`y' 
}
drop v65 worlddevel~s v3 v4
rename ïdatasource countryname
reshape long LIVESTOCK, i(countryname) j(year)
sort countryname year
save "/Users/patrickpoleshuk/Downloads/LIVESTOCK.dta", replace

*------------------------
import delimited "/Users/patrickpoleshuk/Desktop/API_EG.ELC.FOSL.ZS_DS2_en_csv_v2_1125297 2/API_EG.ELC.FOSL.ZS_DS2_en_csv_v2_1125297.csv", varnames(1) clear 

forvalues x=5(1)64{
local y= `x'+1955
rename v`x' COAL`y' 
}
drop v65 worlddevel~s v3 v4
rename ïdatasource countryname
reshape long COAL, i(countryname) j(year)
sort countryname year
save "/Users/patrickpoleshuk/Downloads/COAL.dta", replace

*------------------------
import delimited "/Users/patrickpoleshuk/Downloads/API_EN.ATM.CO2E.KT_DS2_en_csv_v2_1120888/API_EN.ATM.CO2E.KT_DS2_en_csv_v2_1120888.csv", varnames(1) clear 

forvalues x=5(1)64{
local y= `x'+1955
rename v`x' CO2`y' 
}
drop v65 worlddevel~s v3 v4
rename ïdatasource countryname
reshape long CO2, i(countryname) j(year)
sort countryname year
save "/Users/patrickpoleshuk/Downloads/CO2.dta", replace

use  "/Users/patrickpoleshuk/Downloads/GDP.dta", clear
merge 1:1 countryname year using "/Users/patrickpoleshuk/Downloads/CO2.dta"
keep if _merge==3
drop _merge
merge 1:1 countryname year using "/Users/patrickpoleshuk/Downloads/RD.dta"
keep if _merge==3
drop _merge
merge 1:1 countryname year using "/Users/patrickpoleshuk/Downloads/LIVESTOCK.dta"
keep if _merge==3
drop _merge
merge 1:1 countryname year using "/Users/patrickpoleshuk/Downloads/COAL.dta"
keep if _merge==3
drop _merge

keep if countryname=="United States"

keep if year >= 1960
count if GDP!=. & CO2!=. & RD!=. & LIVESTOCK!=. & COAL!=.

save "/Users/patrickpoleshuk/Downloads/all.dta", replace

generate lnGDP = ln(GDP)
generate lnRD = ln(RD)
gen lnCOAL = ln(COAL)

reg CO2 lnGDP, r
display e(r2_a) 

predict Y_hat2
graph twoway (lfitci CO2 lnGDP) (scatter CO2 lnGDP)


reg CO2 lnGDP lnCOAL lnRD, r
display e(r2_a) 

* Note "LIVESTOCK" is not used in a multi-linear regression over problems with multicollinearity among other independent variables. 
reg CO2 LIVESTOCK, r
display e(r2_a) 


log close 






