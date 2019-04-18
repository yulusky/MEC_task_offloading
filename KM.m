function match = KM(r)
    %r 输入的权重矩阵
    %r=[2 2 4 0 0;3 0 0 0 0;0 0 2 1 0;0 0 0 3 8;0 0 0 2 3]
    %正确配对为3,1,2,5,4
    %r = [3,0,10,2;2,1,3,2;0,0,5,9];
    % r=[0.572727272727273,0.692307692307692,0.585074626865672];
    global g_map;
    global g_m;
    global g_n;
    global g_label_value_x;
    global g_label_value_y;
    global g_match_x;
    global g_match_y;
    global g_min_weight_diff;
    global g_visible_x;
    global g_visible_y;
%%
    %init
    [g_m,g_n]=size(r);
    g_map = r;
    g_label_value_x = zeros(g_m,1);
    g_label_value_y = zeros(g_n,1);
    g_match_x = ones(g_m,1)*-1;
    g_match_y = ones(g_n,1)*-1;
    for i=1:g_m
        for j=1:g_n
            if g_label_value_x(i)<g_map(i,j)
                g_label_value_x(i) = g_map(i,j);
            end
        end
    end
%%
    %KM-algorithm
    for i =1:g_m
        while(1)
            g_min_weight_diff=10^10;
            g_visible_x = zeros(g_m,1);
            g_visible_y = zeros(g_n,1);
            if dfs(i)
                break;
            end
            for j=1:g_m
                if g_visible_x(j)
                    g_label_value_x(j)=g_label_value_x(j)-g_min_weight_diff;
                end
            end
            for j=1:g_n
                if g_visible_y(j)
                    g_label_value_y(j)=g_label_value_y(j)+g_min_weight_diff;
                end
            end
        end   
    end
    match = g_match_x;
 
 
function res=dfs(i)
    global g_map;
    global g_m;
    global g_n;
    global g_label_value_x;
    global g_label_value_y;
    global g_match_x;
    global g_match_y;
    global g_min_weight_diff;
    global g_visible_x;
    global g_visible_y;
 
    g_visible_x(i) = 1;
    for j =1:g_n
        if(~g_visible_y(j))
            tmp = g_label_value_x(i)+g_label_value_y(j)-g_map(i,j);
            if tmp<10^-5
                g_visible_y(j)=1;
                if(g_match_y(j)==-1||dfs(g_match_y(j)))
                    g_match_x(i)=j;
                    g_match_y(j)=i;
                    res=true;
                    return
                end
            elseif tmp>0
                if tmp<g_min_weight_diff
                    g_min_weight_diff  =tmp;
                end
            end
        end
    end
    res = false;
