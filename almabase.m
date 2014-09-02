function almabase(imdir,imresdir)
% imdir = 'images\';
fprintf('Source image directory path: %s\n',imdir);
im_names1 = dir([imdir '*.png']);
im_names2 = dir([imdir '*.jpg']);
im_names3 = dir([imdir '*.jpeg']);
im_names = [im_names1; im_names2; im_names3];
%imresdir = 'results\';
fprintf('Destination image directory path: %s\n',imresdir);
N = length(im_names);
fprintf('Number of Images read from images\\ directory: %d \n', N); 

for p=1:N
    fprintf('Processing Image: %d/%d\n', p, N);
    im=imread([imdir im_names(p).name]);
    H=fspecial('gaussian');
    im=imfilter(im,H);
    
    I=rgb2gray(im);
    K=kmeans_fast_Color(I,5);
    m=max(I(:));
    [r,c]=find(I==m);
    n=K(r(1,1),c(1,1));
    K(K==n)=0;
    K(K~=0)=1;
    %imshow(K);
    
    %K=imcomplement(K);
    
    %K=imfill(K,'holes');
    %figure(1)
    %imshow(K);
    BW = K;
    areaThreshold = 5000;
    CC = bwconncomp(K);
    stats = regionprops(CC,'BoundingBox','Area');
    boxes = round(vertcat(stats(vertcat(stats.Area) > areaThreshold).BoundingBox));
    
    % % numPixels = cellfun(@numel,CC.PixelIdxList);
    % % C=cellfun(@size,CC.PixelIdxList,'uni',false);
    % %  BW=double(BW);
    % % for i=1:length(numPixels)
    % % [biggest,idx] = max(numPixels);
    % % if biggest>10000
    % % BW(CC.PixelIdxList{idx}) = 1;
    % % else
    % % BW(CC.PixelIdxList{idx}) = 0;
    % % end
    % % numPixels(1,idx)=0;
    % % end
    % %
    % %
    % % I0=uint8(BW).*(I);
    % % figure (3)
    % % imshow(I0);
    for i=1:size(boxes,1)
        figure(99)
        imshow(imcrop(im, boxes(i,:)),'Border','tight'); % Display segmented text
        imf=getimage(figure(99));
        f=getframe(gcf);
        [imf2,map]=frame2im(f);
        s=strcat([imresdir im_names(p).name], num2str(i));
        
        s=strcat(s,'.jpg');
        imwrite(imf2,s,'jpg');
    end
    % imf=getimage(figure(3));
    %  f=getframe(gcf);
    %  [imf2,map]=frame2im(f);
    % imwrite(imf2,[imresdir im_names(p).name],'jpg');
end
fprintf('Processing... Done!\n'); 
close all


end