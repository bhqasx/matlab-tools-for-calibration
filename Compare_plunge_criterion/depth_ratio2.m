function hr=depth_ratio2(ksi)
%连续、动量、伯努利三方程联立得到的异重流深度比

aa=1;
bb=-3;
cc=3-ksi;
dd=-1-ksi;

hr=roots([aa,bb,cc,dd]);