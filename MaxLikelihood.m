close all;
clc;
time = ScopeData6_MuXianDianYa.time;
MuxianDianYa = ScopeData6_MuXianDianYa.signals.values;
MuXanDianLiu = ScopeData7_MuxianDianliu.signals.values;
Line1DianYa = ScopeData1_Line1DianYa.signals.values;
Line2DianYa = ScopeData8_Line2DianYa.signals.values;
Line3DianYa = ScopeData9_Line3DianYa.signals.values;
Line4DianYa = ScopeData8_Line4DianYa.signals.values;
Line5DianYa = ScopeData8_Line5DianYa.signals.values;
Line6DianYa = ScopeData2_Line6DianYa.signals.values;
Line1DianLiu = ScopeData2_Line1DianLiu.signals.values;
Line2DianLiu = ScopeData3_Line2DianLiu.signals.values;
Line3DianLiu = ScopeData4_Line3_DianLiu.signals.values;
Line4DianLiu = ScopeData9_Line4DianLiu.signals.values;
Line5DianLiu = ScopeData9_Line5DianLiu.signals.values;
Line6DianLiu = ScopeData1_Line6DianLiu.signals.values;
clear ScopeData6_MuXianDianYa ScopeData7_MuxianDianliu ScopeData1_Line1DianYa ScopeData8_Line2DianYa ScopeData9_Line3DianYa ...
    ScopeData8_Line4DianYa ScopeData8_Line5DianYa ScopeData2_Line1DianLiu ScopeData3_Line2DianLiu ScopeData4_Line3_DianLiu ...
    ScopeData9_Line4DianLiu ScopeData9_Line5DianLiu ScopeData2_Line6DianYa ScopeData1_Line6DianLiu;
figure(1);
plot(time,Line1DianLiu);
title('线路1电流');
ylabel('电流/A');
xlabel('时间/s');
figure(2);
plot(time,Line2DianLiu);
title('线路2电流');
ylabel('电流/A');
xlabel('时间/s');
figure(3);
plot(time,Line3DianLiu);
title('线路3电流');
ylabel('电流/A');
xlabel('时间/s');
figure(4);
plot(time,Line4DianLiu);
title('线路4电流');
ylabel('电流/A');
xlabel('时间/s');
figure(5);
plot(time,Line5DianLiu);
title('线路5电流');
ylabel('电流/A');
xlabel('时间/s');
figure(6);
plot(time,Line6DianLiu);
title('线路6电流');
ylabel('电流/A');
xlabel('时间/s');
figure(7);
plot(time,MuxianDianYa);
title('母线电压');
ylabel('电压/V');
xlabel('时间/s');
%%%上面导入数据和画图完毕,下面对数据进行最大似然估计%%%%%
T=(time(2)-time(1));
XianluTiaoShu = 6;% 线路条数
LengthOfPoint=length(time);%点数
t=0.04;%%故障发生时间,仿真里面设置的
Number=2000;%每个样本个数 相当于一个周期
% fai=zeros(Number,6);%定义fai
fai=zeros(Number,5);%定义fai
CL = zeros(1,XianluTiaoShu);
for Ln=1:XianluTiaoShu
    C=[];
    LineLine = eval(strcat('Line',num2str(Ln),'DianLiu'));
    for N_Start= round(t/T)+400:50:LengthOfPoint
        if N_Start+Number+1>LengthOfPoint
            break;
        end
        Y = MuxianDianYa(N_Start+1:N_Start+Number);
        for i=1:Number
            fai(i,1) = LineLine(N_Start+i);%%这里对应k
            fai(i,2)= -(MuxianDianYa(N_Start+i+1) - MuxianDianYa(N_Start+i-1))/(4);
            fai(i,3)= (LineLine(N_Start+i+1) - LineLine(N_Start+i-1))/2;
            fai(i,4)= -(MuxianDianYa(N_Start+i+1)-2*MuxianDianYa(N_Start+i)+MuxianDianYa(N_Start+i-1))/(2);
            temp=sum(LineLine(N_Start:N_Start+i-1));
            fai(i,5)= 2*(LineLine(N_Start+i)/2+temp);
%             fai(i,6)= -MuxianDianYa(N_Start+i+3);
        end
        fai1=fai(:,1);
        fai2=fai(:,2);
        fai3=fai(:,3);
        fai4=fai(:,4);
        fai5=fai(:,5);
%         fai6=fai(:,6);
%         A=[fai1'*fai1+fai1'*fai1,fai1'*fai2+fai2'*fai1,fai1'*fai3+fai3'*fai1,fai1'*fai4+fai4'*fai1,fai1'*fai5+fai5'*fai1,fai1'*fai6+fai6'*fai1;
%            fai2'*fai1+fai1'*fai2,fai2'*fai2+fai2'*fai2,fai2'*fai3+fai3'*fai2,fai2'*fai4+fai4'*fai2,fai2'*fai5+fai5'*fai2,fai2'*fai6+fai6'*fai2;
%            fai3'*fai1+fai1'*fai3,fai3'*fai2+fai2'*fai3,fai3'*fai3+fai3'*fai3,fai3'*fai4+fai4'*fai3,fai3'*fai5+fai5'*fai3,fai3'*fai6+fai6'*fai3;
%            fai4'*fai1+fai1'*fai4,fai4'*fai2+fai2'*fai4,fai4'*fai3+fai3'*fai4,fai4'*fai4+fai4'*fai4,fai4'*fai5+fai5'*fai4,fai4'*fai6+fai6'*fai4;
%            fai5'*fai1+fai1'*fai5,fai5'*fai2+fai2'*fai5,fai5'*fai3+fai3'*fai5,fai5'*fai4+fai4'*fai5,fai5'*fai5+fai5'*fai5,fai5'*fai6+fai6'*fai5];
% %            fai6'*fai1+fai1'*fai6,fai6'*fai2+fai2'*fai6,fai6'*fai3+fai3'*fai6,fai6'*fai4+fai4'*fai6,fai6'*fai5+fai5'*fai6,fai6'*fai6+fai6'*fai6];
        A=[fai1'*fai1+fai1'*fai1,fai1'*fai2+fai2'*fai1,fai1'*fai3+fai3'*fai1,fai1'*fai4+fai4'*fai1,fai1'*fai5+fai5'*fai1;
           fai2'*fai1+fai1'*fai2,fai2'*fai2+fai2'*fai2,fai2'*fai3+fai3'*fai2,fai2'*fai4+fai4'*fai2,fai2'*fai5+fai5'*fai2;
           fai3'*fai1+fai1'*fai3,fai3'*fai2+fai2'*fai3,fai3'*fai3+fai3'*fai3,fai3'*fai4+fai4'*fai3,fai3'*fai5+fai5'*fai3;
           fai4'*fai1+fai1'*fai4,fai4'*fai2+fai2'*fai4,fai4'*fai3+fai3'*fai4,fai4'*fai4+fai4'*fai4,fai4'*fai5+fai5'*fai4;
           fai5'*fai1+fai1'*fai5,fai5'*fai2+fai2'*fai5,fai5'*fai3+fai3'*fai5,fai5'*fai4+fai4'*fai5,fai5'*fai5+fai5'*fai5];
        YY=[fai1'*Y+Y'*fai1;
            fai2'*Y+Y'*fai2;
            fai3'*Y+Y'*fai3;
            fai4'*Y+Y'*fai4;
            fai5'*Y+Y'*fai5].*2;
%             fai6'*Y+Y'*fai6].*2;
        if rank(A)==5
            sita = (A\YY)';
        else
            sita=(pinv(A)*YY)';
            warning('矩阵非奇异，此时的计算结果可能有误');
        end
%         sita=sita.*[1 T T T^2 1/T 1];
        sita=sita.*[1 T T T^2 1/T];
        C_temp =sita(2)/sita(1);
        C=[C C_temp];
    end
    C=unique(C(~isnan(C)));
    C=unique(C(~isinf(C))); 
    BeifenC=C;
    CP=[];
    CN=[];
    C(1:2)=[];
    C(length(C)-2:end)=[];
    figure;
    plot(C);
    title(strcat('线路',num2str(Ln),'电容参数估计值'));
    xlabel('次数');
    ylabel('电容估计值/F');
    for mm=1:length(C)
        if C(mm)> 0
            CP=[CP C(mm)];
        else
            CN=[CN C(mm)];
        end
    end
    if length(CP)>length(CN)
        if sum(C)>0
            C = sum(C)/length(C);
        else
             C = sum(CP)/length(CP);
        end
    else
        if sum(C)<0
            C=sum(C)/length(C);
        else
            C = sum(CN)/length(CN);
        end
    end
%     C = sum(C)/length(C);
    CL(Ln) = C;
end
CL= -CL/2 %电容估计值
LineLength = [5 10 12 15 20 5]; %在仿真中设置的线路长度 要与仿真中的长度对应
% LineLength = [6 18 20 25 30 10]; %在仿真中设置的线路长度 要与仿真中的长度对应
CTH = LineLength*6e-9 %理论值



