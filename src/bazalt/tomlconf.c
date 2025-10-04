#include <stdlib.h>
#include <string.h>

#include <bazalt/bazalt.h>
#include <bazalt/logging.h>
#include <bazalt/tomlconf.h>

#include "bazalt/internal/common.h"
#include "bazalt/internal/getopt.h"

// Logging singleton
static bz_tomlconf_context g_tomlconf_context = {0, 0, 0, 0};

bz_tomlconf_context* bz_tomlconf_context_get(void)
{
  return &g_tomlconf_context;
}

bz_status bz_tomlconf_init(bz_config_options* options)
{
  if(!options)
    return BZ_ERR_INVALID_ARG;

  bz_tomlconf_context* ctx = bz_tomlconf_context_get();

  strncpy(ctx->name, options->name, sizeof(ctx->name) - 1);
  ctx->name[sizeof(ctx->name) - 1] = '\0';

  strncpy(ctx->config_file, options->config_file, sizeof(ctx->config_file) - 1);
  ctx->config_file[sizeof(ctx->config_file) - 1] = '\0';

  strncpy(ctx->config_path, options->config_path, sizeof(ctx->config_path) - 1);
  ctx->config_path[sizeof(ctx->config_path) - 1] = '\0';

  ctx->data = NULL;

  return BZ_OK;
}

bz_status bz_tomlconf_load_config_file(const char* path);
bz_status bz_tomlconf_load_env_var(const char* name, const char* dest);
bz_status bz_tomlconf_load_config_file(const char* path);

bz_status bz_tomlconf_parse_args(int argc, char** argv)
{
  int opt;
  bz_tomlconf_context* ctx = bz_tomlconf_context_get();
  if(!ctx)
    return BZ_ERR_INTERNAL;

  /* getopt loop */
  while((opt = getopt(argc, argv, "c:h")) != -1) {
    switch(opt) {
      case 'c': /* Config file */
        strncpy(ctx->config_file, optarg, sizeof(ctx->config_file) - 1);
        ctx->config_file[sizeof(ctx->config_file) - 1] = '\0';
        break;

      case 'h': /* Help */
        printf(
          "Usage: %s [-c config_file] [-p search_paths] [-n name]\n", argv[0]);
        return BZ_ERR_INVALID_ARG; /* Treat as early exit */

      case '?': /* Unknown option */
      default:
        return BZ_ERR_INVALID_ARG;
    }
  }

  /* Remaining positional args can be accessed with argv[optind..] */

  return BZ_OK;
}
bool bz_tomlconf_value_as_bool(const char* key);
double bz_tomlconf_value_as_f64(const char* key);
int64_t bz_tomlconf_value_as_i64(const char* key);
uint64_t bz_tomlconf_value_as_u64(const char* key);
const char* bz_tomlconf_value_as_str(const char* key);
