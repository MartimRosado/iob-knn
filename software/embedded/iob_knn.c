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

void knn_set_value_A(unsigned int coordinate){
  IO_SET(base, KNN_A, coordinate);
}

void knn_set_value_B(unsigned int coordinate){
  IO_SET(base, KNN_B, coordinate);
}

int knn_read_distance(){
  return (unsigned int) IO_GET(base, KNN_DIST);
}
