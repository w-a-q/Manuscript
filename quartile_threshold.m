function [Q1, Q2, Q3, IQR, lower_threshold, upper_threshold, low_data, middle_data, high_data] = quartile_threshold(data)
    % QUARTILE_THRESHOLD 计算数据的四分位数、四分位距 (IQR) 以及四分位阈值。
    % 该函数还将数据分为低于下界、中间区域和高于上界的三部分。
    %
    % 输入:
    %   data - 输入数据向量
    %
    % 输出:
    %   Q1 - 第一个四分位数（25th percentile）
    %   Q2 - 第二个四分位数（中位数，50th percentile）
    %   Q3 - 第三个四分位数（75th percentile）
    %   IQR - 四分位距（IQR）
    %   lower_threshold - 下界阈值
    %   upper_threshold - 上界阈值
    %   low_data - 低于下界阈值的数据
    %   middle_data - 在上下阈值之间的数据
    %   high_data - 高于上界阈值的数据
    
    % 计算四分位数
    Q1 = quantile(data, 0.25);  % 第一个四分位数（25th percentile）
    Q2 = quantile(data, 0.50);  % 第二个四分位数（中位数，50th percentile）
    Q3 = quantile(data, 0.75);  % 第三个四分位数（75th percentile）

    % 计算四分位距 (IQR)
    IQR = Q3 - Q1;

    % 计算四分位阈值
    lower_threshold = Q1 - 0.1 * IQR;  % 下界
    upper_threshold = Q3 + 0.1 * IQR;  % 上界

    % 将数据分为三部分
    low_data = data(data < lower_threshold);
    middle_data = data(data >= lower_threshold & data <= upper_threshold);
    high_data = data(data > upper_threshold);
    
    % 可选：打印四分位数和阈值
    fprintf('Q1 (25th percentile): %f\n', Q1);
    fprintf('Q2 (50th percentile, median): %f\n', Q2);
    fprintf('Q3 (75th percentile): %f\n', Q3);
    fprintf('Interquartile Range (IQR): %f\n', IQR);
    fprintf('Lower Threshold: %f\n', lower_threshold);
    fprintf('Upper Threshold: %f\n', upper_threshold);
    fprintf('Number of data points below lower threshold: %d\n', length(low_data));
    fprintf('Number of data points within thresholds: %d\n', length(middle_data));
    fprintf('Number of data points above upper threshold: %d\n', length(high_data));
    
    % 可选：绘制结果
%     figure;
%     histogram(data, 30);
%     hold on;
%     xline(lower_threshold, 'r', 'Lower Threshold');
%     xline(upper_threshold, 'r', 'Upper Threshold');
%     title('Histogram with Quartile Thresholds');
%     xlabel('Data Value');
%     ylabel('Frequency');
%     hold off;
end
