//START_TABLE sw_reg
`SWREG_W(KNN_RESET,          1, 0) //Timer soft reset
`SWREG_W(KNN_ENABLE,         1, 0) //Timer enable
`SWREG_W(KNN_A,         DATA_W, 0) //Point A
`SWREG_W(KNN_B,         DATA_W, 0) //Point B
`SWREG_R(KNN_DIST,      DATA_W, 0) //Distance between A and B