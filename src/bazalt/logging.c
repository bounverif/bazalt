#include <errno.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include <bazalt/logging.h>

#include "bazalt/internal/common.h"

/* ---------------- ANSI COLOR DEFINITIONS ---------------- */
#define RESET_COLOUR "\x1B[0m"
#define DEBUG_COLOUR ""
#define INFO_COLOUR "\x1B[36m"
#define NOTICE_COLOUR "\x1B[32m"
#define WARNING_COLOUR "\x1B[33m"
#define ERROR_COLOUR "\x1B[31m"
#define CRITICAL_COLOUR "\x1B[31;1m"
#define ALERT_COLOUR "\x1B[48;5;88;1m"
#define EMERGENCY_COLOUR "\x1B[97;101;1m"

#define TIME_FORMAT "%T"
#define BORDER "-"

// Logging singleton
static bz_logging_context g_logging_context = {0, 0};

bz_logging_context* bz_logging_context_get(void)
{
  return &g_logging_context;
}

// Logging implementation
static inline const char* bz_log_level_str(bz_log_level level)
{
  switch(level) {
    case BAZALT_LOG_LEVEL_EMERGENCY:
      return "EMERGENCY";
    case BAZALT_LOG_LEVEL_ALERT:
      return "ALERT";
    case BAZALT_LOG_LEVEL_CRITICAL:
      return "CRITICAL";
    case BAZALT_LOG_LEVEL_ERROR:
      return "ERROR";
    case BAZALT_LOG_LEVEL_WARNING:
      return "WARNING";
    case BAZALT_LOG_LEVEL_NOTICE:
      return "NOTICE";
    case BAZALT_LOG_LEVEL_INFO:
      return "INFO";
    case BAZALT_LOG_LEVEL_DEBUG:
      return "DEBUG";
    default:
      return "UNKNOWN";
  }
}

/* ---------------- Internal Logging Function ---------------- */
int bz_log_internal(
  int level,
  int error,
  const char* file,
  int line,
  const char* func,
  const char* format,
  ...)
{
  bz_logging_context* ctx = bz_logging_context_get();
  if(!ctx || level > ctx->logging_level) {
    return EXIT_SUCCESS;
  }

  /* Timestamp */
  time_t now = time(NULL);
  struct tm t_struct;
  struct tm* t_ptr = localtime(&now); /* ISO C standard */
  if(t_ptr != NULL) {
    t_struct = *t_ptr; /* copy to local variable */
  }
  else {
    memset(&t_struct, 0, sizeof(t_struct));
  }

  char time_buffer[32];
  strftime(time_buffer, sizeof(time_buffer), TIME_FORMAT, &t_struct);

  /* Pick color based on enum */
  const char* colour;
  switch(level) {
    case BAZALT_LOG_LEVEL_EMERGENCY:
      colour = EMERGENCY_COLOUR;
      break;
    case BAZALT_LOG_LEVEL_ALERT:
      colour = ALERT_COLOUR;
      break;
    case BAZALT_LOG_LEVEL_CRITICAL:
      colour = CRITICAL_COLOUR;
      break;
    case BAZALT_LOG_LEVEL_ERROR:
      colour = ERROR_COLOUR;
      break;
    case BAZALT_LOG_LEVEL_WARNING:
      colour = WARNING_COLOUR;
      break;
    case BAZALT_LOG_LEVEL_NOTICE:
      colour = NOTICE_COLOUR;
      break;
    case BAZALT_LOG_LEVEL_INFO:
      colour = INFO_COLOUR;
      break;
    default:
      colour = "";
      break;
  }

  const char* col = (ctx->logging_use_color) ? colour : "";
  const char* reset = (ctx->logging_use_color) ? RESET_COLOUR : "";

  /* Header: timestamp, level, file:line (function) */
  fprintf(
    stderr,
    "%s%s %-9s %s %s:%d (%s): ",
    col,
    time_buffer,
    bz_log_level_str(level),
    BORDER,
    file,
    line,
    func);

  /* Format the message */
  va_list args;
  va_start(args, format);
  vfprintf(stderr, format, args);
  va_end(args);

  /* Optional error code display */
  if(error != 0) {
    fprintf(stderr, " (error: %s)", strerror(error));
  }

  fprintf(stderr, "%s\n", reset);

  return EXIT_SUCCESS;
}
