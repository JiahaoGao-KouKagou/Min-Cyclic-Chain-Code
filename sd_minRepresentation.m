%% 最小循环链码的生成[3]
function [len,Code]=sd_minRepresentation(Code)
[~,len]=size(Code); % 读取链码的位数（列数)
Code=[Code,Code]; % 将链码复制一倍接在后面（假循环）

i=1; j=2; k=0; % i为最小循环链码开始位，j在i前面探测，k为i和j的探测长度（i、j同时向前探测k位）
while i<len && j<len &&  k<len % 找最小开始位i
    if Code(i+k) == Code(j+k) % 同权位相同（高频情况，先判断），不做处理，继续向后探测
        k=k+1;
    else % 同权位不同时，分两种情况：j探测到更大的（上升）/j探测到更小的（下降）
        if Code(i+k) < Code(j+k) % j探测到上升时
            j=j+k+1; % i开头的数仍然是最小的，j后移到以探测到上升的下一位
        else % Code(i+k) > Code(j+k) % j探测到下降时，又分两种情况
            if Code(j+k) >= Code(i) % j探测到的下降只是相对于i的同权位，而不比最高位小
                i=j; j=i+1; % 将i拉到j的位置，j再站到i前一位，开始新一轮探测（使i在平滑区开头）
            else % Code(j+k) < Code(i) % j探测到了有史以来最小的一位
                j=j+k; i=j; j=i+1; % 先把j标到最小的那一位上，再同上（使i在最小位上）
            end % 是否找到有史以来最小
        end % 上升或下降
        k=0; % 每次对i、j改动后k归零（有效探测）
    end % 平滑或起伏
end % while
Code=Code(1,i:i+len-1); % 截取从第i位开始的len位为最小循环（包括第i位，故截止到i+len-1）
end % function

