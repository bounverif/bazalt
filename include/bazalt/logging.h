#ifndef BAZALT_LOGGER_H
#define BAZALT_LOGGER_H

#include <stdio.h>

#include <bazalt/bazalt.h>

/* ---------------- Log level enum ---------------- */
typedef enum {
  BAZALT_LOG_LEVEL_EMERGENCY = 0,
  BAZALT_LOG_LEVEL_ALERT = 1,
  BAZALT_LOG_LEVEL_CRITICAL = 2,
  BAZALT_LOG_LEVEL_ERROR = 3,
  BAZALT_LOG_LEVEL_WARNING = 4,
  BAZALT_LOG_LEVEL_NOTICE = 5,
  BAZALT_LOG_LEVEL_INFO = 6,
  BAZALT_LOG_LEVEL_DEBUG = 7
} bz_log_level;

/* ---------------- Extern logging function ---------------- */
#ifdef __cplusplus
extern "C" {
#endif

extern int bz_log_internal(
  int level,
  int error,
  const char* file,
  int line,
  const char* func,
  const char* format,
  ...);

#ifdef __cplusplus
}
#endif

/* ---------------- Convenience macros ---------------- */

/* Normal logging (no errno) */
#define bz_log_debug(...) \
  bz_log_internal(        \
    BAZALT_LOG_LEVEL_DEBUG, 0, __FILE__, __LINE__, __func__, __VA_ARGS__)
#define bz_log_info(...) \
  bz_log_internal(       \
    BAZALT_LOG_LEVEL_INFO, 0, __FILE__, __LINE__, __func__, __VA_ARGS__)
#define bz_log_notice(...) \
  bz_log_internal(         \
    BAZALT_LOG_LEVEL_NOTICE, 0, __FILE__, __LINE__, __func__, __VA_ARGS__)
#define bz_log_warning(...) \
  bz_log_internal(          \
    BAZALT_LOG_LEVEL_WARNING, 0, __FILE__, __LINE__, __func__, __VA_ARGS__)
#define bz_log_err(...) \
  bz_log_internal(      \
    BAZALT_LOG_LEVEL_ERROR, 0, __FILE__, __LINE__, __func__, __VA_ARGS__)
#define bz_log_crit(...) \
  bz_log_internal(       \
    BAZALT_LOG_LEVEL_CRITICAL, 0, __FILE__, __LINE__, __func__, __VA_ARGS__)
#define bz_log_alert(...) \
  bz_log_internal(        \
    BAZALT_LOG_LEVEL_ALERT, 0, __FILE__, __LINE__, __func__, __VA_ARGS__)
#define bz_log_emerg(...) \
  bz_log_internal(        \
    BAZALT_LOG_LEVEL_EMERGENCY, 0, __FILE__, __LINE__, __func__, __VA_ARGS__)

/* Logging with errno */
#define bz_log_debug_errno(err, ...) \
  bz_log_internal(                   \
    BAZALT_LOG_LEVEL_DEBUG, err, __FILE__, __LINE__, __func__, __VA_ARGS__)
#define bz_log_info_errno(err, ...) \
  bz_log_internal(                  \
    BAZALT_LOG_LEVEL_INFO, err, __FILE__, __LINE__, __func__, __VA_ARGS__)
#define bz_log_notice_errno(err, ...) \
  bz_log_internal(                    \
    BAZALT_LOG_LEVEL_NOTICE, err, __FILE__, __LINE__, __func__, __VA_ARGS__)
#define bz_log_warning_errno(err, ...) \
  bz_log_internal(                     \
    BAZALT_LOG_LEVEL_WARNING, err, __FILE__, __LINE__, __func__, __VA_ARGS__)
#define bz_log_err_errno(err, ...) \
  bz_log_internal(                 \
    BAZALT_LOG_LEVEL_ERROR, err, __FILE__, __LINE__, __func__, __VA_ARGS__)
#define bz_log_crit_errno(err, ...) \
  bz_log_internal(                  \
    BAZALT_LOG_LEVEL_CRITICAL, err, __FILE__, __LINE__, __func__, __VA_ARGS__)
#define bz_log_alert_errno(err, ...) \
  bz_log_internal(                   \
    BAZALT_LOG_LEVEL_ALERT, err, __FILE__, __LINE__, __func__, __VA_ARGS__)
#define bz_log_emerg_errno(err, ...) \
  bz_log_internal(                   \
    BAZALT_LOG_LEVEL_EMERGENCY,      \
    err,                             \
    __FILE__,                        \
    __LINE__,                        \
    __func__,                        \
    __VA_ARGS__)

#endif  // BAZALT_LOGGER_H
