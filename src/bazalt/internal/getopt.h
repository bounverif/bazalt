#ifndef BAZALT_GETOPT_H
#define BAZALT_GETOPT_H

#include <getopt.h>

static const char* bz_app_short_options = "hv:c:";
static struct option bz_app_long_options[] = {
  {"help", no_argument, 0, 'h'},
  {"config", optional_argument, 0, 'c'},
  {"verbose", no_argument, 0, 'v'},
  {0, 0, 0, 0}};

#endif  // BAZALT_GETOPT_H
