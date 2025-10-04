#include <argp.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>

#include <bazalt/bazalt.h>
#include <bazalt/logging.h>
#include <bazalt/tomlconf.h>

static bz_config_env_map config_env[] = {
  {"EXAMPLE_ENV1", "example.env1"},
  {"EXAMPLE_ENV2", "example.env2"},
  {"EXAMPLE_ENV3", "example.env3"},
  {0} /* terminator */
};

static bz_config_options config_options = {
  .name = "example",
  .config_file = "config.toml",
  .config_path = "/etc:/run:/usr/local",
  .environment = config_env  //
};

int main(int argc, char** argv)
{
  bz_tomlconf_init(&config_options);
  bz_tomlconf_parse_args(argc, argv);

  bz_tomlconf_value_as_str("");
  bz_tomlconf_value_as_i64("");
  bz_tomlconf_value_as_f64("");

  /* ---------------- Basic log messages ---------------- */
  bz_log_debug("Debug message (detailed, may be filtered by log level)");
  bz_log_info("Info message");
  bz_log_notice("Notice message");
  bz_log_warning("Warning message");
  bz_log_err("Error message");
  bz_log_crit("Critical message");
  bz_log_alert("Alert message");
  bz_log_emerg("Emergency message!");

  /* ---------------- Logging with errno ---------------- */
  FILE* f = fopen("nonexistent_file.txt", "r");
  if(!f) {
    bz_log_err_errno(errno, "Failed to open file");
    bz_log_debug_errno(errno, "Debug info: errno=%d", errno);
  }

  /* ---------------- Formatted logging ---------------- */
  int x = 42;
  bz_log_info("The value of x is %d", x);
  bz_log_warning(
    "This is a warning with multiple values: x=%d, errno=%d", x, errno);

  /* ---------------- Heap context example (optional) ---------------- */
  /* bz_app_context* heap_ctx = bz_app_context_create("HeapApp",
     BAZALT_LOG_LEVEL_INFO, 1); bz_log_info("This message uses the heap
     context"); bz_app_context_free(heap_ctx);
  */

  return 0;
}
