#include <stdlib.h>
#include <string.h>

#include <bazalt/bazalt.h>

#include "bazalt/internal/common.h"

// Global singleton context

// Initialize context from options
// bz_status bz_app_context_init(bz_app_options* options)
// {
//   if(!options || !options->name) {
//     return BZ_ERR_INVALID_ARG;
//   }
//   return BZ_OK;
// }

// // Set log level
// bz_status bz_logging_set_level(int level)
// {
//   g_logging_context.logging_level = level;
//   return BZ_OK;
// }

// // Enable/disable console color
// bz_status bz_logging_use_color(int use_color)
// {
//   g_logging_context.logging_use_color = use_color ? 1 : 0;
//   return BZ_OK;
// }
