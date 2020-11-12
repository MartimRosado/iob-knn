#include "interconnect.h"
#include "iob_knn.h"
#include "KNNsw_reg.h"

//base address
static int base;

void knn_reset(){
  IO_SET(base, KNN_RESET, 1);
  IO_SET(base, KNN_RESET, 0);
}

void knn_init(int base_address){
  base = base_address;
  knn_reset();
}

void knn_set_TestP(unsigned int coordinate){
  IO_SET(base, KNN_A, coordinate);
}

int knn_dist_DataP(unsigned int coordinate){
  IO_SET(base, KNN_B, coordinate);
  return (unsigned int) IO_GET(base, KNN_DIST);
}
