#include "system.h"
#include "periphs.h"
#include <iob-uart.h>
#include "iob_timer.h"
#include "iob_knn.h"
#include "random.h" //random generator for bare metal

//uncomment to use rand from C lib
//#define cmwc_rand rand

#define S 12  //random seed
#define N 100  //data set size

///////////////////////////////////////////////////////////////////
int main() {

  int max;
  int gen;

  //init uart and timer
  uart_init(UART_BASE, FREQ/BAUD);

  //generate random seed
  random_init(S);

  //init dataset
  for (int i=0; i<N; i++) {
    gen = cmwc_rand();
    if(i==0) max = gen;
    if(gen > max){
      max = gen;
    }
    uart_printf("\nIteration %d: %d\n", i+1, gen);
    uart_txwait();
  }

  uart_printf("\nMax number: %d\n", max);
  uart_txwait();

}
