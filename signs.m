clear all;
close all;
clc;
%vid = videoinput('linuxvideo', 1, 'YUYV_640x480');
%set(vid,'ReturnedColorSpace','rgb'); 
 %preview(vid);
 %for(i=1:10)
  %data = getsnapshot(vid);
  %namejpg = ['image',num2str(i),'.jpg'];
  %namepgm = ['image',num2str(i),'.pgm'];
  %imwrite(data,namejpg);
  %imwrite(data,namepgm);
  %pause(1);
 %end
 %delete(vid);
 
 faces = zeros(10,307200);
 for(i=1:10)
 %line = fgetl();
 nameread = ['image',num2str(i),'.pgm'];    
 read = imread(nameread);
 for(j=1:480)
     for(k=1:640)  
      %fprintf('%d %d %d',i,j,k);
      faces(i,(j-1)*640+k)=read(j,k);      
     end
 end
 end
 
 faces = faces'; % 307200x10
 
 media = zeros(307200,1);
 
 for(x=1:307200)
 media(x,1) = mean(faces(x,:)); %307200x1 
 end
 
 for(i=1:10)
    faces(:,i) = faces(:,i)-media(:,1);
 end
 
 cov = faces'*faces;
 [V,D] = eig(cov);
 
 vis=uint8(media);
 vis2=vec2mat(vis,640);
 figure;
 imshow(vis2);
 
 
 eigensign = faces(:,:)*V(:,:); % eigensigns
 
 minimo = min(min(eigensign));
 maximo = max(max(eigensign));
 
 normeigen = ((eigensign - minimo) / (maximo - minimo));
 
 grayeigen = 255*((eigensign - minimo) / (maximo - minimo));
 vis=uint8(grayeigen); 
 
 
 for i=1:10
 vis2=vec2mat(vis(:,i),640);    
 figure; title(i);
 imshow(vis2);
 end
 
 % Weights
 omegaw = eigensign(:,:)'*faces(:,:);
 
 % Adding sign for recognition
 read = double(imread('image4.pgm'));
 for(j=1:480)
     for(k=1:640)  
      %fprintf('%d %d %d',i,j,k);
      newface(1,(j-1)*640+k)=read(j,k);
     end
 end
 
 newface = newface'; % 307200x1
 
 for(i=1:1)
    newface(:,i) = newface(:,i)-media(:,i); 
 end
 
 %New sign weight
 omega = eigensign(:,:)'*newface(:,:);
 
 weight = zeros(10,1);
 
 for i=1:10
     suma = 0;
     for j = 1:10
       suma = suma + (omegaw(j,i)-omega(j,1))^2;
     end
     weight(i,1) = sqrt(suma);
 end
