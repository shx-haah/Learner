#include "stdafx.h"
#include "cv.h"                             //  OpenCV 文件头
#include "highgui.h"
#include "cvaux.h"
#include "cxcore.h"
//#include "opencv2/shape.hpp"
#include "opencv2/opencv.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include <iostream>
#include <string>
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include <opencv2/core/core.hpp> 
#include <vector>
#include <opencv2/highgui/highgui.hpp>  
#include <opencv2/imgproc.hpp>


using namespace std;
using namespace cv;

//函数声明
Mat ReSize(Mat imgArr ,int maxWidth, int maxHeight);//调整图像尺寸
Mat ImgProcess(Mat reSizeImg);
//vector<vector<Point> > FindContour(Mat processImg);
int main() {
 
	//创建窗口
	//namedWindow("Car原画");
	//namedWindow("Car灰度图");

    //定义变量
	Mat grayImg;
	Mat img = imread("car.jpg");
	int maxWindowWidth=400;
	int maxWindowHeight=300;
	//转换颜色空间
	cvtColor(img, grayImg, COLOR_BGR2GRAY);
	
	Mat  grayImgResize= ReSize(grayImg, maxWindowWidth, maxWindowHeight);
	
	imshow("gray_img", grayImgResize);
	Mat imgPro = ImgProcess(grayImgResize);
	imshow("img", imgPro);
	waitKey(0);
	destroyAllWindows();
}
//当输入图像尺寸的宽度大于1000（默认）时，将图像按比例缩小
Mat ReSize(Mat imgArr,int maxWidth,int maxHeight) {
	Mat imgReSize;
	double changeXRate = 0.0;
	double changeYRate = 0.0;
	Size dsize =Size(maxWidth, maxHeight);//尺寸类
 
	int width = imgArr.cols;
	int height = imgArr.rows;
	if (width > maxWidth) {
		changeXRate = maxWidth / width;
	}
	resize(imgArr, imgReSize, dsize, changeXRate, changeYRate);
   
	return imgReSize;
}
Mat ImgProcess(Mat reSizeImg) {
	Mat  imgPro;
	Size kSize = Size(5,5);//尺寸类--高斯内核尺寸
	Mat contourImg;
	Mat thresholdImg;
	Mat edgesImg;
	Mat openingImg;
	Mat closingImg;
	//高斯滤波
	Mat imgGauss;
	GaussianBlur(reSizeImg, imgGauss, kSize, 0, 0, BORDER_DEFAULT);
	Size mSize = Size(23, 23);
	Point mPoint = Point(-1, -1);//二维图像的点类--高斯内核锚点位置
	Mat kernel = getStructuringElement(MORPH_RECT, mSize, mPoint);//获取形态学处理所需的结构化元素
	Mat imgOpening;
	//开运算（先腐蚀后膨胀）
	morphologyEx(imgGauss, imgOpening, MORPH_OPEN, kernel, mPoint,2, BORDER_DEFAULT, morphologyDefaultBorderValue());
	addWeighted(reSizeImg,1, imgOpening,-1,0, imgOpening,-1);//将两张相同大小，相同类型的图片融合
	imshow("img_opening", imgOpening);
	//  找到图像边缘
	threshold(imgOpening, thresholdImg, 0, 255, THRESH_BINARY + THRESH_OTSU);//阈值化函数
	imshow("img_thresh", thresholdImg);
	Canny(thresholdImg, edgesImg, 100, 200, 3, false);//边缘检测函数
	imshow("img_edge", edgesImg);
	//使用开运算和闭运算让图像边缘成为一个整体
	Size mSize1 = Size(7, 7);
	Point mPoint1 = Point(-1, -1);
	Mat kernel1 = getStructuringElement(MORPH_RECT, mSize1, mPoint1);
	morphologyEx(edgesImg, closingImg, MORPH_CLOSE, kernel1, mPoint1, 2, BORDER_DEFAULT, morphologyDefaultBorderValue());
	Size mSize2 = Size(7, 7);
	Mat kernel2 = getStructuringElement(MORPH_RECT, mSize2, mPoint1);
	morphologyEx(closingImg, openingImg, MORPH_OPEN, kernel2, mPoint1, 2, BORDER_DEFAULT, morphologyDefaultBorderValue());
	imshow("img_edge2", openingImg);
	//查找图像边缘整体形成的矩形区域，可能有很多，车牌就在其中一个矩形区域中
 
	vector<vector<Point> > contoursArrs;
	vector<Vec4i> hierarchy;
	findContours(openingImg, contoursArrs, hierarchy, RETR_TREE, CHAIN_APPROX_SIMPLE);
	//"CHAIN_APPROX_SIMPLE": 仅保存轮廓的拐点信息
	
	vector<vector<Point> > tempContoursArrs(contoursArrs.size());
	
	int k = 0;
	for (size_t i = 0; i < contoursArrs.size(); i++) {
		
		if (contourArea(contoursArrs[i], false) > 2000) {
			tempContoursArrs[k] = contoursArrs[i];
			k++;
			cout << contourArea(contoursArrs[i], false)<<endl;
			
		}
	}
	vector<RotatedRect> minRotatedRect(k);
	vector<Rect>  minRect(k);
	for (size_t i = 0; i < k; i++) {
		minRotatedRect[i]=minAreaRect(tempContoursArrs[i]);
	
		cout << minRotatedRect[i].size<< endl;
		double ratio = minRotatedRect[i].size.width / minRotatedRect[i].size.height;
		int m = 0;
		vector<vector<Point> > PlateContoursArrs(k);
		if ((ratio > 3.0 && ratio <3.3)) {
			RNG rng(12345);
			PlateContoursArrs[m] = tempContoursArrs[i];
			vector<RotatedRect>	plateRotatedRect(k);
		    plateRotatedRect [m]= minAreaRect(PlateContoursArrs[m]);
			
			Scalar color = Scalar(rng.uniform(0, 256), rng.uniform(0, 256), rng.uniform(0, 256));
			drawContours(reSizeImg, PlateContoursArrs, (int)0, color);
			Point2f rect_points[4];
			minRotatedRect[i].points(rect_points);
			for (int j = 0; j < 4; j++)
			{
				line(reSizeImg, rect_points[j], rect_points[(j + 1) % 4], color);
			}
			imshow("ContoursLine", reSizeImg);
			//提取图片
			Rect brect = plateRotatedRect[m].boundingRect(); //返回包含旋转矩形的最小矩形  
			//rectangle(reSizeImg, brect, color, 1, 8, 0);
			rectangle(reSizeImg, brect, Scalar(0, 0, 255));
			imshow("RectImg'", reSizeImg);
			m++;
		}
	}
	
	imgPro = imgOpening;
 
	return imgPro;
 
}