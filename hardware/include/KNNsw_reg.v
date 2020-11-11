//START_TABLE sw_reg
`SWREG_W(KNN_RESET,          1, 0) //Timer soft reset
`SWREG_W(KNN_ENABLE,         1, 0) //Timer enable
`SWREG_W(KNN_A,            32, 0) //Point A
`SWREG_W(KNN_B,            32, 0) //Point B
`SWREG_R(KNN_DIST,         32, 0) //Distance between A and B
