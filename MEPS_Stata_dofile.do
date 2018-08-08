/* Do file for Dissertation paper 1, September 2017*/

/*clear previous results*/
clear all
/*close log file in case it is open*/
capture log close

/*keep log*/
log using "C:\Users\Eline van den Broek\Dissertation\log100417_v4" 

/*retrieve the data*/
use "H:\Eline's_H-drive_CU_Anschutz\Dissertation\Dissertation Papers\Paper 1 - MEPS IV model\analysisfinal9.dta", clear

set more off

/*THIS IS THE CODE FOR THE MEPS 2013 DATA ANALYSIS OF THE EFFECT OF RESTRICTIONS ON PROVIDER ACCESS
ON HEALTH CARE EXPENDITURES.

TWO NOTES ON MAY 31ST - IN THIS ANALYSIS, I WILL INCLUDE;
1) Since analysis will be based on the Anderson Model of Health Care Utilization, I will run
sub-analysis where one sub-sample will include a subsample on perceived need and one sub-sample based on actual need (health status and CCI)
to study if the results are significantly different among the sicker patients or those who believe 
they need more health care services and compare results. 
2) Include count variable for numbers of visits to look at whether downward spending 
is a consequence of selective contracting. If the number of visits is the same, we can conclude 
that prices are lower. If no of visits is higher in open network plans than higher spending 
is due to more visits because people can shop around more.
*/

summarize
describe


/* ESTIMATE THE COUNT MODELS FOR THE VISITS*/

/*Outpatient*/
 xi: zinb outallvis netwopen female smoker married i.healthst ccii i.race i.region i.educyr age familinc famsize needins needins_missing healthst_missing educyr_missing, inf(netwopen female smoker married i.healthst ccii i.race i.region i.educyr age famsize familinc) vuong

 /*ZIP*/
 xi: zip outallvis netwopen female smoker married i.healthst ccii i.race i.region i.educyr age familinc famsize needins, inf(netwopen female smoker married i.healthst ccii i.race i.region i.educyr age famsize familinc) vuong
 
 /*Inpatient*/
 xi: zinb inpvis netwopen female smoker married i.healthst ccii i.race i.region i.educyr age familinc famsize needins, inf(netwopen female smoker married i.healthst ccii i.race i.region i.educyr age famsize familinc) vuong

 /*ZIP*/
 xi: zip inpvis netwopen female smoker married i.healthst ccii i.race i.region i.educyr age familinc famsize needins, inf(netwopen female smoker married i.healthst ccii i.race i.region i.educyr age famsize familinc) vuong
 
 /*ED*/
 xi: zinb edvis netwopen female smoker married i.healthst ccii i.race i.region i.educyr age familinc famsize needins, inf(netwopen female smoker married i.healthst ccii i.race i.region i.educyr age famsize familinc) vuong
 
 /*ZIP*/
 xi: zip edvis netwopen female smoker married i.healthst ccii i.race i.region i.educyr age familinc famsize , inf(netwopen female smoker married i.healthst ccii i.race i.region i.educyr age famsize familinc) vuong
 
 /*RX*/
 xi: zinb rxcount netwopen female smoker married i.healthst ccii i.race i.region i.educyr age familinc famsize needins, inf(netwopen female smoker married i.healthst ccii i.race i.region i.educyr age famsize familinc) vuong
 
 /*ZIP*/
 xi: zip rxcount netwopen female smoker married i.healthst ccii i.race i.region i.educyr age familinc famsize needins, inf(netwopen female smoker married i.healthst ccii i.race i.region i.educyr age famsize familinc) vuong
 
 * FOR ALL COUNT MODELS THE ZERO-INFLATED NEGATIVE BINOMIAL SEEMS THE BEST FIT

/*Outpatient*/
xi: zinb outallvis netwopen female smoker married i.healthst ccii i.race i.region i.educyr age familinc famsize i.needins needins_missing healthst_missing educyr_missing, inf(netwopen female smoker married i.healthst ccii i.race i.region i.educyr age famsize familinc needins) vuong
est store zinb_outpvis
 
/*Inpatient*/
xi: zinb inpvis netwopen female smoker married i.healthst ccii i.race i.region i.educyr age familinc famsize i.needins needins_missing healthst_missing educyr_missing, inf(netwopen female smoker married i.healthst ccii i.race i.region i.educyr age famsize familinc needins) vuong iter(100)
est store zinb_inpvis

/*ED - first a test of Overdispersion*/
xi: quietly poisson edvis netwopen female smoker married i.healthst ccii i.race i.region i.educyr age familinc famsize i.needins needins_missing healthst_missing educyr_missing, vce(robust)
predict muhat, n
quietly generate ystar = ((edvis-muhat)^2-edvis)/muhat
regress ystar muhat, noconstant noheader
/*there is significant overdispersion*/

xi: zinb edvis netwopen female smoker married i.healthst ccii i.race i.region i.educyr age familinc famsize i.needins needins_missing healthst_missing educyr_missing, inf(netwopen female smoker married i.healthst ccii i.race i.region i.educyr age famsize familinc needins) vuong iter(100)
est store zinb_edvis

/*RX*/
xi: zinb rxcount netwopen female smoker married i.healthst ccii i.race i.region i.educyr age familinc famsize i.needins needins_missing healthst_missing educyr_missing, inf(netwopen female smoker married i.healthst ccii i.race i.region i.educyr age famsize familinc) vuong
est store zinb_rxcount


esttab zinb_outpvis zinb_inpvis zinb_edvis zinb_rxcount using "H:\Eline's_H-drive_CU_Anschutz\Dissertation\Dissertation Papers\Paper 1 - MEPS IV model\zinb_all5.rtf", cells(b(star fmt(4) label(Coef.)) se(par fmt(4) label(std.errors))) starlevels( * 0.05 ** 0.01 *** 0.001) stats(N r2, labels ("No. of Obs.""R-Squared"))

 
/* Estimate the GLM and TPM models*/

ssc install tpm

tab totexp

/*Total expenditure GAMMA*/

xi: tpm totexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize i.needins needins_missing healthst_missing educyr_missing shmo gkpos , first(probit) second(glm, fam(gamma) link(log))
margins, dydx(*) post

xi: glm totexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize i.needins shmo gkpos , link(log) fam(gamma)
margins, dydx(*) post


/*Outpatient expenditure POISSON*/

xi: tpm outallexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize i.needins shmo gkpos , first(probit) second(glm, fam(poisson) link(log))
margins, dydx(*) post

xi: glm outallexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize i.needins shmo gkpos , link(log) fam(poisson)
margins, dydx(*) post


/*Inpatient expenditure POISSON*/

xi: tpm inpexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize i.needins shmo gkpos , first(probit) second(glm, fam(poisson) link(log))
margins, dydx(*) post

xi: glm inpexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize i.needins shmo gkpos , link(log) fam(poisson)
margins, dydx(*) post

/*ED expenditure GAMMA*/

xi: tpm edexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize i.needins shmo gkpos , first(probit) second(glm, fam(gamma) link(log))
margins, dydx(*) post

xi: glm edexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize i.needins shmo gkpos , link(log) fam(gamma)
margins, dydx(*) post

/*RX expenditure POISSON*/

xi: tpm rxexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize i.needins shmo gkpos , first(probit) second(glm, fam(poisson) link(log))
margins, dydx(*) post

xi: glm rxexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize i.needins shmo gkpos , link(log) fam(poisson)
margins, dydx(*) post



/*OUTPATIENT subcategories*/
/*MD expenditure*/
glm outallmdexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize shmo gkpos , link(log) fam(poisson)
margins, dydx(*) post

/*Nurse pract expenditure*/
glm outnpexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize shmo gkpos , link(log) fam(gamma)
margins, dydx(*) post

/*PA expenditure*/
glm outpaexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize shmo gkpos , link(log) fam(gamma)
margins, dydx(*) post


/*NOW ALL FINAL MODELS*/


xi: tpm totexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc shmo gkpos i.needins , first(probit) second(glm, fam(gamma) link(log))
est store totexp

margins, dydx(*) post

est store totexp2


xi: tpm outallexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc shmo gkpos i.needins , first(probit) second(glm, fam(poisson) link(log))
est store outallexp

margins, dydx(*) post

est store outallexp2


xi: tpm inpexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc shmo gkpos i.needins , first(probit) second(glm, fam(poisson) link(log))
est store inpexp

margins, dydx(*) post

est store inpexp2





xi: tpm edexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc shmo gkpos i.needins , first(probit) second(glm, fam(gamma) link(log))
est store edexp

margins, dydx(*) post

est store edexp2



xi: tpm rxexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc shmo gkpos i.needins , first(probit) second(glm, fam(poisson) link(log))
est store rxexp

margins, dydx(*) post

est store rxexp2


esttab totexp totexp2  using "H:\Eline's_H-drive_CU_Anschutz\Dissertation\Dissertation Papers\Paper 1 - MEPS IV model\exp_total_2.rtf", cells(b(star fmt(4) label(Coef.)) se(par fmt(4) label(std.errors))) starlevels( * 0.05 ** 0.01 *** 0.001) stats(N r2, labels ("No. of Obs.""R-Squared"))

 
/*NOW the SUB-categories for outpatient care*/

xi: tpm outallmdexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize i.needins shmo gkpos , first(probit) second(glm, fam(poisson) link(log))
est store outMD
margins, dydx(*) post

est store outMD2


xi: tpm outnpexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize i.needins shmo gkpos , first(probit) second(glm, fam(gamma) link(log))
est store outNP
margins, dydx(*) post

est store outNP2


xi: tpm outpaexp netwopen female smoker married ccii i.healthst i.race i.region i.educyr age familinc famsize i.needins shmo gkpos , first(probit) second(glm, fam(poisson) link(log))
est store outPA
margins, dydx(*) post

est store outPA2


esttab outMD  outMD2 outNP outNP2 outPA outPA2 using "H:\Eline's_H-drive_CU_Anschutz\Dissertation\Dissertation Papers\Paper 1 - MEPS IV model\outpatientcats_8.rtf", cells(b(star fmt(4) label(Coef.)) se(par fmt(4) label(std.errors))) starlevels( * 0.10 ** 0.05 *** 0.01) stats(N r2, labels ("No. of Obs.""R-Squared"))

