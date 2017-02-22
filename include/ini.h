#ifndef _INI_H_
#define _INI_H_

#define BUFFER_SIZE 128

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
int ini_parse_file(FILE* fp, int (*callback)(char* section, char* variable, char* value));

#endif