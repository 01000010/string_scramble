#include "CString32.h"

/*
 ********************************************************************************
 ***
 ***
 ********************************************************************************
 */

CString32::CString32()
{
	m_stData = 0;
	m_iLen = 0;
}

/*
 ********************************************************************************
 ***
 ***
 ********************************************************************************
 */

CString32::CString32(char32_t *str)
{
	this->m_iLen = STLength32(str);
	int iLen = this->m_iLen + 1;
	m_stData = new char32_t[iLen];
	STCopy32(m_stData, str, iLen);
}

/*
 ********************************************************************************
 ***
 ***
 ********************************************************************************
 */

CString32::CString32(const CString32 &clSrc)
{
	this->m_iLen = clSrc.m_iLen;
	if (clSrc.m_stData) {
		int iLen = this->m_iLen + 1;
		m_stData = new char32_t[iLen];
		STCopy32(m_stData, clSrc.m_stData, iLen);
	} else {
		m_stData = 0;
	}
}


/*
 ********************************************************************************
 ***
 ***
 ********************************************************************************
 */

CString32 &CString32::operator=(const CString32 &clSrc)
{
	if (m_stData) {
		delete[] this->m_stData;
		this->m_iLen = 0;
	}
	if (clSrc.m_stData) {
		this->m_iLen = clSrc.m_iLen;
		int iLen = this->m_iLen + 1;
		m_stData = new char32_t[iLen];
		STCopy32(this->m_stData, clSrc.m_stData, iLen);
	}
	return *this;
}

/*
 ********************************************************************************
 ***
 ***
 ********************************************************************************
 */

CString32::~CString32()
{
	if (m_stData) {
		delete[] m_stData;
	}
}

/*
 ********************************************************************************
 ***
 ***
 ********************************************************************************
 */

inline void CString32::Clear()
{
	if (m_stData) {
		delete[] m_stData;
		m_stData = 0;
		m_iLen = 0;
	}
}

/*
 ********************************************************************************
 ***
 ***
 ********************************************************************************
 */

void CString32::Fill(char32_t cChr, unsigned int iLen)
{
	if (m_stData) {
		delete[] m_stData;
	}
	this->m_iLen = iLen;
	m_stData = new char32_t[iLen+1];
	STFill32(this->m_stData, cChr, iLen);
	m_stData[iLen] = 0;
}
/*
 ********************************************************************************
 ***
 ***
 ********************************************************************************
 */

void CString32::Scramble(int iSeed)
{
	if (m_stData) {
		STScramble32(this->m_stData, iSeed);
	}
}

/*
 ********************************************************************************
 ***
 ***
 ********************************************************************************
 */

void CString32::Unscramble(int iSeed)
{
	if (m_stData) {
		STUnscramble32(this->m_stData, iSeed);
	}
}

/*
 ********************************************************************************
 ***
 ***
 ********************************************************************************
 */

std::wostream& operator<<(std::wostream& ost, const CString32& clStr)
{
	if (clStr.m_stData) {

		int iLen = STLength32(clStr.m_stData);

		wchar_t *stBuf16 = (wchar_t *)alloca((iLen + 1) * sizeof(wchar_t));

		for (int i = 0; i < iLen; ++i) {
			stBuf16[i] = (wchar_t)clStr.m_stData[i];
		}
		stBuf16[iLen] = (wchar_t)0;

		ost << stBuf16;
	}

	return ost;

}

/*
 ********************************************************************************
 ***
 ***
 ********************************************************************************
 */

std::wistream &getline(std::wistream &ips, CString32 &clStr)
{
	wchar_t clBuff[1000];
	ips.getline(clBuff,1000);
    int iLen = (int) ips.gcount();
	clStr.Fill(U'\0', iLen);
	for (int i = 0; i < iLen; ++i) {
		*reinterpret_cast<wchar_t *>(&clStr.m_stData[i]) = clBuff[i];
	}
	return ips;
}
