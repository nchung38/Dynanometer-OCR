%%% Dynamometer Automated Optical Character Recognition from Video (.mp4
%%% file)

playvid = 'n';

v = VideoReader("Acronal D-2.MOV"); % name of the file to be read

starttime = 14.0; % (in seconds)
endtime = 23.2; % (in seconds)

Number_of_calibrations = 5;

% startframe = 171;
% endframe = 399;
% endframe = v.NumFrames;

startframe = starttime*60;
endframe = endtime*60;

runframes = read(v,[startframe endframe]);
% figure;
mat = zeros(1,endframe - startframe);
confmat = zeros(1,endframe - startframe);
j = 0;
if Number_of_calibrations > 1
    calj = round((endframe-startframe)/(Number_of_calibrations-1),0);
else
    calj = round(endframe-startframe,0);
end

if playvid == 'y'
    
    %%% Play .mp4 Video File

    for i = 1:size(runframes,4)
        imshow(runframes(:,:,:,i))
        title(sprintf('Frame %d', i)); 
        % set(figure,'Name', sprintf('Frame %d', i))
        % hold on
        pause()
    
    end

else

    %%% Looping through the video file to obtain values via OCR 

    for i = 1:size(runframes,4)
    % im = imread("test6.JPG");
    im = rot90(rgb2gray(runframes(:,:,:,i)),2);
    % im = rot90((runframes(:,:,:,i)),2);
    level = graythresh(im) + 0.08;
    im = imbinarize(im,level);
    % imshowpair(testnum,BW,'montage')

    % roi = [259.0000  250.0000  294.0000  164.0000];

    if i == 1 | j == calj 

        figure;imshow(im)
        h = drawrectangle;
        roi = h.Position;
        close
        j = 0;
    end
    j= j+1;
    ocrResults = ocr(im,roi,Model="seven-segment",LayoutAnalysis="word");
    ocrResults.Text;

    % Iocr = insertObjectAnnotation(testnum,"rectangle", ...
    %             ocrResults.WordBoundingBoxes,ocrResults.Words,LineWidth=5,FontSize=72);
    % imshow(Iocr)

    % fprintf(ocrResults.Text)

    mat(i) = str2double(ocrResults.Text);
    confmat(i) = (ocrResults.WordConfidences(1));
    end

    %%% Cleaning Data

    l = 1;
    for k = 1:1
        
        remove = zeros(1,(startframe-endframe));
        removecount = 1;
        zremovecount = 1;
        nremovecount = 1;
        dremovecount = 1;
        cremovecount = 1;

        sprintf('size: %d', size(mat,2))
        % while l < numel(mat)

        for l = 1:size(mat,2)
        if l >= numel(mat)
            break
        end

        % disp(mat(l))
        % disp(confmat(l))
        % sprintf('run: %d', l)

        if mat(l) > 1000
            mat(l) = mat(l)/1000;
        
    
        elseif mat(l) > 100
            mat(l) = mat(l)/100;
        
    
        elseif mat(l) > 10
            mat(l) = mat(l)/10;
        
    
        elseif mat(l) <= 0 && l < numel(mat) 
            % mat(l) = [];
            % confmat(l) = [];
            remove(removecount) = l;
            removecount = removecount + 1;
            zremovecount = zremovecount + 1;
        
        elseif isnan(mat(l)) && l < numel(mat) 
            % mat(l) = [];
            % confmat(l) = [];
            % fprintf("nan")
            remove(removecount) = l;
            removecount = removecount + 1;
            nremovecount = nremovecount + 1;

        elseif mat(l+1) == mat(l)
            % mat(l+1) = [];
            % confmat(l) = [];
            % fprintf("dup")
            remove(removecount) = l;
            removecount = removecount + 1;
            dremovecount = dremovecount + 1;
    
        % elseif mat(l+1) >= ( mat(l) - 0.3 ) && mat(l+1) <= ( mat(l) + 0.3 )
        %     mat(l+1) = [];
        %     confmat(l) = [];
        

        elseif confmat(l) <= 0.60
            % mat(l) = [];
            % confmat(l) = [];
            % fprintf("conf")
            remove(removecount) = l;
            removecount = removecount + 1;
            cremovecount = cremovecount + 1;
        % else
        % 
        %     l= l+1;
        end
        

        end
        mat(remove) = [];
        confmat(remove) = [];
        % mat(cremove) = [];
        % mat(dremove) = [];
        % mat(nremove) = [];
        % mat(zremove) = [];
        % confmat(remove) = [];
        end

    end


matf = mat';

 

