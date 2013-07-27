CC?=			clang
CFLAGS?=		-g -O2
INCLUDE_PATHS=	-I./ -I./util -I./exceptions -I./gridfs -I./types -I./mcon
LOCAL_INCLUDE_PATHS=	-I$(PREFIX)/include/php -I$(PREFIX)/include/php/main -I$(PREFIX)/include/php/TSRM -I$(PREFIX)/include/php/Zend -I$(PREFIX)/include/php/ext -I$(PREFIX)/include/php/ext/date/lib/
COPTS=			-DPHP_ATOM_INC -DHAVE_CONFIG_H -DCOMPILE_DL_MONGO -fPIC -DPIC
COMPILE=		$(CC) -c $(CFLAGS) $(COPTS) $(INCLUDE_PATHS) $(LOCAL_INCLUDE_PATHS)
LIB_LIST=		bson.o collection.o connection_exception.o cursor.o cursor_exception.o cursor_timeout_exception.o db.o exception.o gridfs.o gridfs_cursor.o gridfs_exception.o gridfs_file.o gridfs_stream.o io_stream.o log_stream.o mcon_bson_helpers.o mcon_collection.o mcon_connections.o mcon_io.o mcon_manager.o mcon_mini_bson.o mcon_parse.o mcon_read_preference.o mcon_str.o mcon_utils.o mongo.o mongoclient.o php_mongo.o result_exception.o types_bin_data.o types_code.o types_date.o types_db_ref.o types_id.o types_int32.o types_int64.o types_regex.o types_timestamp.o util_log.o util_pool.o
PHP_EXT_DIR=	$(PREFIX)/lib/php/extensions/no-debug-non-zts-20100525
INSTALL?=		install

all: php_mongo

php_mongo:
	$(COMPILE) php_mongo.c -o php_mongo.o 
	$(COMPILE) mongo.c -o mongo.o
	$(COMPILE) mongoclient.c -o mongoclient.o
	$(COMPILE) bson.c -o bson.o
	$(COMPILE) cursor.c -o cursor.o
	$(COMPILE) collection.c -o collection.o
	$(COMPILE) db.c -o db.o
	$(COMPILE) io_stream.c -o io_stream.o
	$(COMPILE) log_stream.c -o log_stream.o

	$(COMPILE) gridfs/gridfs.c -o gridfs.o
	$(COMPILE) gridfs/gridfs_cursor.c -o gridfs_cursor.o
	$(COMPILE) gridfs/gridfs_file.c -o gridfs_file.o
	$(COMPILE) gridfs/gridfs_stream.c -o gridfs_stream.o

	$(COMPILE) exceptions/connection_exception.c -o connection_exception.o
	$(COMPILE) exceptions/cursor_exception.c -o cursor_exception.o
	$(COMPILE) exceptions/cursor_timeout_exception.c -o cursor_timeout_exception.o
	$(COMPILE) exceptions/exception.c -o exception.o
	$(COMPILE) exceptions/gridfs_exception.c -o gridfs_exception.o
	$(COMPILE) exceptions/result_exception.c -o result_exception.o

	$(COMPILE) types/bin_data.c -o types_bin_data.o
	$(COMPILE) types/code.c -o types_code.o
	$(COMPILE) types/date.c -o types_date.o
	$(COMPILE) types/db_ref.c -o types_db_ref.o
	$(COMPILE) types/id.c -o types_id.o
	$(COMPILE) types/int32.c -o types_int32.o
	$(COMPILE) types/int64.c -o types_int64.o
	$(COMPILE) types/regex.c -o types_regex.o
	$(COMPILE) types/timestamp.c -o types_timestamp.o

	$(COMPILE) util/log.c -o util_log.o
	$(COMPILE) util/pool.c -o util_pool.o

	$(COMPILE) mcon/bson_helpers.c -o mcon_bson_helpers.o
	$(COMPILE) mcon/collection.c -o mcon_collection.o
	$(COMPILE) mcon/connections.c -o mcon_connections.o
	$(COMPILE) mcon/io.c -o mcon_io.o
	$(COMPILE) mcon/manager.c -o mcon_manager.o
	$(COMPILE) mcon/mini_bson.c -o mcon_mini_bson.o
	$(COMPILE) mcon/parse.c -o mcon_parse.o
	$(COMPILE) mcon/read_preference.c -o mcon_read_preference.o
	$(COMPILE) mcon/str.c -o mcon_str.o
	$(COMPILE) mcon/utils.c -o mcon_utils.o

	$(CC) -shared -Wl,-soname -Wl,mongo.so $(LIB_LIST) -o mongo.so

install:
	$(INSTALL) -m 644 mongo.so $(PHP_EXT_DIR)/
	
clean:
	rm -f *.o
	rm -f *.so
	
deinstall:
	rm -f $(PHP_EXT_DIR)/mongo.so
