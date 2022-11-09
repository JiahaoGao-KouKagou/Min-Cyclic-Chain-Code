%% 边界链码的生成（包含重载）
function [len,Code]=sd_chainCode(B,n)
[len,~]=size(B{1}); % 提取边界的像素点数（B[1]的行数）
Code=[];

for i=2:len
    % 原点位于左上角，x轴指下，y轴指右
    x=B{1}(i,1)-B{1}(i-1,1); % x ↓
    y=B{1}(i,2)-B{1}(i-1,2); % y →
    if n == 8 % 生成8链码时
        if x==1&&y==0
            Code=[Code,0]; % ↓
        elseif x==1&&y==1
            Code=[Code,1]; % ↘
        elseif x==0&&y==1
            Code=[Code,2]; % →
        elseif x==-1&&y==1
            Code=[Code,3]; % ↗
        elseif x==-1&&y==0
            Code=[Code,4]; % ↑
        elseif x==-1&&y==-1
            Code=[Code,5]; % ↖
        elseif x==0&&y==-1
            Code=[Code,6]; % ←
        elseif x==1&&y==-1
            Code=[Code,7]; % ↙
        end
    else % 生成4链码时
        if x==1&&y==0
            Code=[Code,0]; % ↓
        elseif x==0&&y==1
            Code=[Code,1]; % →
        elseif x==-1&&y==0
            Code=[Code,2]; % ↑
        elseif x==0&&y==-1
            Code=[Code,3]; % ←
        end
    end % 4链码8链码重载的if-else
end % for
    len=len-1; % 链码位数：比像素数少1
end
