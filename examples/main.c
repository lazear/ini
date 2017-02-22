#include <stdio.h>
#include <stdlib.h>
#include "ini.h"

int callback(char* section, char* config, char* value)
{
	printf("[%s] \"%s\" == \"%s\"\n", section, config, value);
	return 0;
}

int main(int argc, char** argv) {
	if (argc < 2) {
		printf("usage: %s file ...\noutput ini configuration values\n", argv[0]);
		return EXIT_FAILURE;
	}

	int i;
	for (i = 1; i < argc; i++) {
		printf("parsing %s\n", argv[i]);
		FILE* fp = fopen(argv[i], "r");
		if (! fp) {
			fprintf(stderr, "Error opening %s\n", argv[i]);
			return EXIT_FAILURE;
		}
		ini_parse_file(fp, callback);
		fclose(fp);
	}
	return EXIT_SUCCESS;
}
