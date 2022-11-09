%% 20倍减采样，新图像像素数变少[2]
% 避免生成的链码过长
function imgOutput = sd_resample(imgInput)
[line,row]=size(imgInput);%读取图像像素
L=1; R=1;

for i=1:20:line; % 步长为20
    for j=1:20:row; % 在第i列对原图像没20行采样一次
        imgOutput(L,R)=imgInput(i,j);
        R=R+1;%取原图像i列下一行的元素赋给新图像的对应位置
    end
    L=L+1;%换列
    R=1;%从换列后的列里的第一个元素开始取元素
end
end

