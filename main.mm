#include "IOKit/IOKitLib.h"
#include <mach/mach.h>


int printGenerator()
{
	int error = -1;
	CFMutableDictionaryRef nvDict = IOServiceMatching("IODTNVRAM");
	io_service_t nvService = IOServiceGetMatchingService(kIOMasterPortDefault, nvDict);

	if(MACH_PORT_VALID(nvService))
	{
		io_struct_inband_t buffer;
		unsigned int len = 256;
		kern_return_t kern_return = IORegistryEntryGetProperty(nvService, "com.apple.System.boot-nonce", buffer, &len);
		if(kern_return == KERN_SUCCESS)
		{
			printf("%s\n", (char *) buffer);
			error = 0;
		}
		else
		{
			printf("%s", mach_error_string(kern_return));
		}
	}
	else
	{
		printf("Couldn't get nvram service");
	}
	IOObjectRelease(nvService);
	return error;
}

int setGenerator(char *genStr)
{
	int error = -1;
	CFStringRef generator = CFStringCreateWithCString(kCFAllocatorDefault, genStr, kCFStringEncodingUTF8);
	CFStringRef bootNonceKey = CFStringCreateWithCString(kCFAllocatorDefault, "com.apple.System.boot-nonce", kCFStringEncodingUTF8);

	CFMutableDictionaryRef nvDict = IOServiceMatching("IODTNVRAM");
	io_service_t nvService = IOServiceGetMatchingService(kIOMasterPortDefault, nvDict);
	if(MACH_PORT_VALID(nvService))
	{
		kern_return_t kern_return = IORegistryEntrySetCFProperty(nvService, bootNonceKey, generator);
		if(kern_return == KERN_SUCCESS)
		{
			error = 0;
		}
		else
		{
			printf("%s\n", mach_error_string(kern_return));
			error = -1;
		}
	}
	else
	{
		printf("Couldn't get nvram service");
	}

	IOObjectRelease(nvService);
	CFRelease(generator);
	CFRelease(bootNonceKey);

	return error;
}

int main(int argc, char **argv, char **envp)
{
	int error = -1;
	if(argc < 2)
	{
		return printGenerator();
	}
	else
	{
		char *generator = argv[1];
		char compareString[22];
		char generatorToSet[22];
		uint64_t rawGeneratorValue;
		switch(strlen(generator))
		{
			case 16:
			sscanf(generator, "%llx", &rawGeneratorValue);
			sprintf(compareString, "%llx", rawGeneratorValue);
			break;

			case 18:
			sscanf(generator, "0x%16llx", &rawGeneratorValue);
			sprintf(compareString, "0x%llx", rawGeneratorValue);
			break;

			default:
			printf("Invalid generator\n");
			return -1;
			break;
		}
		if(!strcmp(compareString, generator))
		{
			sprintf(generatorToSet, "0x%llx", rawGeneratorValue);
			if(!setGenerator(generatorToSet))
			{
				printf("Success : ");
				printGenerator();
				error = 0;
			}
		}
		else
		{
			printf("Generator validation failed\n");
			error = -1;
		}
	}
	return error;
}
