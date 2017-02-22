#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "ini.h"

static int read_until(FILE* fp, char* buffer, int size, int delim)
{
	char c;
	int i = 0;
	memset(buffer, 0, size);
	int string = 0;
	while (i < size) {
		c = getc(fp);
		if(isblank(c) && string == 0)
			continue;
		if (c == '\"')
			string = 1;
		if (c == delim) {
			buffer[i] = '\0';
			if (delim == '=')
				ungetc(c, fp);
			return 0;
		}
		if (c == EOF) {
			return 0;
		}
		buffer[i++] = c;
	}
	buffer[i] = '\0';
	return -1;
}

/**
 * @brief Parse an ini file.
 * @details Parse an ini file. Passes values to a callback function.
 * No dynamic memory is allocated.
 * 
 * @param fp Open file pointer to read INI file from
 * @param callback Callback function accepting three arguments:
 * section, variable, and value strings.
 * @return 0 on success, error code on failure
 */
int ini_parse_file(FILE* fp, int (*callback)(char*, char*, char*))
{
	if ((fp == NULL) || (callback == NULL))
		return -1;

	char section [BUFFER_SIZE] = "";
	char config  [BUFFER_SIZE] = "";
	char value   [BUFFER_SIZE] = "";
	int c;
	int err;
	while((c = getc(fp)) != EOF) {
		switch(c) {
			case '#': {
				while ((c = getc(fp)) != '\n')
					;
				break;
			}
			case '[': {
				err = read_until(fp, section, BUFFER_SIZE, ']');
				if (err)
					return err;
				break;
			}
			case '=': {
				err = read_until(fp, value, BUFFER_SIZE, '\n');
				if (err)
					return err;
				err = callback(section, config, value);
				if (err)
					return err;
				break;
			}
			case '\n': case ' ': case '\t':
				break;
			default:
				ungetc(c, fp);
				err = read_until(fp, config, BUFFER_SIZE, '=');
				if (err)
					return err;
				break;
		}
	}
	return -1;
}
