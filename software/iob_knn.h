#pragma once

//Functions
void knn_reset();
void knn_start();
void knn_stop();
void knn_init(int base_address);
void knn_set_value_A(unsigned int coordinate);
void knn_set_value_B(unsigned int coordinate);
int knn_read_distance();
