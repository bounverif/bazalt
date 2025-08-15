#ifndef BAZALT_COMMON_H
#define BAZALT_COMMON_H

#include <tomlc17.h>

typedef struct bz_logging_context {
  int logging_level;
  int logging_use_color;
} bz_logging_context;

typedef struct bz_tomlconf_context {
  char name[BAZALT_NAME_MAX];
  char config_file[BAZALT_NAME_MAX];
  char config_path[BAZALT_PATHNAME_MAX];
  toml_datum_t* data;
} bz_tomlconf_context;

bz_logging_context* bz_logging_context_get(void);
bz_tomlconf_context* bz_tomlconf_context_get(void);

#endif  // BAZALT_COMMON_H
