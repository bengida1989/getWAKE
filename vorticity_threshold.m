function vort = vorticity_threshold(vorticity, swirl, thresh_criterion, threshold, MASK)

[nRows, nColumns] = size(vorticity);

switch thresh_criterion
    case 'Swirl'
        if MASK(1) == 0 && threshold>0 % Gaussian masking
            % Parameters for Gaussian smoothing
            kernel = fspecial('gaussian',MASK(2),MASK(3));
            se = strel('disk',MASK(4));

            % Filtering the swirl function
            SWIRL = filtered_map(swirl, kernel, se, threshold);

            % find regions of high swirl
            tmp = reshape(vorticity, nRows*nColumns, 1); % Reshaping the vorticity array as a column vector (according to columns)
            tmp(find(SWIRL(:,:)==0))=0;

            vort = reshape(tmp, nRows, nColumns);
            
        elseif MASK(1) == 1 && threshold>0 % Regular masking
            P = swirl;
            P_max = max(max(abs(P)));
            P_thres = threshold*P_max;
            vorticity(abs(P)<=P_thres) = 0;
            vort = vorticity;
            
        else
            vort = vorticity;
            
        end
        
        
        case 'Vorticity'
        if MASK(1) == 0 && threshold>0% Gaussian masking
            % Parameters for Gaussian smoothing
            kernel = fspecial('gaussian',MASK(2),MASK(3));
            se = strel('disk',MASK(4));

            % Filtering the swirl function
            VORTICITY = filtered_map(vorticity, kernel, se, threshold);

            % find regions of high swirl
            tmp = reshape(vorticity, nRows*nColumns, 1); % Reshaping the vorticity array as a column vector (according to columns)
            tmp(find(VORTICITY(:,:)==0))=0;

            vort = reshape(tmp, nRows, nColumns);

        elseif MASK(1) == 1 && threshold>0% Regular masking
            P = vorticity;
            P_max = max(max(abs(P)));
            P_thres = threshold*P_max;
            vorticity(abs(P)<=P_thres) = 0;
            vort = vorticity;
            
        else
            vort = vorticity;
            
        end
        
end
