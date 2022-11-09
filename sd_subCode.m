%% 一阶差分链码的生成（包含重载）
function [len,SubCode]=sd_subCode(Code,n)
Code=[Code,Code(1)]; % 用于生成差分链码时后补第一元素的链码
[~,len]=size(Code); % 读取应计算的位数
% 生成差分链码
SubCode=[];
for i=2:len
    SubCode=[SubCode,mod((Code(i)-Code(i-1)+n),n)]; % 用 mod n 运算求差分链码[3]
end
len=len-1; % 差分链码位数：上述循环的次数，与链码位数相同
end
