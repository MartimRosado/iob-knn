#pragma once

//Functions
void knn_reset();
void knn_start();
void knn_stop();
void knn_init(int base_address);
void knn_set_TestP(unsigned int coordinate);
void knn_set_DataP(unsigned int coordinate, char label);
char knn_read_Label(unsigned int offset);
