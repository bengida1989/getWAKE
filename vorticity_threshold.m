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
            S = swirl;
            for i=1:nRows
                for j=1:nColumns
                    if abs(S(i,j))<=threshold*max(abs(S(:)))
                        vorticity(i,j)=0;
                    end;
                end;
            end;
            vort = vorticity;
        else
            vort = vorticity;
        end;
        
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
            V = vorticity;
            for i=1:nRows
                for j=1:nColumns
                    if abs(V(i,j))<=threshold*max(abs(V(:)))
                        vorticity(i,j)=0;
                    end;
                end;
            end;
            vort = vorticity;
        else
            vort = vorticity;
        end;
end;
