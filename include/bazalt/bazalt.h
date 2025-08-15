#ifndef BAZALT_H
#define BAZALT_H

#ifndef BAZALT_NAME_MAX
#define BAZALT_NAME_MAX 32
#endif

#ifndef BAZALT_PATHNAME_MAX
#define BAZALT_PATHNAME_MAX 128
#endif

#ifdef __cplusplus
#define BAZALT_EXTERN extern "C"
#else
#define BAZALT_EXTERN extern
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
  BZ_OK = 0,          /* Operation succeeded */
  BZ_ERR_ALLOC,       /* Memory allocation failed */
  BZ_ERR_INVALID_ARG, /* Invalid argument */
  BZ_ERR_INTERNAL,    /* Internal error */
  BZ_ERR_NOT_FOUND,   /* Resource not found */
  BZ_ERR_IO,          /* Input/output error */
  BZ_ERR_PERMISSION,  /* Permission denied */
  BZ_ERR_CONFIG,      /* Configuration error */
  BZ_ERR_PARSE,       /* Parsing error */
  BZ_ERR_UNSUPPORTED, /* Unsupported operation or feature */
  BZ_ERR_TIMEOUT,     /* Operation timed out */
  BZ_ERR_OVERFLOW,    /* Numeric or buffer overflow */
  BZ_ERR_STATE        /* Invalid state for requested operation */
} bz_status;

typedef struct bz_value bz_value;
typedef struct bz_result {
  bz_status status;
  bz_value* value;
} bz_result;

typedef struct {
  const char* name;
  const char* dest;
} bz_config_env_map;

typedef struct bz_config_options {
  char name[BAZALT_NAME_MAX];
  char config_file[BAZALT_NAME_MAX];
  char config_path[BAZALT_PATHNAME_MAX];
  bz_config_env_map* environment;
} bz_config_options;

#ifdef __cplusplus
}
#endif

#endif /* BAZALT_H */
