#include "system.h"
#include "periphs.h"
#include <iob-uart.h>
#include "iob_timer.h"
#include "iob_knn.h"
#include "random.h" //random generator for bare metal

//uncomment to use rand from C lib
#define cmwc_rand rand

#ifdef DEBUG //type make DEBUG=1 to print debug info
#define S 12  //random seed
#define N 10  //data set sizecd
#define K 4   //number of neighbours (K)
#define C 4   //number data classes
#define M 4   //number samples to be classified
#else
#define S 12
#define N 100000
#define K 10
#define C 4
#define M 200
#endif

#define INFINITE ~0
#define SHORT_AND 65535
#define HW_Limit_TPoints 200 //200 para correr na placa, 50 para BASYS3

//
//Data structures
//

//labeled dataset
struct datum {
  int coord;
  unsigned char label;
} data[N], x[M];


///////////////////////////////////////////////////////////////////
int main() {

  unsigned long long elapsed;
  unsigned int elapsedu;

  //init uart and timer
  uart_init(UART_BASE, FREQ/BAUD);

  //read current timer count, compute elapsed time
  //elapsed  = timer_get_count();
  //elapsedu = timer_time_us();


  //int vote accumulator
  int votes_acc[C] = {0};

  //generate random seed
  random_init(S);

  //init dataset
  for (int i=0; i<N; i++) {

    //init coordinates
    short xx;
    short y;

    xx = (short) cmwc_rand();
    y = (short) cmwc_rand();
    data[i].coord = (unsigned int)(xx<<16) | (unsigned short)y;

    //init label
    data[i].label = (unsigned char) (cmwc_rand()%C);
  }

#ifdef DEBUG
  uart_printf("\n\n\nDATASET\n");
  uart_printf("Idx \tX \tY \tLabel\n");
  for (int i=0; i<N; i++)
    uart_printf("%d \t%d \t%d \t%d\n", i, data[i].coord>>16, data[i].coord & SHORT_AND, data[i].label);
#endif

  //init test points
  for (int k=0; k<M; k++) {
    short xx;
    short y;
    xx  = (short) cmwc_rand();
    y  = (short) cmwc_rand();
    x[k].coord = (unsigned int)(xx<<16) | (unsigned short)y;
    //x[k].label will be calculated by the algorithm
  }

#ifdef DEBUG
  uart_printf("\n\nTEST POINTS\n");
  uart_printf("Idx \tX \tY\n");
  for (int k=0; k<M; k++)
    uart_printf("%d \t%d \t%d\n", k, x[k].coord>>16, x[k].coord & SHORT_AND);
#endif

  //
  // PROCESS DATA
  //

  //start knn here

  uart_printf("\nInit timer\n");
  uart_txwait();

  timer_init(TIMER_BASE);
  knn_init(KNN_BASE);

  //for all test points
  //compute distances to dataset points

  for(int z=0; z < M; z = z + HW_Limit_TPoints){

  #ifdef DEBUG
      uart_printf("\n\nProcessing x[]:\n");
  #endif

      //init all k neighbors infinite distance
      knn_reset();

  #ifdef DEBUG
      uart_printf("Datum \tX \tY \tLabel \tDistance\n");
  #endif

      for(int k=0; k<M && k<HW_Limit_TPoints; k++){
        knn_set_TestP(x[k+z].coord, k);
      }
      knn_start();
      for (int i=0; i<N; i++) { //for all dataset points
        //compute distance to x[k]
        knn_set_DataP(data[i].coord, data[i].label);

  #ifdef DEBUG
        //dataset
        uart_printf("%d \t%d \t%d \t%d\n", i, data[i].coord>>16, data[i].coord & SHORT_AND, data[i].label/*, d*/);
  #endif

      }
      knn_stop();


      //classify test point

    for(int k=0; k<M && k<HW_Limit_TPoints; k++){
      //clear all votes
      int votes[C] = {0};
      int best_votation = 0;
      int best_voted = 0;

      #ifdef DEBUG
      uart_printf("\n\nNEIGHBORS of x[%d]=(%d, %d):\n", k, x[k].coord>>16, x[k].coord & SHORT_AND);
      uart_printf("K \tLabel\n");
      #endif

      //make neighbours vote
      for (int j=0; j<K; j++) { //for all neighbors
        int vote = knn_read_Label(j, k+z, 10);
        //if ( (++votes[data[neighbor[j].idx].label]) > best_votation ) {
        if ( (++votes[vote]) > best_votation ) {
          //best_voted = data[neighbor[j].idx].label;
          best_voted = vote;
          best_votation = votes[best_voted];
        }
        #ifdef DEBUG
          uart_printf("%d \t%d\n", j+1, vote);
        #endif
      }
      x[k+z].label = best_voted;
      votes_acc[best_voted]++;
    }

  #ifdef DEBUG
      uart_printf("\n\nCLASSIFICATION of x[]:\n");
      uart_printf("X \tY \tLabel\n");
      //uart_printf("%d \t%d \t%d\n\n\n", x[k].x, x[k].y, x[k].label);
  #endif
  }

  //all test points classified

  //stop knn here
  //read current timer count, compute elapsed time
  elapsedu = timer_time_us(TIMER_BASE);
  uart_printf("\nExecution time: %dus @%dMHz\n\n", elapsedu, FREQ/1000000);


  //print classification distribution to check for statistical bias
  for (int l=0; l<C; l++)
    uart_printf("%d ", votes_acc[l]);
  uart_printf("\n");

}
