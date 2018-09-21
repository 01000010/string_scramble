#define __STD_UTF_32__ 

#include <Windows.h>
#include <io.h>
#include <fcntl.h>
#include <stdio.h>
#include <uchar.h>
#include "CString32.h"



extern "C" {

	int STScramble(char32_t *sStr, int iKey);
	int STUnscramble(char32_t *sStr, int iKey);
	int STLength(const char32_t *sStr);
	char32_t *STCopy(char32_t *sDst, const char32_t *sSrc, int iLen);

}

void SetupConsole();
int WriteString32(std::wostream &clOS, const char32_t *stString);

/*
 ********************************************************************************
 ***
 ***
 ********************************************************************************
 */


int _tmain(int argc, _TCHAR* argv[])
{

	_setmode(_fileno(stdout), _O_U16TEXT);
	_setmode(_fileno(stdin), _O_U16TEXT);

	CString32 clInput;
	int iSeed;

	std::wcout << L"Enter String to be Scambled : ";
	getline(std::wcin, clInput);

	std::wcout << L"Enter a numeric scramble key: ";

    while(!(std::wcin >> iSeed)){
		std::wcin.clear();
		std::wcin.ignore(100000, L'\n');
		std::wcout << L"Invalid input. Try again: ";
	}
	std::wcin.ignore(100000, L'\n');

	std::wcout << L"You entered string:           \"" << clInput << L"\"" << std::endl;
	std::wcout << L"Your entered key:             " << iSeed << std::endl;

	clInput.Scramble(iSeed);

	std::wcout << L"Your scrambled string is:     \"" << clInput << L"\"" << std::endl;

	clInput.Unscramble(iSeed);

	std::wcout << L"Your unscrambled string is:   \"" << clInput << L"\"" << std::endl;


	getwchar();
	return 0;
}



