common_sources = sensirion_config.h sensirion_common.h sensirion_common.c
i2c_sources = sensirion_i2c_hal.h sensirion_i2c.h sensirion_i2c.c
driver_sources = scd30_i2c.h scd30_i2c.c

i2c_implementation ?= sensirion_i2c_hal.c

ENV_FILE = /home/javiergracia/sensorProgramms
include $(ENV_FILE)/.env

CFLAGS = -Os -Wall -fstrict-aliasing -Wstrict-aliasing=1 -Wsign-conversion -fPIC -I. 
CFLAGS += -DTOKEN_INFLUX=\"$(INFLUXDB_TOKEN)\"
LCURL = -lcurl
ifdef CI
    CFLAGS += -Werror
endif


.PHONY: all clean

all: scd30_i2c_for_influxdb

scd30_i2c_for_influxdb: clean
	$(CC) $(CFLAGS) -o $@  ${driver_sources} ${i2c_sources} \
		${i2c_implementation} ${common_sources} scd30_i2c_for_influxdb.c ${LCURL}  

clean:
	$(RM) scd30_i2c_for_influxdb
