//  NNMatrix.h
//  管网宝
//
//  Created by ZiZhengzhuan on 12-12-17.
//  Copyright (c) 2012年 ZONDY. All rights reserved.
//
#ifndef _______nnMatrix__
#define _______nnMatrix__
class NNMatrix
{
public:
	NNMatrix(int Mrow, int Mcol);
public:
	int row, col;
	double **Matrix;
	void swaper(double &m1, double &m2);
public:
	friend NNMatrix operator +(NNMatrix &m1, NNMatrix &m2);
	friend NNMatrix operator +(NNMatrix &m1, double m2);
	friend NNMatrix operator -(NNMatrix &m1, NNMatrix &m2);
	friend NNMatrix operator *(NNMatrix &m1, NNMatrix &m2);
	friend NNMatrix operator *(NNMatrix &m1, double m2);
	friend NNMatrix Transpos(NNMatrix &srcm);
	static NNMatrix Invers(NNMatrix &srcm);
};
#endif /* defined(_______nnMatrix__) */
