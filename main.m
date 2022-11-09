%% Minimum cyclic chain code Representation
% ------------------------------------------------------------
% This program do things as below:
% downsampling
% Boundary Extraction
% Generate 4 chain code, 8 chain code, 
%     differential chain code, and min cyclic chain code representation
% Show Boundary imgs
% -------------------------------------------------------------
% functions：
% sd_ means self defined
%
% main 主函数
% sd_doAll(B,n) 功能集合函数（链码，差分链码，最小循环链码）
% （以下3个在sd_doALL中被调用）
%   [len,Code]=sd_chainCode(B)             生成链码
%   [len,SubCode]=sd_subCode(Code)         生成一阶差分链码
%   [len,Code]=sd_minRepresentation(Code)  生成最小循环链码
%
% sd_edgeMap(I,B)     绘制轮廓图
% im2=sd_rotation(im,n)                  旋转图像90度
% --------------------------------------------------------------
% PS
% 1.The origin is at the upper left corner, x↓, y→
% 2.The differential chain code has the same length with the chain code. 
%    The differential chain code is supplemented by the first digit, 
%    that is, the last digit of the differential chain code is obtained by 
%    subtracting the last digit from the first digit of the chain code
% 3.The processed image is a binary image with only one connected region。
% ----------------------------------------------------------------
% References
% [1] https://blog.csdn.net/mr_muli/article/details/81610668
% [2] https://blog.csdn.net/m0_37407756/article/details/69665182
% [3] https://www.cnblogs.com/Penn000/p/7457201.html
% [4] https://blog.csdn.net/friendan/article/details/8824682

%% 主函数
function main
close all;clear all;clc;
format compact % 输出时压缩空格

I1 = imread('./approximate_triangle.bmp');

I2 = sd_resample(I1); % 20倍减采样，新图像像素数变少,避免生成的链码过长

% 提取轮廓[1]
%I=im2bw(I); % 将I化为一幅二值化图像
% B = bwboundaries(BW,conn)（基本格式） 
%      作用：获取二值图中对象的轮廓，
%            B是一个P×1的cell数组，P为对象个数，每个cell是Q×2的矩阵，对应于对象轮廓像素的坐标。
% B=boundaries(I,8,'cw');
% 寻找轮廓,B为存储轮廓信息的结构体
B1_8=bwboundaries(I2); % 提取 8 邻接轮廓(默认)
B1_4=bwboundaries(I2,4); % 提取 4 邻接轮廓

% 旋转前
sd_doAll(B1_8,8); % 8邻接边界的链码，差分链码，最小循环链码，最小差分链码
sd_doAll(B1_4,4); % 4邻接边界的链码，差分链码，最小循环链码，最小差分链码

% 旋转后
I3=sd_rotation(I1,-90); % 顺时针旋转90度
I4 = sd_resample(I3); % 20倍减采样，新图像像素数变少,避免生成的链码过长
B2_8=bwboundaries(I4); % 提取 8 邻接轮廓(默认)
B2_4=bwboundaries(I4,4); % 提取 4 邻接轮廓
sd_doAll(B2_8,8); % 8邻接边界的链码，差分链码，最小循环链码，最小差分链码
sd_doAll(B2_4,4); % 4邻接边界的链码，差分链码，最小循环链码，最小差分链码


% 创建新窗口并显示图像
figure('Name','链码'); 
subplot(2,4,1);imshow(I1);title('原图');
subplot(2,4,2);imshow(I2);title('减20倍重采样');
subplot(2,4,3);imshow(sd_edgeMap(I2,B1_8));title('8邻接轮廓图');
subplot(2,4,4);imshow(sd_edgeMap(I2,B1_4));title('4邻接轮廓图');
subplot(2,4,5);imshow(I3);title('原图顺时针旋转90度');
subplot(2,4,6);imshow(I4);title('减20倍重采样');
subplot(2,4,7);imshow(sd_edgeMap(I4,B2_4));title('8邻接轮廓图');
subplot(2,4,8);imshow(sd_edgeMap(I4,B2_4));title('4邻接轮廓图');

% 重置输出为默认格式
format
end % main函数结束

%% 功能集合函数（链码，差分链码，最小循环链码）
function sd_doAll(B,n) % B 图像轮廓， n 4邻接，8邻接
% 链码的生成
[len,Code] = sd_chainCode(B,n);
fprintf('\n %d邻接链码：%d 位：\n', n,len)
Code

% 一阶差分链码的生成  
[len,SubCode]=sd_subCode(Code,n);
fprintf('\n %d邻接差分链码：%d 位：\n', n,len)
SubCode

% 最小循环链码（归一化）
[len,MinReCode]=sd_minRepresentation(Code);
fprintf('\n %d链码的最小循环链码：%d 位：\n', n,len)
MinReCode
[len,MinReSubCode]=sd_minRepresentation(SubCode);
fprintf('\n %d链码的最小循环差分链码：%d 位：\n', n,len)
MinReSubCode
disp('--------------------')
end



%% 绘制轮廓图
function  im=sd_edgeMap(I,B)
[M,N]=size(I);
im=zeros(M,N); % 轮廓图存在该数组中
for k=1:length(B)
    boundary=B{k};
    % 第k个轮廓，两列
    %（存在数组变量boundary的第一行里）
    %（从工作区可以看到boundary有80个元素，每个里存了两个值（x，y坐标））
    % 存储轮廓各像素坐标
    for p=1:length(boundary) % 标注第k个轮廓像素所在位置为1
        im(boundary(p,1),boundary(p,2))=1;
    end
end
end


%% 旋转图像90度（换行换列）[4]
function im2=sd_rotation(im,n) % n为旋转度数（逆时针为正数）
%顺时针90度：原第n行变倒数第n列正向（或原第n列变第n行反向）
%逆时针90度：原第n行变第n列反向（或原第n列变倒数第n行正向）
%180度：原第n行变倒数第n行反向（两次90度）
[row,col]=size(im); % row行，col列
if n==-90 % 顺时针90度
    im2=zeros(col,row); % 长方形图片时旋转90度会导致长宽范围不同
    for i=1:row-1
        for j=1:col-1
            im2(j,row-i)=im(i,j); % j：新列正向，row-i：新行倒数
        end
    end
    disp('==========顺时针旋转90度后==========')
elseif n==90 % 逆时针90度
    im2=zeros(col,row);
    for i=1:row-1
        for j=1:col-1
            im2(col-j,i)=im(i,j); % i：新行正向，col-j：新列倒数
        end
    end
    disp('==========逆时针旋转90度后==========')
else % 180度
    im2=zeros(row,col);
    for i=1:row-1
        for j=1:col-1
            im2(row-i,col-j)=im(i,j); % i：新行倒数，j：新列反向
        end
    end
    disp('==========旋转180度后==========')
end
end
