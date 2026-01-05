%Q2.1
Pc = imread('mrt-train.jpg');
whos Pc
P = rgb2gray(Pc);

figure;
imshow(P)
min(P(:)), max(P(:))

P2 = imsubtract(P, double(min(P(:))));
P2 = immultiply(P2, 255 / double(max(P(:)) - min(P(:))));
min(P2(:)), max(P2(:))

figure;
imshow(P2)
%% 
%Q2.2
figure;
imhist(P,10);

figure;
imhist(P,256);

P3 = histeq(P,255);
figure;
imhist(P3,10);
figure;
imhist(P3,256);

P3A = histeq(P3,255);
figure;
imhist(P3A,10);
figure;
imhist(P3A,256);
%%
%Q2.3
sigma1 = 1.0;
sigma2 = 2.0;
n = 2;
[x, y] = meshgrid(-n:n, -n:n);

h1 = exp(-(x.^2 + y.^2) / (2 * sigma1^2)) / (2 * pi * sigma1^2);
h1 = h1 / sum(h1(:));

figure;
mesh(x, y, h1);
title('Gaussian Filter (5×5, σ = 1.0)');
xlabel('x'); ylabel('y'); zlabel('h(x,y)');

h2 = exp(-(x.^2 + y.^2) / (2 * sigma2^2)) / (2 * pi * sigma2^2);
h2 = h2 / sum(h2(:));

figure;
mesh(x, y, h2);
title('Gaussian Filter (5×5, σ = 2.0)');
xlabel('x'); ylabel('y'); zlabel('h(x,y)');

lib_img = imread('lib-gn.jpg');
figure;
imshow(lib_img)
title('Original');
Igray = im2gray(lib_img);    
Igray = im2double(Igray);   

I_filt1 = conv2(Igray, h1, 'same');    % σ = 1.0
I_filt2 = conv2(Igray, h2, 'same');    % σ = 2.0

figure;
imshow(I_filt1);
title('Filtered (σ = 1.0)');

figure;
imshow(I_filt2);
title('Filtered (σ = 2.0)');

lib_img1 = imread('lib-sp.jpg');
figure;
imshow(lib_img1)
title('Original');
Igray1 = im2gray(lib_img1);         
Igray1 = im2double(Igray1);   

I_filt1 = conv2(Igray1, h1, 'same');    % σ = 1.0
I_filt2 = conv2(Igray1, h2, 'same');    % σ = 2.0

figure;
imshow(I_filt1);
title('Filtered (σ = 1.0)');

figure;
imshow(I_filt2);
title('Filtered (σ = 2.0)');

%%
%Q2.4
I_med3 = medfilt2(Igray, [3 3]);   % 3×3 neighbourhood
I_med5 = medfilt2(Igray, [5 5]);   % 5×5 neighbourhood

figure;
imshow(Igray);
title('Original Image');

figure;
imshow(I_med3);
title('Median Filtered (3×3)');

figure;
imshow(I_med5);
title('Median Filtered (5×5)');

I_med3 = medfilt2(Igray1, [3 3]);   % 3×3 neighbourhood
I_med5 = medfilt2(Igray1, [5 5]);   % 5×5 neighbourhood

figure;
imshow(Igray1);
title('Original Image');

figure;
imshow(I_med3);
title('Median Filtered (3×3)');

figure;
imshow(I_med5);
title('Median Filtered (5×5)');


%%
%Q2.5
pck_img = imread('pck-int.jpg');
Igray2 = im2gray(pck_img);      
Igray2 = im2double(Igray2);    

figure;
imshow(Igray2);
title('Original image');


F = fft2(Igray2);
S = abs(F).^2;

% Display Power Spectrum
figure;
imagesc(fftshift(S.^0.1));  
colormap('default');
title('Power Spectrum (Centered with fftshift)');


figure;
imagesc(S.^0.1);
colormap('default');
title('Power Spectrum (Unshifted)');

disp('Click on the two bright interference peaks');
[cols, rows] = ginput(2);   
peak_coords = round([rows cols]);
disp(peak_coords);

F_filtered = F; 

% Define size of neighborhood to zero out (5x5)
n = 2;

for k = 1:size(peak_coords,1)
    r = peak_coords(k,1);
    c = peak_coords(k,2);
    F_filtered(r-n:r+n, c-n:c+n) = 0;
end

S_filtered = abs(F_filtered).^2;

figure;
imagesc(fftshift(S_filtered.^0.1));
colormap('default');
title('Power Spectrum After Zeroing Peaks');

I_filtered = real(ifft2(F_filtered));   
figure;
imshow(I_filtered, []);
title('Image After Bandpass Filtering (Interference Suppressed)');

%%
pck_img = imread('primate-caged.jpg');
Igray3 = im2gray(pck_img);      
Igray3 = im2double(Igray3);    

figure;
imshow(Igray3);
title('Original image');


F = fft2(Igray3);
S = abs(F).^2;

figure;
imagesc(S.^0.1);
colormap('default');
title('Power Spectrum (Unshifted)');

disp('Click on the two bright interference peaks');
[cols, rows] = ginput(2);   
peak_coords = round([rows cols]);
disp(peak_coords);

F_filtered = F; 

% Define size of neighborhood to zero out (5x5)
n = 2;

for k = 1:size(peak_coords,1)
    r = peak_coords(k,1);
    c = peak_coords(k,2);
    F_filtered(r-n:r+n, c-n:c+n) = 0;
end

S_filtered = abs(F_filtered).^2;

I_filtered = real(ifft2(F_filtered));   
figure;
imshow(I_filtered, []);
title('Image After Bandpass Filtering (Interference Suppressed)');


%%
%Q2.6
lib_img2 = imread('book.jpg');
Igray2 = im2gray(lib_img2);         
Igray2 = im2double(Igray2);    

figure;
imshow(Igray2)

disp('Click on the 4 corners');
[X Y] = ginput(4);
disp([X, Y])

x1=0;   y1=0;
x2=210; y2=0;
x3=210; y3=297;
x4=0;   y4=297;

v = [x1; y1; x2; y2; x3; y3; x4; y4];

A = [X(1) Y(1) 1 0 0 0 -x1*X(1) -x1*Y(1);
     0 0 0 X(1) Y(1) 1 -y1*X(1) -y1*Y(1);
     X(2) Y(2) 1 0 0 0 -x2*X(2) -x2*Y(2);
     0 0 0 X(2) Y(2) 1 -y2*X(2) -y2*Y(2);
     X(3) Y(3) 1 0 0 0 -x3*X(3) -x3*Y(3);
     0 0 0 X(3) Y(3) 1 -y3*X(3) -y3*Y(3);
     X(4) Y(4) 1 0 0 0 -x4*X(4) -x4*Y(4);
     0 0 0 X(4) Y(4) 1 -y4*X(4) -y4*Y(4)
     ];

u = A \ v;

U = reshape([u;1], 3, 3)';
disp('Matrix U:');
disp(U);
w = U*[X'; Y'; ones(1,4)];
w = w ./ (ones(3,1) * w(3,:));
disp('Transformed points w:');
disp(w);


T = maketform('projective', U');
P2 = imtransform(Igray2, T, 'XData', [0 210], 'YData', [0 297]);
figure;
imshow(P2);

figure;
imshow(P2);
hold on; 

x = 135;
y = 145;
w = 50;
h = 50;

rectangle('Position', [x, y, w, h], ...
          'EdgeColor', 'magenta', ... 
          'LineWidth', 2);

hold off;

%%
%Q2.7
% Each row of X is a feature vector (including bias term as first element)
X = [3 3 1;   % x1
     1 1 1];  % x2

% Class labels: +1 for C1, -1 for C2
y = [ 1; -1];

alpha = 1;             
[num_samples, num_features] = size(X);
w = zeros(num_features, 1);  

max_epochs = 100;
for epoch = 1:max_epochs
    num_errors = 0;
    for k = 1:num_samples
        xk = X(k, :)';
        yk = y(k);

        decision = w' * xk;

        % Misclassified C1
        if yk == 1 && decision <= 0
            w = w + alpha * xk;
            num_errors = num_errors + 1;

        % Misclassified C2
        elseif yk == -1 && decision >= 0
            w = w - alpha * xk;
            num_errors = num_errors + 1;
        end
    end

    fprintf('Epoch %d: Number of errors = %d\n', epoch, num_errors);

    if num_errors == 0
        break;
    end
end

disp('Final weight vector:');
disp(w);
disp('Final equation: y = x1 + x2 -3');
%%

% Each row of X is a feature vector (bias + features)
X = [3 3 1;   % x1
     1 1 1];  % x2

% Target outputs: +1 for class 1, -1 for class 2
r = [ 1; -1];

alpha = 0.1;                   
[num_samples, num_features] = size(X);
w = zeros(num_features, 1);    

max_epochs = 150;

for epoch = 1:max_epochs
    total_error = 0;
    for k = 1:num_samples
        xk = X(k, :)';        
        rk = r(k);           
        yk = w' * xk;
        err = rk - yk;
        w = w + alpha * err * xk;
        total_error = total_error + err^2;
    end

    fprintf('Epoch %d: Total squared error = %.4f\n', epoch, total_error);

    % Stopping criterion
    if total_error < 1e-4
        break;
    end
end

disp('Final weight vector:');
disp(w);
disp('Final equation: r = 0.5x1 + 0.5x2 - 2');