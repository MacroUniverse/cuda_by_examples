% julia fractal
close all; figure;
load('0.julia.mat');
%mattread('0.julia.matt');
imshow(I);
F = getframe(gcf); [I, map] = rgb2ind(F.cdata, 256);
imwrite(I, map, 'julia.gif', 'gif', 'Loopcount', inf, 'DelayTime', 1);
for ii = 1:149
   load([num2str(ii) '.julia.mat']);
   %mattread([num2str(ii) '.julia.matt']);
   imshow(I);
   F = getframe(gcf); [I, map] = rgb2ind(F.cdata, 256);
   imwrite(I, map, 'julia.gif', 'gif', 'WriteMode', ....
        'append', 'DelayTime', 0.1);
end