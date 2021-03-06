//START_TABLE sw_reg
`SWREG_W(KNN_RESET,          1, 0) //KNN soft reset
`SWREG_W(KNN_ENABLE,         1, 0) //KNN enable
`SWREG_W(KNN_B,         DATA_W, 0) //Point B coordinates
`SWREG_W(KNN_LABEL,     LABEL,  0) //Point B label
`SWREG_BANKR(KNN_INFO,  LABEL,  0, 2000) //Register Bank of the neighbours' Labels
`SWREG_BANKW(KNN_A,     DATA_W, 0, 200) // Point A coordinates Bank
