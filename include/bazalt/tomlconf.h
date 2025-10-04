#ifndef BAZALT_TOMLCONF_H
#define BAZALT_TOMLCONF_H

#include <stdbool.h>
#include <stddef.h> /* size_t */
#include <stdint.h> /* uint32_t */

#include <bazalt/bazalt.h>

#ifdef __cplusplus
extern "C" {
#endif

bz_status bz_tomlconf_init(bz_config_options* options);
bz_status bz_tomlconf_load_config_file(const char* path);
bz_status bz_tomlconf_load_env_var(const char* name, const char* dest);
bz_status bz_tomlconf_parse_args(int argc, char** argv);

bool bz_tomlconf_value_as_bool(const char* key);
double bz_tomlconf_value_as_f64(const char* key);
int64_t bz_tomlconf_value_as_i64(const char* key);
uint64_t bz_tomlconf_value_as_u64(const char* key);
const char* bz_tomlconf_value_as_str(const char* key);

#ifdef __cplusplus
}
#endif

#endif  // BAZALT_TOMLCONF_H
