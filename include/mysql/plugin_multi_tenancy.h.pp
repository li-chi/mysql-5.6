#include "plugin.h"
typedef void * MYSQL_PLUGIN;
#include <mysql/services.h>
#include <mysql/service_my_snprintf.h>
extern struct my_snprintf_service_st {
  size_t (*my_snprintf_type)(char*, size_t, const char*, ...);
  size_t (*my_vsnprintf_type)(char *, size_t, const char*, va_list);
} *my_snprintf_service;
size_t my_snprintf(char* to, size_t n, const char* fmt, ...);
size_t my_vsnprintf(char *to, size_t n, const char* fmt, va_list ap);
#include <mysql/service_thd_alloc.h>
struct st_mysql_lex_string
{
  char *str;
  size_t length;
};
typedef struct st_mysql_lex_string MYSQL_LEX_STRING;
extern struct thd_alloc_service_st {
  void *(*thd_alloc_func)(void*, unsigned int);
  void *(*thd_calloc_func)(void*, unsigned int);
  char *(*thd_strdup_func)(void*, const char *);
  char *(*thd_strmake_func)(void*, const char *, unsigned int);
  void *(*thd_memdup_func)(void*, const void*, unsigned int);
  MYSQL_LEX_STRING *(*thd_make_lex_string_func)(void*, MYSQL_LEX_STRING *,
                                        const char *, unsigned int, int);
} *thd_alloc_service;
void *thd_alloc(void* thd, unsigned int size);
void *thd_calloc(void* thd, unsigned int size);
char *thd_strdup(void* thd, const char *str);
char *thd_strmake(void* thd, const char *str, unsigned int size);
void *thd_memdup(void* thd, const void* str, unsigned int size);
MYSQL_LEX_STRING *thd_make_lex_string(void* thd, MYSQL_LEX_STRING *lex_str,
                                      const char *str, unsigned int size,
                                      int allocate_lex_string);
#include <mysql/service_thd_wait.h>
typedef enum _thd_wait_type_e {
  THD_WAIT_SLEEP= 1,
  THD_WAIT_DISKIO= 2,
  THD_WAIT_ROW_LOCK= 3,
  THD_WAIT_GLOBAL_LOCK= 4,
  THD_WAIT_META_DATA_LOCK= 5,
  THD_WAIT_TABLE_LOCK= 6,
  THD_WAIT_USER_LOCK= 7,
  THD_WAIT_BINLOG= 8,
  THD_WAIT_GROUP_COMMIT= 9,
  THD_WAIT_SYNC= 10,
  THD_WAIT_NET_IO= 11,
  THD_WAIT_YIELD= 12,
  THD_WAIT_FOR_HLC= 13,
  THD_WAIT_LAST= 14
} thd_wait_type;
extern struct thd_wait_service_st {
  void (*thd_wait_begin_func)(void*, int);
  void (*thd_wait_end_func)(void*);
} *thd_wait_service;
void thd_wait_begin(void* thd, int wait_type);
void thd_wait_end(void* thd);
#include <mysql/service_thread_scheduler.h>
struct scheduler_functions;
extern struct my_thread_scheduler_service {
  int (*set)(struct scheduler_functions *scheduler);
  int (*reset)();
} *my_thread_scheduler_service;
int my_thread_scheduler_set(struct scheduler_functions *scheduler);
int my_thread_scheduler_reset();
#include <mysql/service_my_plugin_log.h>
enum plugin_log_level
{
  MY_ERROR_LEVEL,
  MY_WARNING_LEVEL,
  MY_INFORMATION_LEVEL
};
extern struct my_plugin_log_service
{
  int (*my_plugin_log_message)(MYSQL_PLUGIN *, enum plugin_log_level, const char *, ...);
} *my_plugin_log_service;
int my_plugin_log_message(MYSQL_PLUGIN *plugin, enum plugin_log_level level,
                          const char *format, ...);
#include <mysql/service_mysql_string.h>
typedef void *mysql_string_iterator_handle;
typedef void *mysql_string_handle;
extern struct mysql_string_service_st {
  int (*mysql_string_convert_to_char_ptr_type)
       (mysql_string_handle, const char *, char *, unsigned int, int *);
  mysql_string_iterator_handle (*mysql_string_get_iterator_type)
                                (mysql_string_handle);
  int (*mysql_string_iterator_next_type)(mysql_string_iterator_handle);
  int (*mysql_string_iterator_isupper_type)(mysql_string_iterator_handle);
  int (*mysql_string_iterator_islower_type)(mysql_string_iterator_handle);
  int (*mysql_string_iterator_isdigit_type)(mysql_string_iterator_handle);
  mysql_string_handle (*mysql_string_to_lowercase_type)(mysql_string_handle);
  void (*mysql_string_free_type)(mysql_string_handle);
  void (*mysql_string_iterator_free_type)(mysql_string_iterator_handle);
} *mysql_string_service;
int mysql_string_convert_to_char_ptr(mysql_string_handle string_handle,
                                     const char *charset_name, char *buffer,
                                     unsigned int buffer_size, int *error);
mysql_string_iterator_handle mysql_string_get_iterator(mysql_string_handle
                                                       string_handle);
int mysql_string_iterator_next(mysql_string_iterator_handle iterator_handle);
int mysql_string_iterator_isupper(mysql_string_iterator_handle iterator_handle);
int mysql_string_iterator_islower(mysql_string_iterator_handle iterator_handle);
int mysql_string_iterator_isdigit(mysql_string_iterator_handle iterator_handle);
mysql_string_handle mysql_string_to_lowercase(mysql_string_handle
                                              string_handle);
void mysql_string_free(mysql_string_handle);
void mysql_string_iterator_free(mysql_string_iterator_handle);
struct st_mysql_xid {
  long formatID;
  long gtrid_length;
  long bqual_length;
  char data[128];
};
typedef struct st_mysql_xid MYSQL_XID;
enum enum_mysql_show_type
{
  SHOW_UNDEF, SHOW_BOOL,
  SHOW_INT,
  SHOW_LONG,
  SHOW_LONGLONG,
  SHOW_SIGNED_INT,
  SHOW_SIGNED_LONG,
  SHOW_SIGNED_LONGLONG,
  SHOW_CHAR, SHOW_CHAR_PTR,
  SHOW_ARRAY, SHOW_FUNC, SHOW_DOUBLE,
  SHOW_TIMER,
  SHOW_always_last
};
struct st_mysql_show_var {
  const char *name;
  char *value;
  enum enum_mysql_show_type type;
};
typedef int (*mysql_show_var_func)(void*, struct st_mysql_show_var*, char *);
struct st_mysql_sys_var;
struct st_mysql_value;
typedef int (*mysql_var_check_func)(void* thd,
                                    struct st_mysql_sys_var *var,
                                    void *save, struct st_mysql_value *value);
typedef void (*mysql_var_update_func)(void* thd,
                                      struct st_mysql_sys_var *var,
                                      void *var_ptr, const void *save);
struct st_mysql_plugin
{
  int type;
  void *info;
  const char *name;
  const char *author;
  const char *descr;
  int license;
  int (*init)(MYSQL_PLUGIN);
  int (*deinit)(MYSQL_PLUGIN);
  unsigned int version;
  struct st_mysql_show_var *status_vars;
  struct st_mysql_sys_var **system_vars;
  void * __reserved1;
  unsigned long flags;
};
#include "plugin_ftparser.h"
#include "plugin.h"
enum enum_ftparser_mode
{
  MYSQL_FTPARSER_SIMPLE_MODE= 0,
  MYSQL_FTPARSER_WITH_STOPWORDS= 1,
  MYSQL_FTPARSER_FULL_BOOLEAN_INFO= 2
};
enum enum_ft_token_type
{
  FT_TOKEN_EOF= 0,
  FT_TOKEN_WORD= 1,
  FT_TOKEN_LEFT_PAREN= 2,
  FT_TOKEN_RIGHT_PAREN= 3,
  FT_TOKEN_STOPWORD= 4
};
typedef struct st_mysql_ftparser_boolean_info
{
  enum enum_ft_token_type type;
  int yesno;
  int weight_adjust;
  char wasign;
  char trunc;
  char prev;
  char *quot;
} MYSQL_FTPARSER_BOOLEAN_INFO;
typedef struct st_mysql_ftparser_param
{
  int (*mysql_parse)(struct st_mysql_ftparser_param *,
                     char *doc, int doc_len);
  int (*mysql_add_word)(struct st_mysql_ftparser_param *,
                        char *word, int word_len,
                        MYSQL_FTPARSER_BOOLEAN_INFO *boolean_info);
  void *ftparser_state;
  void *mysql_ftparam;
  const struct charset_info_st *cs;
  char *doc;
  int length;
  int flags;
  enum enum_ftparser_mode mode;
} MYSQL_FTPARSER_PARAM;
struct st_mysql_ftparser
{
  int interface_version;
  int (*parse)(MYSQL_FTPARSER_PARAM *param);
  int (*init)(MYSQL_FTPARSER_PARAM *param);
  int (*deinit)(MYSQL_FTPARSER_PARAM *param);
};
struct st_mysql_daemon
{
  int interface_version;
};
struct st_mysql_information_schema
{
  int interface_version;
};
struct st_mysql_storage_engine
{
  int interface_version;
};
struct handlerton;
 struct Mysql_replication {
   int interface_version;
 };
struct st_mysql_value
{
  int (*value_type)(struct st_mysql_value *);
  const char *(*val_str)(struct st_mysql_value *, char *buffer, int *length);
  int (*val_real)(struct st_mysql_value *, double *realbuf);
  int (*val_int)(struct st_mysql_value *, long long *intbuf);
  int (*is_unsigned)(struct st_mysql_value *);
};
struct st_slave_gtid_info
{
  unsigned int id;
  const char* db;
  const char* gtid;
};
struct snapshot_info_st;
int thd_in_lock_tables(const void* thd);
int thd_tablespace_op(const void* thd);
long long thd_test_options(const void* thd, long long test_options);
int thd_sql_command(const void* thd);
const char *thd_proc_info(void* thd, const char *info);
void **thd_ha_data(const void* thd, const struct handlerton *hton);
void thd_storage_lock_wait(void* thd, long long value);
int thd_tx_isolation(const void* thd);
int thd_tx_is_read_only(const void* thd);
char *thd_security_context(void* thd, char *buffer, unsigned int length,
                           unsigned int max_query_len);
void thd_inc_row_count(void* thd);
int thd_allow_batch(void* thd);
void thd_store_lsn(void* thd, unsigned long long lsn, int db_type);
int mysql_tmpfile(const char *prefix);
int thd_killed(const void* thd);
void thd_set_kill_status(const void* thd);
void thd_binlog_pos(const void* thd,
                    const char **file_var,
                    unsigned long long *pos_var,
                    const char **gtid_var,
                    const char **max_gtid_var);
void thd_slave_gtid_info(const void* thd, void *slave_gtid_info);
unsigned long thd_get_thread_id(const void* thd);
void thd_get_xid(const void* thd, MYSQL_XID *xid);
void* thd_get_current_thd();
void mysql_query_cache_invalidate4(void* thd,
                                   const char *key, unsigned int key_length,
                                   int using_trx);
void *thd_get_ha_data(const void* thd, const struct handlerton *hton);
void thd_set_ha_data(void* thd, const struct handlerton *hton,
                     const void *ha_data);
char mysql_bin_log_is_open(void);
void mysql_bin_log_lock_commits(struct snapshot_info_st *ss_info);
void mysql_bin_log_unlock_commits(const struct snapshot_info_st *ss_info);
enum class enum_multi_tenancy_resource_type : int32_t
{
  MULTI_TENANCY_RESOURCE_CONNECTION,
  MULTI_TENANCY_RESOURCE_QUERY,
  MULTI_TENANCY_NUM_RESOURCE_TYPES
};
enum class enum_multi_tenancy_return_type : int32_t
{
  MULTI_TENANCY_RET_ACCEPT = 0,
  MULTI_TENANCY_RET_WAIT,
  MULTI_TENANCY_RET_REJECT,
  MULTI_TENANCY_RET_FALLBACK,
  MULTI_TENANCY_NUM_RETURN_TYPES
};
typedef enum enum_multi_tenancy_resource_type MT_RESOURCE_TYPE;
typedef enum enum_multi_tenancy_return_type MT_RETURN_TYPE;
typedef std::unordered_map<std::string, std::string> ATTRS_MAP_T;
struct multi_tenancy_resource_attributes
{
  const ATTRS_MAP_T *connection_attrs_map;
  const ATTRS_MAP_T *query_attrs_map;
  const char *database;
};
typedef struct multi_tenancy_resource_attributes MT_RESOURCE_ATTRS;
struct st_mysql_multi_tenancy
{
  int interface_version;
  MT_RETURN_TYPE (*request_resource)
    (void*, MT_RESOURCE_TYPE, const MT_RESOURCE_ATTRS *);
  MT_RETURN_TYPE (*release_resource)
    (void*, MT_RESOURCE_TYPE, const MT_RESOURCE_ATTRS *);
  std::string (*get_entity_name)
    (void*, MT_RESOURCE_TYPE, const MT_RESOURCE_ATTRS *);
  int (*get_resource_counter)
    (void*, MT_RESOURCE_TYPE, const char *, int *);
};
std::list<std::pair<const char*, const char*> > thd_get_query_tables(
    THD *thd);
const std::string &thd_get_query_attr(THD *thd, const std::string &qattr_key);
const std::string &thd_get_connection_attr(THD *thd,
                                           const std::string &cattr_key);
