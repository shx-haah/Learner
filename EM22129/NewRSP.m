init_num = 10000 ;  %三个种群的初始数量 
tot = 3 * init_num ;
papr = init_num ;
scss = init_num ;
rock = init_num ;
pck_1 = 0 ; pck_2 = 0 ;
plyr_1 = 0 ; plyr_2 = 0 ; 

data_pnt = 1000 ;   %数据点的数量
x_axs = 1 : data_pnt ;
p_p = 1 : data_pnt ;
p_s = 1 : data_pnt ;
p_r = 1 : data_pnt ;
tem = 1 ; cnt = 0 ; d_out = 0 ;

while(tem < 100 * data_pnt )
    
    pck_1 = tot * rand(1) ;
    pck_2 = tot * rand(1) ;
    
    if pck_1 < rock plyr_1 = 1 ;    %随机挑选竞争者 , [0,rock)是Rock 
    else 
        if pck_1 < tot - papr plyr_1 = 2 ;  %[rock,rock+scss)是Scissors
        else plyr_1 = 5 ; end   %(rock+scss,tot]是Paper
    end
        
    if pck_2 < rock plyr_2 = 1 ;
    else 
        if pck_2 < tot - papr plyr_2 = 2 ;
        else plyr_2 = 5 ; end
    end
    
    if plyr_1 == plyr_2     %相同则为无效竞争 , 跳过
        continue 
    end
    switch plyr_1
    case 1 
        if plyr_2 == 2 rock=rock+1 ; scss=scss-1 ;
        else rock=rock-5 ; papr=papr+5 ; end 
    case 2
        if plyr_2 == 1 rock=rock+1 ; scss=scss-1 ;
        else scss=scss+2 ; papr=papr-2 ; end 
    case 5
        if plyr_2 == 1 rock=rock-5 ; papr=papr+5 ;
        else scss=scss+2 ; papr=papr-2 ; end
    end
    
    if rock <= 0 || scss <= 0 || papr <= 0  %某一种群灭绝 , 终止
        d_out = 1 ;
        break ;
    end
    
    tem=tem+1 ;
    if cnt < floor(tem/100)     %每竞争100次记录一个数据点
        cnt = floor(tem/100) ;
        p_r(cnt) = rock / tot ;
        p_s(cnt) = scss / tot ;
        p_p(cnt) = papr / tot ;
    end
    
end 

x_axs=100*x_axs ;
if d_out
    plot(x_axs(1 : cnt),p_r(1 : cnt),'k' , x_axs(1 : cnt),p_s(1 : cnt),'b--' , x_axs(1 : cnt),p_p(1 : cnt),'r:') ;
else plot(x_axs,p_r,'k' , x_axs,p_s,'b--' , x_axs,p_p,'r:') ;
end

%计算积分比例
%if d_out
%    p1=trapz(x_axs(1 : cnt) , p_r(1 : cnt)) ; 
%    p2=trapz(x_axs(1 : cnt) , p_s(1 : cnt)) ;
%    p3=trapz(x_axs(1 : cnt) , p_p(1 : cnt)) ;
    
%else
%    p1=trapz(x_axs , p_r) ;
%    p2=trapz(x_axs , p_s) ;
%    p3=trapz(x_axs , p_p) ;
%end

%disp(p1 / (p1 + p2 + p3)) ;
%disp(p2 / (p1 + p2 + p3)) ;
%disp(p3 / (p1 + p2 + p3)) ;
