function [Q1_index, Q2_index, Q3_index] = quartile_method(data)
    % 将数据集排序
    sorted_data = sort(data);
    
    % 计算数据集的大小
    n = length(sorted_data);
    
    % 计算第一个四分位数（Q1）
    if mod(n, 2) == 0
        Q1_index = n / 4;
%         Q1 = (sorted_data(Q1_index) + sorted_data(Q1_index + 1)) / 2;
    else
        Q1_index = (n + 1) / 4;
%         Q1 = sorted_data(Q1_index);
    end
    
    % 计算第二个四分位数（Q2，即中位数）
    if mod(n, 2) == 0
        Q2_index1 = n / 2;
        Q2_index = Q2_index1 + 1;
%         Q2 = (sorted_data(Q2_index1) + sorted_data(Q2_index2)) / 2;
    else
        Q2_index = (n + 1) / 2;
%         Q2 = sorted_data(Q2_index);
    end
    
    % 计算第三个四分位数（Q3）
    if mod(n, 2) == 0
        Q3_index = 3 * n / 4;
%         Q3 = (sorted_data(Q3_index) + sorted_data(Q3_index + 1)) / 2;
    else
        Q3_index = (3 * n + 1) / 4;
%         Q3 = sorted_data(Q3_index);
    end
end