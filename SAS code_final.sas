***THIS IS THE PROGRAM FOR PAPER 1 OF MY DISSERTATION IN WHICH I ASSESS
The effect of restrictions on provider access in insurance plans on healthcare expenditures and assess if it varies among plan types.
FOR THIS PROJECT, I USE MEPS 2013 AND 2014 DATA.
FIRST 2013.***;

/* 1) We first need to import the MEPS 2013 full year consoldiated data file*/

LIBNAME Table1 "H:\Eline's_H-drive_CU_Anschutz\Dissertation\Dissertation Papers\Paper 1 - MEPS IV model\SAS code";                                                             
FILENAME INTable1 "H:\Eline's_H-drive_CU_Anschutz\Dissertation\Dissertation Papers\Paper 1 - MEPS IV model\MEPS data\2013\H163.SSP";                           
                                                                                                    
PROC XCOPY IN=INTable1 OUT=Table1 IMPORT;                                                           
RUN;  

/* 2) To check the different variables in the data set and explore some of the observations, we do a proc contents and/or proc print*/

proc print data=table1.h163 (obs=20);
title "Look what consolidated file 2013 looks like";
run;

proc contents data=Table1.H163;     
title "List of Variables in MEPS 2013 Consolidated File";     
run;

/* 3) Inclusion and Exclusion criteria: ages <18 and 65+, (early) retired people */

/* May 2017: Now also includes amount of visits/days and charges, not only expenditures*/

/* 3a) Exluce age groups*/

data new (keep = DUPERSID PERWT13F varstr varpsu
/*all relevant variables from SAQ*/ ADHECR42 ADHOPE42 ADILCR42 ADILWW42 ADINSA42 ADINSB42 ADINTR42 ADOVER42 ADRISK42 ADRTWW42 K6SUM42 PHQ242

/*ALL TOTAL EXPENDITURES*/ TOTEXP13 TOTTCH13
/*for Inpatient Hospital Stays, incl facility charges*/  IPTEXP13 IPNGTD13 IPTTCH13
/*for Emergency Room: dr exp, fac exp and total*/ ERTEXP13 ERTOT13 ERTTCH13
/*for Medications, exp and total prescitpions/refills*/ RXEXP13 RXTOT13

/*for (Outpatient) Office-Based doctors exp*/ OBDEXP13 OBDRV13 OBDTCH13 OBVEXP13 OBVTCH13
/*for total Ambulatory care*/ AMAEXP13 AMASST13 AMATCH13
/*for total Outpatient provider*/ OPDEXP13 OPDRV13 OPDTCH13
/*for total Outpatient facility*/ OPFEXP13 OPFTCH13
/*for total Outpatient physician expenses*/ OPSEXP13 OPSTCH13
/*for total Outpatient facility AND doctor exp*/ OPTEXP13 OPTOTV13 OPTTCH13 OPVEXP13 OPVTCH13
/*total outpatient non-dr facility*/ OPOEXP13 OPOTHV13 OPOTCH13
/*total outpatient non-dr doctor*/ OPPEXP13 OPPTCH13

/*physician assistant OB+OT*/
AMAEXP13 /*TOTL AMBULTRY (OB+OP) PHYS ASS T EXP 13*/
AMASST13 /* # PHYSICIAN ASS T VSTS (OFF+OUPAT), 2013*/
AMATCH13 /*PHYS ASS T AMBULATORY VISIT CHARGES 13*/

/*nurse practitioner OB+OT*/
AMNEXP13 /*TOTL AMBULTRY (OB+OP) NURSE/PRAC EXP 13*/
AMNURS13 /* # AMB NURSE/PRCTITIONR VSTS(OB+OP) 13*/
AMNTCH13 /*NRS/PRAC AMBULATORY VISIT CHARGES 13*/

/*should be part of the above 2 categories */
OBAEXP13 /*TOTAL OFF-BASED PHYS ASS T EXP 13*/
OBASST13 /*# OFF-BASED PHYSICIAN ASSIST VISITS 13*/
OBATCH13 /*OFFICE-BASED PHYS ASST VISIT CHARGES 13*/

OBNEXP13 /*TOTAL OFF-BASED NURSE/PRAC 13*/
OBNURS13 /*# OFF-BASED NURSE/PRACTITIONER VISITS 13*/
OBNTCH13 /*OFFICE-BASED NURSE/PRAC VISIT CHARGES 13*/

/*MD visits OB*/
OBDEXP13 /*TOTAL OFF-BASED DR EXP 13*/
OBDRV13 /*# OFFICE-BASED PHYSICIAN VISITS 13*/
OBDTCH13 /*OFFICE-BASED PHYSICIAN VISIT CHARGES 13*/

/*MD visits OP*/
OPSEXP13 /*TOTAL OUTPATIENT PHYSICIAN - DR EXP 13*/
OPVEXP13 /*TOTAL OUTPATIENT PHYSICIAN - FAC EXP 13*/
OPDRV13 /*# OUTPATIENT DEPT PHYSICIAN VISITS 13*/
OPTTCH13 /*OPD FACILITY + DR VISIT CHARGES – 13*/

/*choice of health insurance offered*/ OFFER53X HELD53X OFREMP53
/*had insurance*/ INS13X INSURC13 UNINS13
/*uninsured*/ PRVEV13 
/*any private*/ PRIV13 /*ever had private ins in 13*/ PRVEV13
/*date of birth*/ DOBMM DOBYY
/*demographics, educ etc*/ SEX ADSMOK42 RACETHX REGION13 AGE13X AGE31X AGE42X AGE53X MARRY13X POVCAT13 FAMINC13 FAMS1231 FAMWT13F EDUYRDG HISPANX HISPCAT HRWG31X HRWG42X HRWG53X
/*retired*/ EVRETIRE
/*health status, incl mental*/ MNHLTH31 MNHLTH42 MNHLTH53 RTHLTH31 RTHLTH42 RTHLTH53
/*firm size*/ NUMEMP53
/*covered by HMO, non-plan dr NOT covered*/ PRVHMO13
/*covered by privins with drs list (ppo/epo), non-plan dr NOT covered*/ PRVDRL42
/*covered by gatekeeper, non-plan dr NOT covered*/ PRVMNC42
/*covered by HMO, non-plan dr covered*/ PHMONP42 PHMONP31
/*covered by privins with drs list (ppo/epo), non-plan dr covered*/ PRDRNP42
/*covered by gatekeeper, non-plan dr covered*/  PMNCNP42

/*covered by employed/union paid plan*/ PRIEU13
/*additional prescription drug insurance*/ PMEDIN31 PMEDIN42 PMEDIN53
/*covered by self-ins*/ PRIS13 SELFCM53 
/*covered by any public at any time during 2013*/ PUBAP13X)

;
set table1.h163;

	 /* EXCLUDE age groups for children and 65+*/
	 if age13x<18 then delete;
	 if age13x>64 then delete;
run;

proc freq data=new;
tables PRIEU13;
run;

proc freq data=new;
tables OFREMP53;
run;

/* 3b) Exclude early retired*/
data new1;
set new;
/* (early) RETIRED PEOPLE*/
	 if evretire=1 then delete;
run;

proc freq data=new1;
tables PRIEU13;
run;

proc freq data=new1;
tables OFREMP53;
run;

/* 3c) Exclude the uninsured (those uninsured all throughout 2013)*/
data new2;
set new1;
if UNINS13=1 then delete;
run;

/* 3d) Exclude those who never had any private insurance during 2013*/
data new3;
set new2;
	 if PRIV13=2 or PRIV13=-1 then delete;
run;

proc freq data=new3;
tables PRIEU13;
run;

proc freq data=new2;
tables OFREMP53;
run;

/* 3d) Exclude self-insured and self-employed*/
data new4;
set new3;
/* Self-employed can be considered uninsured in context of this study*/
	 if SELFCM53 =1 then delete; 

	 /* Covered by Self-Emp-Ins: unclear what this means, uninsured?*/
	if PRIS13=1 then delete; 
run;

proc freq data=new4;
tables PRIEU13;
run;

proc freq data=new4;
tables OFREMP53;
run;

/* June 7: make sure that there's no overlapping expenditure categories*/
data new4x;
set new4;
if AMNURS13>0;
run;

proc print data=new4x;
var dupersid 
OBAEXP13 /*TOTAL OFF-BASED PHYS ASS T EXP 13*/
OBASST13 /*# OFF-BASED PHYSICIAN ASSIST VISITS 13*/
OBATCH13 /*OFFICE-BASED PHYS ASST VISIT CHARGES 13*/
AMAEXP13 /*TOTL AMBULTRY (OB+OP) PHYS ASS T EXP 13*/
AMASST13 /* # PHYSICIAN ASS T VSTS (OFF+OUPAT), 2013*/
AMATCH13 /*PHYS ASS T AMBULATORY VISIT CHARGES 13*/;
run;

/* Same for nurse practitioner*/
data new4xy;
set new4;
if AMNURS13>0;
run;

proc print data=new4xy;
var dupersid 
/*nurse practitioner OB+OT*/
AMNEXP13 /*TOTL AMBULTRY (OB+OP) NURSE/PRAC EXP 13*/
AMNURS13 /* # AMB NURSE/PRCTITIONR VSTS(OB+OP) 13*/
AMNTCH13 /*NRS/PRAC AMBULATORY VISIT CHARGES 13*/
OBNEXP13 /*TOTAL OFF-BASED NURSE/PRAC 13*/
OBNURS13 /*# OFF-BASED NURSE/PRACTITIONER VISITS 13*/
OBNTCH13 /*OFFICE-BASED NURSE/PRAC VISIT CHARGES 13*/;
run;

/* Note June 7: it seems that indeed ambulatory care for NP and PA include the OB-variables already, so get rid of OB variables for NP and PA>*/
/*should be part of the above 2 categories */
data new4xyz (drop=OBAEXP13 OBASST13 OBATCH13 OBNEXP13 OBNURS13 OBNTCH13);
set new4;
run; 

/* 4) Create all insurance categories */

/* 4a) First create insurance categories*/

data cov1;
set new4xyz;
if PHMONP42=-9 or PHMONP42=2 then incat=1;
else if PHMONP42=1 then incat=2;
else if PMNCNP42=-9 or PMNCNP42=2 then incat=3;
else if PMNCNP42=1 then incat=4;
else if PRDRNP42=-9 or PRDRNP42=2 then incat=5;
else if PRDRNP42=1 then incat=6;
run;

proc freq data=cov1;
tables incat;
run;

/* 4b) Get rid of missing values */

data cov2;
set cov1;
if incat=. then delete;
run;

proc freq data=cov2;
tables incat;
title "Look at insurance categories";
run;

proc print data=cov2 (obs=100);
var dupersid incat;
title "Look at insurance categories";
run;

/* 4c) Now, we create a binary variable for whether care outside the network is covered yes/no */

data cov3;
set cov2;
if incat=2 or incat=4 or incat=6 then coverage=1;
else coverage=0;

proc freq data=cov3;
tables coverage;
run;

/* 4d) Create variables for HMO vs. Gatekeeper vs. PPO/otherpriv*/

data cov4;
set cov3;
if incat=1 or incat=2 then SHMO=1;
else SHMO=0;
if incat=3 or incat=4 then GKPOS=1;
else GKPOS=0;
if incat=5 or incat=6 then PPOpriv=1;
else PPOpriv=0;
run;

proc freq data=cov4;
tables incat coverage SHMO GKPOS PPOpriv;
title "Look at insurance categories";
run;

/* 4e) Create dummy variables for the 6 insurance category variables*/

data cov5;
set cov4;
if incat=1 then SHMO_no=1;
else SHMO_no=0;
run;

proc freq data=cov5;
tables shmo_no;
run;

data cov6;
set cov5;
if incat=2 then SHMO_yes=1;
else SHMO_yes=0;
if incat=3 then GKPOS_no=1;
else GKPOS_no=0;
if incat=4 then GKPOS_yes=1;
else GKPOS_yes=0;
if incat=5 then PPOpriv_no=1;
else PPOpriv_no=0;
if incat=6 then PPOpriv_yes=1;
else PPOpriv_yes=0;
run;
 
/* Checks! */
proc freq data=cov6;
tables incat coverage SHMO_no SHMO_yes GKPOS_no GKPOS_yes PPOpriv_no PPOpriv_yes;
title "Look at insurance categories";
run;

proc print data=cov6 (obs=100);
var dupersid coverage incat SHMO GKPOS PPOpriv SHMO_no SHMO_yes GKPOS_no GKPOS_yes PPOpriv_no PPOpriv_yes;
title "Look at insurance categories";
run;

*** 5) Now, we want to import the 2013 Medical Conditions file ***;

LIBNAME Table1 "H:\Eline's_H-drive_CU_Anschutz\Dissertation\Dissertation Papers\Paper 1 - MEPS IV model\SAS code";                                                             
FILENAME MedCon "H:\Eline's_H-drive_CU_Anschutz\Dissertation\Dissertation Papers\Paper 1 - MEPS IV model\MEPS data\2013\H162.SSP";                                           
                                                                                                    
PROC XCOPY IN=MedCon OUT=Table1 IMPORT;                                                           
RUN;  

proc print data=table1.h162 (obs=20);
title "Look what MedCon file 2013 looks like";
run;

proc contents data=table1.h162 ;
run;

/* 6) Below we pull out people with specific conditions to run interactions later.
Select the diseases: ASTHMA, RESP INFECTIONS, ESSENTIAL HYPERTENSION, DIABETES, BREAST CANCER, AMI AND SPRAINS/STRAINS;*/

data conditions;
set table1.h162(keep=dupersid varstr varpsu perwt13f hhnum ipnum opnum obnum ernum rxnum cccodex icd9codx);
run;

data cond2013;
set conditions;
if cccodex="128" then asthma=1;
else asthma=0;
if cccodex="049" then diabetes=1;
else diabetes=0;
if cccodex="100" then AMI=1;
else AMI=0;
if cccodex="232" then sprains=1;
else sprains=0;
if cccodex="098" then hypert=1;
else hypert=0;
if cccodex="024" then brcancer=1;
else brcancer=0;
if cccodex="126" then othresp=1;
else othresp=0;
run;

proc print data=cond2013 (obs=20);
run;

*** 7) There are some people with more than 1 observation. 
Different events could be tied to each line, so we need to collapse to one obs per person ***;

proc sql;
create table col2013 as
select distinct dupersid, icd9codx, varstr, varpsu, perwt13f, cccodex, asthma, diabetes, AMI, sprains, hypert, brcancer, othresp,
sum(hhnum) as hhnum,
sum(ipnum) as ipnum,
sum(opnum) as opnum,
sum(obnum) as obnum,
sum(ernum) as ernum,
sum(rxnum) as rxnum
from cond2013
group by dupersid
order by dupersid;
quit;

proc freq data=col2013;
tables ipnum;
run;

data col2013_2;
set col2013;
outall=opnum+obnum;
run;

proc freq data=col2013_2;
tables outall;
run;

proc freq data=col2013;
tables opnum obnum;
run;

proc freq data=col2013;
tables ernum;
run;


proc freq data=col2013;
tables rxnum;
run;


*** 8) Sort to be able to merge the main file and the conditions file***;

PROC SORT data=cov6;
by DUPERSID;
run;

PROC SORT data=col2013 nodupkey; 
by DUPERSID;
run;

*** Link those patients to the main consolidated file by merging***;

data condition13; 
merge col2013  cov6 (in=a);
by dupersid;
if a=1 ;
run;

proc print data=condition13 (obs=20);
run;

*** 9a) Now we select the variables we need for the analysis***;

data select2013 (keep = 
/* Variables from conditions file*/ dupersid cccodex icd9codx hhnum ipnum opnum obnum ernum rxnum  asthma diabetes AMI sprains hypert brcancer othresp
/* Insurance variables*/ coverage incat SHMO GKPOS PPOpriv SHMO_no SHMO_yes GKPOS_no GKPOS_yes PPOpriv_no PPOpriv_yes

/* Outcome Variables: */
/*ALL TOTAL EXPENDITURES*/ TOTEXP13 TOTTCH13
/*for Emergency Room: dr exp, fac exp and total*/ ERTEXP13 ERTOT13 ERTTCH13
/*for Medications, exp and total prescitpions/refills*/ RXEXP13 RXTOT13
/*for Inpatient Hospital Stays, incl facility charges*/  IPTEXP13 IPNGTD13 IPTTCH13 

/*physician assistant OB+OT*/
AMAEXP13 /*TOTL AMBULTRY (OB+OP) PHYS ASS T EXP 13*/
AMASST13 /* # PHYSICIAN ASS T VSTS (OFF+OUPAT), 2013*/
AMATCH13 /*PHYS ASS T AMBULATORY VISIT CHARGES 13*/

/*nurse practitioner OB+OT*/
AMNEXP13 /*TOTL AMBULTRY (OB+OP) NURSE/PRAC EXP 13*/
AMNURS13 /* # AMB NURSE/PRCTITIONR VSTS(OB+OP) 13*/
AMNTCH13 /*NRS/PRAC AMBULATORY VISIT CHARGES 13*/

/*MD visits OB*/
OBDEXP13 /*TOTAL OFF-BASED DR EXP 13*/
OBDRV13 /*# OFFICE-BASED PHYSICIAN VISITS 13*/
OBDTCH13 /*OFFICE-BASED PHYSICIAN VISIT CHARGES 13*/

/*MD visits OP*/
OPSEXP13 /*TOTAL OUTPATIENT PHYSICIAN - DR EXP 13*/
OPVEXP13 /*TOTAL OUTPATIENT PHYSICIAN - FAC EXP 13*/
OPDRV13 /*# OUTPATIENT DEPT PHYSICIAN VISITS 13*/
OPTTCH13 /*OPD FACILITY + DR VISIT CHARGES – 13*/

/* Covered by employed/union paid plan -> instrument?*/ PRIEU13 OFREMP53
/* SAQ: risk aversion variable -> instrument?*/ ADRISK42

/* SAQ: CAN OVERCOME ILLS WITHOUT MED HELP*/ ADOVER42
/* SAQ: 12 MOS: GOT CARE WHEN NEEDED ILL/INJ*/ ADILWW42
/* SAQ: 12MOS: ILL/INJURY NEEDING IMMED CARE*/ ADILCR42 
/* SAQ: DO NOT NEED HEALTH INSURANCE*/ ADINSA42
/* SAQ: HEALTH INSURANCE NOT WORTH COST */ ADINSB42 

/* Individual characteristics and survey weights*/ age13x sex racethx marry13x region13 adsmok42 MNHLTH53 RTHLTH53 eduyrdg faminc13 FAMS1231 FAMWT13F povcat13 perwt13f varstr varpsu);
set condition13;
run;

/* Now rename the OUTCOME variables*/

data select2013x;
set select2013;
rename TOTEXP13=TotExp;
rename TOTTCH13=TotCharExRx;
rename ERTEXP13=EDexp;
rename ERTOT13=EDvis;
rename ERTTCH13=EDchar;
rename RXEXP13=RXexp;
rename RXTOT13=RXcount;
rename IPTEXP13=InpExp;
rename IPNGTD13=InpVis;
rename IPTTCH13=InpChar;

rename AMAEXP13=OutPAexp; 
rename AMASST13=OutPAvis;
rename AMATCH13=OutPAchar;
rename AMNEXP13=OutNPexp;
rename AMNURS13=OutNPvis;
rename AMNTCH13=OutNPchar; 
rename OBDEXP13=OutOBMDexp;
rename OBDRV13=OutOBMDvis;
rename OBDTCH13=OutOBMDchar;
rename OPSEXP13=OutOPMDExpDr;
rename OPVEXP13=OutOPMDExpFa;
rename OPDRV13=OutOPMDvis;
rename OPTTCH13=OutOPMDchar;

OutOPMDExpT = OPSEXP13 + OPVEXP13;

OutAllMDExp = OutOPMDExpT + OBDEXP13;
OutAllMDVis = OBDRV13 + OPDRV13;
OutAllMDchar = OBDTCH13 + OPTTCH13;

OutAllExp= AMAEXP13 + AMNEXP13 + OutAllMDExp;
OutAllVis= AMASST13 + AMNURS13 + OutallMDVis;
OutAllChar= AMATCH13 + AMNTCH13 + OutAllMDchar;

run;

/* Clean up
data select2013xy (drop= TOTEXP13 TOTTCH13 ERTEXP13 ERTOT13 ERTTCH13 RXEXP13 RXTOT13 IPTEXP13 IPNGTD13
 IPTTCH13 AMAEXP13 AMASST13 AMATCH13 AMNEXP13 AMNURS13 AMNTCH13 OBDEXP13 OBDRV13 OBDTCH13 OPSEXP13
 OPVEXP13 OPDRV13 OPTTCH13 OPSEXP13  OPVEXP13 OBDEXP13 OBDRV13 OPDRV13 OBDTCH13 OPTTCH13
AMAEXP13  AMNEXP13 
AMASST13  AMNURS13 
AMATCH13  AMNTCH13);
set select2013x;
run; */

proc print data=select2013x (obs=20);
title "Check 2013 sample with all variables";
run;

proc contents data=select2013x;
run;

/* 9b) Check if zero night stays are part of all inpatient stays

data select2013x;
set select2013;
if IPZERO13>0;
run;

There are 15 observations with zero night stays
proc print data=select2013x;
var dupersid ipzero13 ZIDEXP13 ZIFEXP13 IPNGTD13 IPTEXP13 ;
run;

9c) Check if non-MD visits are part of OB exp varaibales

data select2013xy;
set select2013;
if OBCHIR13>0;
run;

There are 480 observations with chiro visits
proc print data=select2013xy;
var dupersid OBCEXP13 OBCHIR13 OBVEXP13 OBDRV13 ;
run;

9d) Check if PA visits are part of OB exp variables

data select2013xyz;
set select2013;
if AMASST13>0;
run;

There are 334 observations with PA visits
proc print data=select2013xyz;
var dupersid AMAEXP13 AMASST13 OBVEXP13 OBDRV13 OPTEXP13 OPTOTV13;
run;
AM variables are part of the OBVEXP13 but not visits and not OPT-variable

9e) Another ambulatory check

data select2013abc;
set select2013;
if AMNURS13 >0;
run;

There are 334 observations with PA visits
proc print data=select2013abc;
var dupersid AMNEXP13 AMNURS13  OBVEXP13 OBDRV13 OPTEXP13 OPTOTV13;
run;
*/

*** 10) Now, we also delete negative values for the dependent and independent variables. 
The other invalid values for covariates will be set to missing. 
This way we get to keep all potential observations in our base sample, even if we change any covariates 
in the models. Once we run the regression model it will only run on complete data and ignore the missing values.***;

data complete2013 ;
set select2013x;

***first we delete obs which have a negative value***;
if TotExp<0 then delete;
if TotCharExRx <0 then delete;
if OutOBMDvis <0 then delete;
if OutOBMDchar <0 then delete;
if OutOBMDexp <0 then delete;
if OutOPMDchar  <0 then delete;
if OutOPMDvis <0 then delete;
if OutOPMDExpFa <0 then delete;
if OutOPMDExpDr  <0 then delete;
if OutNPvis<0 then delete;
if  OutNPchar <0 then delete;
if  OutNPexp <0 then delete;
if OutPAvis <0 then delete;
if OutPAexp <0 then delete;
if EDvis <0 then delete;
if EDchar<0 then delete;
if EDexp<0 then delete;
if InpExp <0 then delete;
if InpChar <0 then delete;
if InpVis <0 then delete;
if OutPAchar<0 then delete;
if RXcount<0 then delete;
if RXexp<0 then delete;
if OutOPMDExpT<0 then delete;
if OutAllMDExp<0 then delete;
if OutAllMDVis<0 then delete;
if OutAllMDchar<0 then delete;
if OutAllExp<0 then delete;
if OutAllVis<0 then delete;
if OutAllChar <0 then delete;

***now we create dummies for some covariates***;
IF ADSMOK42 =1 THEN Smoker=1;
ELSE Smoker=0;

***now we set negative values for covariates to missing - not delete because we want to run stats on full sample***;
if age13x <0 then age13x =.;
if sex <0 then sex =.;
if racethx <0 then racethx =.;
if marry13x <0 then marry13x=.;
if region13 <0 then region13=.;
if MNHLTH53 <0 then MNHLTH53=.;
if RTHLTH53 <0 then RTHLTH53=.;
if EDUYRDG <0 then EDUYRDG=.;
if faminc13 <0 then faminc13=.;
if fams1231<0 then fams1231=.;
if povcat13 <0 then povcat13=.;

IF ADRISK42 <0 THEN ADRISK42=.;
if ADINSB42 <0 then ADINSB42=.;
if ADINSA42 <0 then ADINSA42=.;
if SELFCM53  <0 then SELFCM53 =.;
if PRIEU13 <0 then  PRIEU13=.;
if OFREMP53<0 then OFREMP=.;
if PRIS13 <0 then PRIS13=.;
if NUMEMP53 <0 then NUMEMP53=.;
if ADHECR42 <0 then ADHECR42=.;
if ADOVER42 <0 then ADOVER42=.;
if ADILCR42 <0 then ADILCR42=.;
if ADILWW42 <0 then ADILWW42=.;
if ADRTWW42  <0 then ADRTWW42 =.;
 
run;

proc print data=complete2013 (obs=20);
title "Final sample from 2013";
run;


***11) In 2013, there are 7,284 observations with one of the conditions enrolled in private insurance/managed care and aged 18-64. 
We want to find out how many of these observations actually have any healthcare utilization, 
to be able to see the difference between self-reported disease and treatment prevalence.
We create a dummy for utilization.***;

data util2013;
set complete2013;
UTIL= (hhnum>0 or ipnum>0 or opnum>0 or obnum>0 or ernum>0 or rxnum>0); 
***Create a dummy variable UTIL for any healthcare utilization to find if observations had any health care utilization in 2013 for their condition***;
LABEL UTIL="HAD ANY HEALTHCARE UTILIZATION FOR CONDITION";
run;

***check***;
proc print data=util2013 (obs=20);
where util>0;
title "Look for any utilization for patients";
run;

proc freq data=util2013;
tables util;
run;

proc freq data=util2013;
tables obnum;
run;

/* 70.22% of observations had any utilization in 2013*/

/* 12) Clean some more data*/
data clean (drop=hhnum ipnum opnum obnum ernum rxnum racethx marry13x);
 set util2013;
 if RACEthx = 2 then Race = 1;
 else if RACEthx = 3 then Race = 2;
 else if racethx=4 then Race=3;
else if racethx=1 then Race=4;
else Race = 5;
 if MARRY13X = 1 then Married = 1;
 else Married = 0;
 if SEX=2 then Female=1;
 else Female=0;
if 0<=eduyrdg<=3 then Educyr=1;
else if eduyrdg=4 then Educyr=2;
else if 5<=eduyrdg<=8 then Educyr=3;
else if eduyrdg=9 then Educyr=4;
rename fams1231=Famsize;
rename AGE13X=Age;
rename REGION13=Region;
rename FAMINC13=Familinc;
rename POVCAT13=IncFPL;
rename RTHLTH53=Healthst;
rename MNHLTH53=Mentalhlt;
rename ADILCR42=Needimmcar;
rename ADILWW42=Gotcarneed;
rename ADRTWW42=Gotapptwant;
rename ADHECR42=Ratehltcare;
rename ADINSA42=Needins;
rename ADINSB42=Nothworth;
rename ADRISK42=Morelrisk;
rename ADOVER42=Whoutmedhlp;
rename NUMEMP53=Firmsize;
rename OFREMP53=Emploffers;
rename PRIEU13=Paidfor;
 run;

 /*check*/
 proc print data=clean (obs=20);
 run;
  
 proc contents data=clean;
 run;

/* 13) Clean some more*/

data clean1 (keep= dupersid VARSTR VARPSU PERWT13F CCCODEX ICD9CODX Famsize Region Age Healthst Mentalhlt Needimmcar Gotcarneed 
Needins Nothworth Morelrisk Whoutmedhlp Familinc IncFPL Emploffers Paidfor TotCharExRx 
TotExp OutOBMDvis OutOBMDchar OutOBMDexp OutOPMDchar OutOPMDvis OutOPMDExpFa OutOPMDExpDr 
OutNPvis OutNPchar OutNPexp OutPAvis OutPAchar   EDvis EDchar EDexp InpExp InpChar 
InpVis RXcount RXexp incat coverage SHMO GKPOS PPOpriv SHMO_no SHMO_yes GKPOS_no GKPOS_yes 
PPOpriv_no PPOpriv_yes OutOPMDExpT OutAllMDExp OutAllMDVis OutAllMDchar OutAllExp OutAllVis 
OutAllChar OutPAexp Smoker UTIL Race Married Female Educyr);
set clean;
run;

/*Check*/
proc print data=clean1 (obs=20);
title "Check final variables for analysis";
run;

proc contents data=clean1;
title "Check final variables for analysis";
run;

proc print data=clean1 (obs=200);
var TotExp EDexp RXExp InpExp OutAllExp OutPAexp OutNPexp OutAllMDExp;
run;


/* 14) include Charlson variable for Risk Adjustment*/

/* 14a) Consolidated dataset*/

proc sql;
 create table consol1 as
 select DUPERSID, VARSTR, VARPSU, PERWT13F, CCCODEX, ICD9CODX, Famsize, Region, Age, Healthst, Mentalhlt, Needimmcar ,
Gotcarneed, Needins, Nothworth, Morelrisk, Whoutmedhlp, Familinc, IncFPL, Emploffers, Paidfor , TotCharExRx, TotExp ,
OutOBMDvis, OutOBMDchar, OutOBMDexp ,OutOPMDchar, OutOPMDvis ,OutOPMDExpFa, OutOPMDExpDr ,OutNPvis ,
OutNPchar ,OutNPexp, OutPAvis ,OutPAchar ,OutPAexp, EDvis ,EDchar ,EDexp ,InpExp ,InpChar, InpVis ,RXcount ,
RXexp ,incat ,coverage, SHMO ,GKPOS, PPOpriv ,SHMO_no, SHMO_yes, GKPOS_no, GKPOS_yes ,PPOpriv_no, PPOpriv_yes,
OutOPMDExpT ,OutAllMDExp ,OutAllMDVis ,OutAllMDchar, OutAllExp ,OutAllVis ,OutAllChar, Smoker ,UTIL ,Race, Married, 
Female , Educyr 
 from clean1
  order by DUPERSID;
quit;

/* 14b) CONDITIONS*/

data charl;
 set clean1;
 if CCCODEX = "657" then mood = 1;
 else mood = 0;
 format mood 1.;
/*Charlson comorbidity index*/;
 If ICD9CODX in ("410", "411") then myoc = 1;
 else myoc = 0;
 format myoc 1.;
 if ICD9CODX in ("398", "402", "428") then cong = 1;
 else cong = 0;
 format cong 1.;
 if "440" <= ICD9CODX <= "447" then peri = 1;
 else peri = 0;
 format peri 1.;
 if ICD9CODX in ("290", "291", "294") then deme = 1;
 else deme = 0;
 format deme 1.;
 if ICD9CODX in ("430", "431", "432", "433", "435") then cere = 1;
 else cere = 0;
 format cere 1.;
 if "491" <= ICD9CODX <= "493" then chro = 1;
 else chro = 0;
 format chro 1.;
 if ICD9CODX in ("710", "714", "725") then conn = 1;
 else conn = 0;
 format conn 1.;
 if "531" <= ICD9CODX <= "534" then ulce = 1;
 else ulce = 0;
 format ulce 1.;
 if ICD9CODX in ("571", "573") then mild = 1;
 else mild = 0;
 format mild 1.;
 if ICD9CODX in ("342", "434", "436", "437") then hemi = 1;
 else hemi = 0;
 format hemi 1.;
 if ICD9CODX in ("403", "404") or "580" <= ICD9CODX <= "586"
 then rena = 1;
 else rena = 0;
 if ICD9CODX in ("250") then diab = 1;
 else diab = 0;
 format diab 1.;
 if "140" <= ICD9CODX <= "195" then tumo = 1;
 else tumo = 0;
 format tumo 1.;
 if "204" <= ICD9CODX <= "208" then leuk = 1;
 else leuk = 0;
 format leuk 1.;
 if ICD9CODX in ("200", "202", "203") then lymp = 1;
 else lymp = 0;
 format lymp 1.;
 if ICD9CODX in ("070", "570", "572") then live = 1;
 else live = 0;
 format live 1.;
 if "196" <= ICD9CODX <= "199" then meta = 1;
 else meta = 0;
 format meta 1.;
run;

proc sql;
 create table charl2 as
 select DUPERSID,
max(mood) as mood format=1.,
max(myoc) as myoc format=1.,
max(cong) as cong format=1.,
max(peri) as peri format=1.,
max(deme) as deme format=1.,
max(cere) as cere format=1.,
max(chro) as chro format=1.,
max(conn) as conn format=1.,
max(ulce) as ulce format=1.,
max(mild) as mild format=1.,
max(hemi) as hemi format=1.,
max(rena) as rena format=1.,
max(diab) as diab format=1.,
max(tumo) as tumo format=1.,
max(leuk) as leuk format=1.,
max(lymp) as lymp format=1.,
max(live) as live format=1.,
max(meta) as meta format=1.
 from charl
 group by DUPERSID;
quit;

data charl3;
 set charl2;
 CCI = 1*(myoc + cong + peri + deme + cere + chro + conn + ulce + mild) +
 2*(hemi + rena + diab + tumo + leuk + lymp) +
 3*(live) +
 6*(meta);
 format CCI 2.;
run;

/* 14c) Merging*/

proc sql;
 create table analysis as
 select 
A.DUPERSID, 
A.VARSTR, 
A.VARPSU, 
A.PERWT13F, 
A.Famsize, 
A.Region, 
A.Age, 
A.Healthst, 
A.Mentalhlt, 
A.Needimmcar ,
A.Gotcarneed, 
A.Needins, 
A.Nothworth, 
A.Morelrisk, 
A.Whoutmedhlp, 
A.Familinc, 
A.IncFPL, 
A.TotCharExRx, 
A.TotExp ,
A.OutOBMDvis, 
A.OutOBMDchar, 
A.OutOBMDexp ,
A.OutOPMDchar, 
A.OutOPMDvis ,
A.OutOPMDExpFa, 
A.OutOPMDExpDr ,
A.OutNPvis ,
A.OutNPchar ,
A.OutNPexp, 
A.OutPAvis ,
A.OutPAchar ,
A.OutPAexp, 
A.EDvis ,
A.EDchar ,
A.EDexp ,
A.InpExp ,
A.InpChar, 
A.InpVis ,
A.RXcount ,
A.RXexp ,
A.incat ,
A.coverage, 
A.SHMO ,
A.GKPOS, 
A.PPOpriv ,
A.SHMO_no, 
A.SHMO_yes, 
A.GKPOS_no, 
A.GKPOS_yes ,
A.PPOpriv_no, 
A.PPOpriv_yes,
A.OutOPMDExpT ,
A.OutAllMDExp ,
A.OutAllMDVis ,
A.OutAllMDchar, 
A.OutAllExp ,
A.OutAllVis ,
A.OutAllChar, 
A.Smoker ,
A.UTIL ,
A.Race, 
A.Married, 
A.Female , 
A.Educyr,
A.Emploffers,
A.Paidfor, 

B.mood,
B.myoc,
B.cong,
B.peri,
B.deme,
B.cere,
B.chro,
B.conn,
B.ulce,
B.mild,
B.hemi,
B.rena,
B.diab,
B.tumo,
B.leuk,
B.lymp,
B.live,
B.meta,
B.CCI

 from consol1 as A left join charl3 as B on A.DUPERSID = B.DUPERSID
 order by A.DUPERSID;
quit;

proc print data=analysis;
where CCI>0;
run;

/* 14d) MISSING VALUES ARE 0*/
data analysis2;
 set analysis;
 if mood = . then mood = 0;
 if myoc = . then myoc = 0;
 if cong = . then cong = 0;
 if peri = . then peri = 0;
 if deme = . then deme = 0;
 if cere = . then cere = 0;
 if chro = . then chro = 0;
 if conn = . then conn = 0;
 if ulce = . then ulce = 0;
 if mild = . then mild = 0;
 if hemi = . then hemi = 0;
 if rena = . then rena = 0;
 if diab = . then diab = 0;
 if tumo = . then tumo = 0;
 if leuk = . then leuk = 0;
 if lymp = . then lymp = 0;
 if live = . then live = 0;
 if meta = . then meta = 0;
 if CCI = . then CCI = 0;
run;

/* Check data including CCI per observation*/
proc print data=analysis2 (obs=20);
var dupersid cci;
title "Check obs incl CCI variable";
run;

PROC CONTENTS data=analysis2;
run;

/* 15) Assign a few labels for analysis in STATA*/

data finaldata (drop = mood myoc cong peri deme cere chro conn ulce mild hemi rena diab tumo leuk lymp live meta);
set analysis2;
rename incat=Insur;
rename coverage=NetwOpen;
if Emploffers<0 then Emploffers=.;
run;

proc freq data=finaldata;
tables Emploffers Paidfor ;
run;

proc contents data=finaldata;
run;

data finaldata1;
set finaldata;
LABEL CCI="CHARLESON COMORBIDITY INDEX";
LABEL Female="SEX OF PATIENT IS FEMALE";
LABEL Race="RACE OF THE PATIENT";
LABEL Married="MARITAL STATUS BY END OF YEAR (EDITED/IMPUTED)";
LABEL Region="CENSUS REGION BY END OF YEAR";
LABEL Smoker="SAQ: CURRENTLY SMOKE";
LABEL Healthst="SELF ASSESSED HEALTH STATUS SOME TIME DURING YEAR";
LABEL Educyr="YEARS OF EDUCATION WHEN FIRST ENTERED MEPS";
LABEL Familinc="FAMILY TOTAL INCOME";
LABEL IncFPL="FAMILY INC AS % OF POVERTY LINE"; 

/*Insurance variables*/
LABEL GKPOS= "MANAGED CARE PLAN, NON-STAFF MODEL HMO, WITH GATEKEEPER (POS-LIKE)";    
LABEL GKPOS_no= "MANAGED CARE TYPE PLAN WITH GATEKEEPER, NO CARE OUTSIDE NETWORK"; 
LABEL GKPOS_yes= "MANAGED CARE TYPE PLAN WITH GATEKEEPER, COVER CARE OUTSIDE NETWORK";    
LABEL PPOpriv   = "OTHER PRIVATE PLAN WITH DRS LIST, PPO-LIKE";
LABEL PPOpriv_no = "OTHER PRIVATE, NO CARE OUTSIDE NETWORK";   
LABEL PPOpriv_yes ="OTHER PRIVATE, COVERS CARE OUTSIDE NETWORK";
LABEL SHMO   = "STAFF-MODEL TYPE HMO PLAN";
LABEL SHMO_no =  "STAFF HMO, NO CARE OUTSIDE NETWORK";
LABEL SHMO_yes ="STAFF HMO, COVERS CARE OUTSIDE NETWORK";
LABEL NetwOpen = "HAS PLAN THAT COVERS CARE OUTSIDE NETWORK";
LABEL Insur= "INSURANCE CATEGORY, 6 LEVELS";

/*potential instruments*/
LABEL Emploffers ="EMPLOYER OFFERS HEALTH INS ";
LABEL Paidfor="COVERED BY EMPL/UNION";

/*outcome variables*/
LABEL TotExp="TOTAL HEALTH CARE EXPENDITURES";
LABEL TotCharExRx="TOTAL CHARGES EX DRUGS";
LABEL OutOBMDvis="OFFICE-BASED MD VISITS";
LABEL OutOBMDchar="OFFICE-BASED MD CHARGES";
LABEL OutOBMDexp="OFFICE-BASED MD TOTAL EXPENDITURES";
LABEL OutOPMDchar="OUTPATIENT MD CHARGES";
LABEL OutOPMDvis="OUTPATIENT MD VISITS";
LABEL OutOPMDExpFa="OUTPATIENT MD EXPENDITURES FOR FACILITY";
LABEL OutOPMDExpDr="OUTPATIENT MD EXPENDITURES FOR DOCTOR";
LABEL OutNPvis="OUTPATIENT NURSE PRACTITIONER VISITS OB+OP";
LABEL OutNPchar="OUTPATIENT NURSE PRACTITIONER CHARGES OB+OP";
LABEL OutNPexp="OUTPATIENT NURSE PRACTITIONER TOTAL EXPENDITURES OB+OP";
LABEL OutPAvis="OUTPATIENT PHYSICIAN ASSISTANT VISITS OB+OP";
LABEL OutPAexp="OUTPATIENT PHYSICIAN ASSISTANT TOTAL EXPENDITURES OB+OP";
LABEL EDvis="EMERGENCY DEPARTMENT VISITS";
LABEL EDchar="EMERGENY DEPARTMENT CHARGES";
LABEL EDexp="EMERGENCY DEPARTMENT TOTAL EXPENDITURES";
LABEL InpExp="INPATIENT TOTAL EXPENDITURES";
LABEL InpChar="INPATIENT CHARGES";
LABEL InpVis="INPATIENT VISITS";
LABEL OutPAchar="OUTPATIENT PHYSICIAN ASSISTANT CHARGES";
LABEL RXcount="NUMBER OF DRUGS DISPENSED";
LABEL RXexp="DRUGS TOTAL EXPENDITURES";
LABEL OutOPMDExpT="OUTPATIENT MD TOTAL EXPENDITURES FAC+DR";
LABEL OutAllMDExp="ALL OUTPATIENT MD TOTAL EXPENDITURES OB+OP";
LABEL OutAllMDVis="ALL OUTPATIENT MD VISITS OB+OP";
LABEL OutAllMDchar="ALL OUTPATIENT MD CHARGES OB+OP";
LABEL OutAllExp="ALL OUTPATIENT TOTAL EXPENDITURES MD+PA+NP";
LABEL OutAllVis="ALL OUTPATIENT VISITS MD+PA+NP";
LABEL OutAllChar="ALL OUTPATIENT CHARGES MD+PA+NP";

rename perwt13f=perwgt;
RUN;

/*CHECK*/
PROC PRINT DATA=FINALDATA1 (OBS=10);
TITLE "CHECK FINAL DATASET FOR ANLYSIS";
RUN;

PROC CONTENTS DATA=FINALDATA1;
RUN;

ods graphics on;

proc univariate  data=finaldata1 ;
histogram;
var outallvis;
run;







/* 17)SUMMARY STATISTICS, TABLE 1, UNWEIGHTED - NOT applying weights for the statistics part*/

/* Main independent variables*/

Proc freq data = FINALDATA1 ;
Tables Insur;
title 'Check Ins category divide';
Run;

Proc freq data = FINALdata1 ;
Tables NetwOpen;
title 'Check coverage/network divide';
Run;



data finaldata2;
set finaldata1;
if needins=. then needins=6;
if netwopen=1 then Closed=0;
else if netwopen=0 then Closed=1;
run;


Proc freq data = FINALdata2 ;
Tables closed;
title 'Check coverage/network divide';
Run;

Proc freq data = FINALdata2 ;
Tables SHMO*closed;
title 'Check SHMO divide';
Run;

Proc freq data = FINALdata2 ;
Tables GKPOS*closed;
title 'Check GKPOS divide';
Run;

Proc freq data = FINALdata2 ;
Tables PPOpriv*closed;
title 'Check PPOpriv divide';
Run;

/* 18) WE WILL NOW CONSTRUCT THE DESCRIPTIVES TABLE (NOT ASSIGNING THE WEIGHTS BECAUSE WE WILL BE DESCRIBING THE 
DATA NOT THE POPULATION) WE WILL NOT USE THE CLUSTERS AND STRATA TO CORRECT FOR THE COMPLEX SURVEY DESIGN. 

Covariates: Mean age, Mean family income, Mean family size, Female, Smoker, Married, CCI>0, Health Status, 
Race/Ethn, Region country, Education */

/*age*/
proc means data=FINALdata2 MEAN STDERR;
var age;
where closed=0;
title 'Check mean age for non-Netw enrollees';
run;

proc means data=FINALdata2 MEAN STDERR;
var age;
where closed=1;
title 'Check mean age for Netw enrollees';
run;

proc means data=FINALdata2 MEAN STDERR;
var age;
title 'Check mean age';
run;

proc ttest data=FINALdata2 plots=summary;
class closed;
var age;
run;

/*faminc*/
proc means data=FINALdata2 MEAN STDERR;
var familinc;
where closed=0;
title 'Check mean familinc for non-Netw enrollees';
run;

proc means data=FINALdata2 MEAN STDERR;
var familinc;
where closed=1;
title 'Check mean familinc for Netw enrollees';
run;

proc means data=FINALdata1 MEAN STDERR;
var familinc;
title 'Check mean familinc';
run;

proc ttest data=FINALdata2 plots=summary;
class NetwOpen;
var familinc;
run;

/*famsize*/
proc means data=FINALdata2 MEAN STDERR;
var famsize;
where closed=0;
title 'Check mean famsize for non-Netw enrollees';
run;

proc means data=FINALdata2 MEAN STDERR;
var famsize;
where closed=1;
title 'Check mean famsize for Netw enrollees';
run;

proc means data=FINALdata2 MEAN STDERR;
var famsize;
title 'Check mean famsize';
run;

proc ttest data=FINALdata2 plots=summary;
class closed;
var famsize;
run;

/*FEMALE*/

Proc freq data = FINALdata2 ;
Tables FEMALE*Closed/chisq ;
title 'Check gender by coverage status';
Run;

/*SMOKER*/

Proc freq data = FINALdata2 ;
Tables Smoker*closed /chisq ;
title 'Check smoking status by coverage status';
Run;

/*Married*/

Proc freq data = FINALdata2 ;
Tables Married*closed /chisq ;
title 'Check marital status by coverage status';
Run;

/*CCI*/ 

data finaldata3;
set finaldata2;
if cci=1 or cci=2 or cci=3 or cci=4 then ccii=1;
else ccii=0;
run;

Proc freq data = FINALdata3 ;
Tables ccii*closed /chisq ;
title 'Check CCI by coverage status';
Run;

/*Healthst*/ 

Proc freq data = FINALdata3 ;
Tables Healthst*closed /chisq ;
title 'Check healthst by coverage status';
Run;

/*Race*/

Proc freq data = FINALdata3 ;
Tables Race*closed /chisq ;
title 'Check race by coverage status';
Run;

/*Region*/ 

Proc freq data = FINALdata3 ;
Tables Region*closed /chisq ;
title 'Check region by coverage status';
Run;

/*Educyr*/

Proc freq data = FINALdata3 ;
Tables Educyr*closed /chisq ;
title 'Check Educyr by coverage status';
Run;


/*More likely to take risks then others*/
Proc freq data = FINALdata3 ;
Tables morelrisk*closed /chisq ;
title 'Check morelrisk by coverage status';
Run;

/*More likely to take risks then others*/
Proc freq data = FINALdata3 ;
Tables needins*closed /chisq ;
title 'Check morelrisk by coverage status';
Run;



/* 20) GO TO STATA!!!!

Transform the temporary data set that includes all data steps above into permanent data set AND
export to stata.*/


LIBNAME Final "H:\Eline's_H-drive_CU_Anschutz\Dissertation\Dissertation Papers\Paper 1 - MEPS IV model";  
data Final.analysisfinal4;
set finaldata3;
run; 

Proc export data=Final.analysisfinal4
dbms=stata
outfile="H:\Eline's_H-drive_CU_Anschutz\Dissertation\Dissertation Papers\Paper 1 - MEPS IV model\analysisfinal8.dta"
replace;
run;


***we can run the analysis in stata now.***;









