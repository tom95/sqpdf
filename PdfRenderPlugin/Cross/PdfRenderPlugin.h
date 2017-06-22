#include "sq.h"

uint num_pages(char *filename, int str_len);
int render_page(char *filename, int str_len, int page_num, int dpi, sqInt *bmStride, sqInt *bmWidth, sqInt *bmHeight, sqInt *bmDepth, const unsigned char **buffer);
char *text_of_page(char *filename, int str_len, int page_num, int x, int y, int w, int h);
