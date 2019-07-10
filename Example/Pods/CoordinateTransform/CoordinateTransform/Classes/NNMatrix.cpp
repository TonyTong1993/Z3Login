//
//  NNMatrix.cpp
//  管网宝
//
//  Created by ZONDY on 12-12-17.
//  Copyright (c) 2012年 ZONDY. All rights reserved.
//

#include "NNMatrix.h"

#include <cmath>
#include <string>
using namespace std;
NNMatrix::NNMatrix(int Mrow, int Mcol)
{
	row = Mrow;
	col = Mcol;
    
	Matrix = new double*[row];
    
	for (int i = 0; i < row; ++i)
	{
		Matrix[i] = new double[col];
	}
    
	for(int j=0;j<row;j++)
	{
		for(int k=0;k<col;k++)
		{
			Matrix[j][k] = 0;
		}
	}
}
void NNMatrix::swaper(double &m1, double &m2)
{
	double sw;
	sw = m1;
	m1 = m2;
	m2 = sw;
}
NNMatrix NNMatrix::Invers(NNMatrix &srcm)           //æÿ’Û«ÛƒÊ
{
	int rhc = srcm.row;
	if (srcm.row == srcm.col)
	{
		int *iss = new int[rhc];
		int *jss = new int[rhc];
        
		for (int i = 0; i < rhc; ++i)
		{
			iss[i] = jss[i] = 0;
		}
        
		double fdet = 1;
		double f = 1;
		//œ˚‘™
		for (int k = 0; k < rhc; k++)
		{
			double fmax = 0;
			for (int i = k; i < rhc; i++)
			{
				for (int j = k; j < rhc; j++)
				{
					f = fabs(srcm.Matrix[i][j]);
					if (f > fmax)
					{
						fmax = f;
						iss[k] = i;
						jss[k] = j;
					}
				}
			}
            
			if (iss[k] != k)
			{
				f = -f;
				for (int ii = 0; ii < rhc; ii++)
				{
					srcm.swaper(srcm.Matrix[k][ii], srcm.Matrix[iss[k]][ii]);
				}
			}
            
			if (jss[k] != k)
			{
				f = -f;
				for (int ii = 0; ii < rhc; ii++)
				{
					srcm.swaper(srcm.Matrix[k][ii], srcm.Matrix[jss[k]][ii]);
				}
			}
            
			fdet *= srcm.Matrix[k][k];
			srcm.Matrix[k][k] = 1.0 / srcm.Matrix[k][k];
			for (int j = 0; j < rhc; j++)
				if (j != k)
					srcm.Matrix[k][j] *= srcm.Matrix[k][k];
            
			for (int i = 0; i < rhc; i++)
				if (i != k)
					for (int j = 0; j < rhc; j++)
						if (j != k)
							srcm.Matrix[i][j] = srcm.Matrix[i][j] - srcm.Matrix[i][k] * srcm.Matrix[k][j];
            
			for (int i = 0; i < rhc; i++)
				if (i != k)
					srcm.Matrix[i][k] *= -srcm.Matrix[k][k];
		}
		// µ˜’˚ª÷∏¥––¡–¥Œ–Ú
		for (int k = rhc - 1; k >= 0; k--)
		{
			if (jss[k] != k)
				for (int ii = 0; ii < rhc; ii++)
					srcm.swaper(srcm.Matrix[k][ii], srcm.Matrix[jss[k]][ii]);
			if (iss[k] != k)
				for (int ii = 0; ii < rhc; ii++)
					srcm.swaper(srcm.Matrix[k][ii], srcm.Matrix[iss[k]][ii]);
		}
		delete []iss;
		delete []jss;
	}
	return srcm;
}



NNMatrix operator +(NNMatrix  &m1, NNMatrix &m2)   //æÿ’Ûº”∑®
{
	if (m1.row == m2.row && m1.col == m2.col)
		for (int i = 0; i < m1.row;i++)
			for (int j = 0; j < m1.col;j++)
				m1.Matrix[i][j]+=m2.Matrix[i][j];
	return (m1);
}

NNMatrix operator +(NNMatrix &m1, double m2)    //æÿ’Ûº”≥£¡ø
{
	for (int i = 0; i < m1.row; i++)
		for (int j = 0; j < m1.col; j++)
			m1.Matrix[i][j] += m2;
	return (m1);
}

NNMatrix operator -(NNMatrix &m1, NNMatrix &m2)  //æÿ’Ûºı∑®
{
	if (m1.row == m2.row && m1.col == m2.col)
		for (int i = 0; i < m1.row; i++)
			for (int j = 0; j < m1.col; j++)
				m1.Matrix[i][j] -= m2.Matrix[i][j];
	
	return (m1);
}

NNMatrix operator *(NNMatrix &m1, NNMatrix &m2) //æÿ’Û≥À∑®
{
	int m3r = m1.row;
	int m3c = m2.col;
	NNMatrix m3(m3r, m3c);
    
	if (m1.col == m2.row)
	{
		double value = 0.0;
		for (int i = 0; i < m3r; i++)
			for (int j = 0; j < m3c; j++)
			{
				value = 0.0f;
				for (int ii = 0; ii < m1.col; ii++)
					value += m1.Matrix[i][ii] * m2.Matrix[ii][j];
                
				m3.Matrix[i][j] = value;
			}
	}
    
	return m3;
}

NNMatrix operator *(NNMatrix &m1, double m2) //æÿ’Û≥À“‘≥£¡ø
{
	for (int i = 0; i < m1.row; i++)
		for (int j = 0; j < m1.col; j++)
			m1.Matrix[i][j] *= m2;
	return (m1);
}

NNMatrix Transpos(NNMatrix &srcm)  //æÿ’Û◊™÷»
{
	NNMatrix tmpm(srcm.col, srcm.row);
    
	for (int i = 0; i < srcm.row; i++)
		for (int j = 0; j < srcm.col; j++)
		{
			if (i != j)
			{
				tmpm.Matrix[j][i] = srcm.Matrix[i][j];
			}
			else
				tmpm.Matrix[i][j] = srcm.Matrix[i][j];
		}
	return tmpm;
}
