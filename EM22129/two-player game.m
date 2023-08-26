num_s = 2 ;     %可选决策数目 
specs1 = [20000 20000] ;    %参与者1的决策池的初始化
specs2 = [20000 20000] ;    %参与者2的决策池的初始化
tot1 = sum(specs1) ;
tot2 = sum(specs2) ;
pck1 = 0 ; pck2 = 0 ;
plyr1 = 0 ; plyr2 = 0 ; 

val_mat1 = [ 4 -5 ; 5 -3 ] ;    %对于参与者1的收益矩阵
val_mat2 = [ 4 5 ; -5 -3 ] ;    %对于参与者2的收益矩阵

data_pnt = 300 ;   %数据点的数量
propt1 = zeros(data_pnt,num_s) ;
propt2 = zeros(data_pnt,num_s) ;
tem = 1 ; cnt = 0 ;

while( tem < 100 * data_pnt )
    
    pck1 = tot1 * rand(1) ;
    pck2 = tot2 * rand(1) ;
    
    for i = 1 : num_s 
        if pck1 < specs1(i) 
            plyr1 = i ;
            break ;
        else
            pck1 = pck1 - specs1(i) ;
        end
    end
    for i = 1 : num_s
        if pck2 < specs2(i)
            plyr2 = i ;
            break ;
        else
            pck2 = pck2 - specs2(i) ;
        end
    end
        
    specs1(plyr1) = specs1(plyr1) + val_mat1(plyr1,plyr2) ;
    specs2(plyr2) = specs2(plyr2) + val_mat2(plyr1,plyr2) ;
    tot1 = tot1 + val_mat1(plyr1,plyr2) ;
    tot2 = tot2 + val_mat2(plyr1,plyr2) ;
    
    
    tem=tem+1 ;
    if cnt < floor(tem/100)     %每竞争100次记录一个数据点
        cnt = floor(tem/100) ;
        for i = 1 : num_s 
            propt1(cnt,i) = specs1(i) / tot1 ;
            propt2(cnt,i) = specs2(i) / tot2 ;
        end
    end
    
end 

%绘制决策池中决策比例的变化曲线

subplot(211) ;
plot(propt1,'LineWidth',3) ;
legend('show') ;
subplot(212) ;
plot(propt2,'LineWidth',3) ;
legend('show') ;

%计算积分比例

%sp_p1 = trapz(propt1) ;
%sp_p2 = trapz(propt2) ;
%tot1 = sum(sp_p1) ;
%tot2 = sum(sp_p2) ;
%for i = 1 : num_s
%    disp( [sp_p1(i) / tot1 , sp_p2(i) / tot2] ) ;
%end