#pragma once
#include <iostream>

extern "C" {

	int STScramble32(char32_t *stStr, int iKey);
	int STUnscramble32(char32_t *stStr, int iKey);
	int STFill32(char32_t *stStr, char32_t cChr, unsigned int iNum);
	int STLength32(const char32_t *stStr);
	char32_t *STCopy32(char32_t *stDst, const char32_t *stSrc, unsigned int  iLen);

}



/*
 ********************************************************************************
 ***
 ***
 ********************************************************************************
 */


class CString32
{

public:

	CString32();
	CString32(char32_t *str);
	CString32(const CString32 &clSrc);

	CString32 &operator=(const CString32 &clSrc);

	~CString32();

	void Clear();
	void Fill(char32_t cChr, unsigned int iNum);
	void Scramble(int iSeed);
	void Unscramble(int iSeed);

	friend std::wostream &operator<<(std::wostream &ops, const CString32 &clStr);
	friend std::wistream &getline(std::wistream &ops, CString32 &clStr);

public:

	char32_t *m_stData;
	int m_iLen;
};


/*
 ********************************************************************************
 ***
 ***
 ********************************************************************************
 */

