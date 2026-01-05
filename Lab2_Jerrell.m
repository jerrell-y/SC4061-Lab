% Import images and ground truth
images = {'document01.bmp','document02.bmp','document03.bmp','document04.bmp'};
gts    = {'document01-GT.tiff','document02-GT.tiff','document03-GT.tiff','document04-GT.tiff'};

results = struct();

%%
for idx = 1:length(images)
    % Load image and GT
    I = imread(images{idx});
    I = rgb2gray(I);
    GT = imread(gts{idx});
    
    % Apply Otsu global thresholding
    level = graythresh(I);        
    BW = imbinarize(I, level);  
    
    % Evaluate difference
    diff_img = abs(double(BW) - double(GT));
    error_sum = sum(diff_img(:));
    
    % Store results
    results(idx).filename = images{idx};
    results(idx).otsu_threshold = level;
    results(idx).error = error_sum;
    
    % Display
    figure;
    subplot(1,3,1); imshow(I); title('Original');
    subplot(1,3,2); imshow(BW); title('Otsu Segmentation');
    subplot(1,3,3); imshow(diff_img, []); title('Difference Image');
end

% Show results summary
disp(struct2table(results));


%%
for idx = 1:length(images)
    I = imread(images{idx});
    I = rgb2gray(I);
    GT = imread(gts{idx});
    I = im2double(I);

    % Parameters for Niblack
    windowSize = 300;  % change this value
    k = -1;         % change this value

    % Compute local mean and standard deviation
    meanI = movmean(I, [windowSize windowSize], 'Endpoints', 'shrink');
    stdI  = movstd(I, [windowSize windowSize], 0, 'Endpoints', 'shrink');

    % Niblack threshold
    T = meanI + k * stdI;

    % Binarize image
    BW = I <= T;

    % Quantitative evaluation
    diff_img = abs(double(BW) - double(GT));
    error_sum = sum(diff_img(:));

    results(idx).filename = images{idx};
    results(idx).window = windowSize;
    results(idx).k = k;
    results(idx).error = error_sum;

    figure;
    subplot(1,3,1); imshow(I); title('Original');
    subplot(1,3,2); imshow(BW); title(['Niblack']);
    subplot(1,3,3); imshow(diff_img, []); title('Difference Image');
end

disp(struct2table(results));

%%
for idx = 1:length(images)
    I = imread(images{idx});
    I = rgb2gray(I);
    GT = imread(gts{idx});
    I = im2double(I);

    % Parameters for Niblack
    windowSize = 300;  % change this value
    k = -1;         % change this value

    % Compute local mean and standard deviation
    meanI = movmean(I, [windowSize windowSize], 'Endpoints', 'shrink');
    stdI  = movstd(I, [windowSize windowSize], 0, 'Endpoints', 'shrink');

    % Niblack threshold
    T = meanI + k * stdI;

    % Binarize image
    BW = I <= T;

    BW_clean = bwareaopen(BW, 70);      % Remove small noisy regions
    BW_clean = imclose(BW_clean, strel('disk', 1));  % Fill text gaps


    % Quantitative evaluation
    diff_img = abs(double(BW_clean) - double(GT));
    error_sum = sum(diff_img(:));

    results(idx).filename = images{idx};
    results(idx).window = windowSize;
    results(idx).k = k;
    results(idx).error = error_sum;

    figure;
    subplot(1,3,1); imshow(I); title('Original');
    subplot(1,3,2); imshow(BW_clean); title(['Niblack']);
    subplot(1,3,3); imshow(diff_img, []); title('Difference Image');
end

disp(struct2table(results));


%%
function D = computeDisparitySSD(Pl, Pr, winSize, maxDisp)
    Pl = double(Pl);
    Pr = double(Pr);
    [rows, cols] = size(Pl);
    halfWin = floor(winSize / 2);
    D = zeros(rows - 2 * halfWin, cols - 2 * halfWin);

    % Loop through each pixel within the valid region
    for i = 1 + halfWin : rows - halfWin
        for j = 1 + halfWin : cols - halfWin
            templateLeft = Pl(i - halfWin : i + halfWin, j - halfWin : j + halfWin);
            minSSD = inf;
            bestDisp = 0;

            for d = 0:maxDisp
                jr = j - d;

                if (jr - halfWin < 1)
                    continue;
                end

                templateRight = Pr(i - halfWin : i + halfWin, jr - halfWin : jr + halfWin);
                SSD = sum(sum((templateLeft - templateRight) .^ 2));

                if SSD < minSSD
                    minSSD = SSD;
                    bestDisp = d;
                end
            end

            D(i - halfWin, j - halfWin) = -bestDisp;
        end
    end
end
%%

Pl = rgb2gray(im2double(imread('corridorl.jpg')));
Pr = rgb2gray(im2double(imread('corridorr.jpg')));

D = computeDisparitySSD(Pl, Pr, 11, 15);

figure;
imshow(-D, [-15,15]);
colormap(gray);
colorbar;
title('Disparity Map');
%%

Pl = im2double(rgb2gray(imread('triclopsi2l.jpg')));
Pr = im2double(rgb2gray(imread('triclopsi2r.jpg')));

D = computeDisparitySSD(Pl, Pr, 11, 15);

figure;
imshow(-D, [-15,15]);
colormap(gray);
colorbar;
title('Disparity Map');