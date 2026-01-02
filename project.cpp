$PARAM
TVCL   = 7.95,  // L/h
TVV    = 190,   // L 
TVka   = 0.17,  // 1/h

$CMT DEPOT CENT cAUC // 1-compartmental model with absorption

$INPUT BW = 38 // kg, covariate which has effect on PK parameters

$MAIN
double BWEffCL = 0.75    ; // BW effect on CL
double BWEffV  = 1       ; // BW effect on V
double BWEffka = -(0.25) ; // BW effect on ka

double CL  = TVCL * pow((BW/70),BWEffCL) * exp(ETA(1)); // power function for scaling
double V   = TVV  * pow((BW/70),BWEffV)               ;
double ka  = TVka * pow((BW/70),BWEffka)              ;

double k10 = CL/V ; 

$OMEGA
0.1415863641 // CV_CL = 39%

$SIGMA
0.0974896213 // EPS(1)
0.0324       // EPS(2)

$ODE
dxdt_DEPOT   = -(ka) * DEPOT                 ;
dxdt_CENT    =  (ka) * DEPOT  - (k10) * CENT ;
dxdt_cAUC    =                  CENT/V       ;

$TABLE 
double IPRED  = CENT/V                        ; 
double DV     = IPRED * (1+EPS(1)) + EPS(2)   ;
double BWsim  = BW                            ;

$CAPTURE
IPRED DV
