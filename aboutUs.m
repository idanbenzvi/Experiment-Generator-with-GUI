function aboutUs(src,eventData)
% MATLAB CODE:
%Read the Image
TImg=imread('.\images\logo2.jpg');


m=size(TImg,1);
n=size(TImg,2);

if(mod(n,2)~=0)
    n=n-mod(n,2);
end   
if(mod(n,4)~=0)
        n=n-mod(n,4);
end
BImg=uint8(zeros([1 n 3]));
flag=0;
%Values for first column (bbwwbbwwbbww)
for i=1:2:n
    if(flag==1)
            BImg(1,i:i+1,:)=10;
            flag=0;
    else
            BImg(1,i:i+1,:)=240;
            flag=1;
    end
end
%Initialization
A=uint8(zeros([m size(BImg,2) 3]));
Arot=uint8(zeros([m size(BImg,2) 3]));
SImg=uint8(zeros([m size(BImg,2) 3]));
FImg=uint8(zeros([m size(BImg,2) 3]));
A(1,:,:)=BImg(1,:,:);

%Slanting lines
for i=2:m
    BImg=circshift(BImg,[1,-1]);
    A(i,:,:)=BImg(1,:,:);
end




% Steps to perform on foreground Image:
% 1.       Rotate the background image from left to right.
% 2.       Convert the foreground image into binary image and negate it. Then perform image multiplication with the rotated background image.

% MATLAB CODE:
%Flip the image from left to right
Arot(:,:,1)=fliplr(A(:,:,1));
Arot(:,:,2)=fliplr(A(:,:,2));
Arot(:,:,3)=fliplr(A(:,:,3));
%Foreground
BImg=uint8(~im2bw(TImg));
BImg=imresize(BImg,[size(Arot,1) size(Arot,2)]);
SImg(:,:,1)=BImg.*Arot(:,:,1);
SImg(:,:,2)=BImg.*Arot(:,:,2);
SImg(:,:,3)=BImg.*Arot(:,:,3);
SImg(SImg==0)=1;


% Image Mask:
% 1.       Multiply the background image with the binary foreground image to obtain the mask.
% MATLAB CODE:
%Background Image mask
BImg1=uint8(im2bw(TImg));
BImg1=imresize(BImg1,[size(Arot,1) size(Arot,2)]);
FImg(:,:,1)=BImg1.*A(:,:,1);
FImg(:,:,2)=BImg1.*A(:,:,2);
FImg(:,:,3)=BImg1.*A(:,:,3);
FImg(FImg==0)=1;


%Combine Background mask with foreground.
Zig=FImg.*SImg;
figure('Toolbar','none','menubar','none'),imshow(Zig);
end