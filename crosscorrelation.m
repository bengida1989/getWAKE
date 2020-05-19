function [px, py, Cu, Cv, Cuv, Cu_peak, Cv_peak, Cuv_peak, shiftX_optCu,...
    shiftY_optCu, shiftX_optCv, shiftY_optCv, shiftX_optCuv,...
    shiftY_optCuv] = crosscorrelation(nRows, min_shiftX, max_shiftX, min_shiftY, max_shiftY, uf1, vf1, uf2, vf2) 

%% CROSS-CORRELATION ALGORTIHM  version 1.0
% Last update in: 20/11/2015
% by: Hadar Ben-Gida
% Version 2.0
% 1. Cuv is now defined as the square root of Cu^2+Cv^2
% 2. Cv is now ansolute value before computing Cuv


%% INPUTS:
% min_shiftX - Define the minimum shift in the X direction 
% max_shiftX - Define the maximum shift in the X direction
% min_shiftY - Define the minimum shift in the Y direction 
% max_shiftY - Define the maximum shift in the Y direction
% uf1 - u' velocity field of the 1st image for the cross-correlation 
% vf1 - v' velocity field of the 1st image for the cross-correlation 
% uf2 - u' velocity field of the 2nd image for the cross-correlation 
% vf2 - v' velocity field of the 2nd image for the cross-correlation 

%% OUTPUT:
% px - vecotr containing the shiftX values in terms of cells
% py - vecotr containing the shiftY values in terms of cells
% Cu - Cross-Correlation map based on u' velocity maps
% Cv - Cross-Correlation map based on v' velocity maps
% Cuv - Sum of the Cu and Cv Cross-Correlation maps
% Cu_peak - Peak value in the Cu Cross-Correlation map
% Cv_peak - Peak value in the Cv Cross-Correlation map
% Cuv_peak - Peak value in the Cuv Cross-Correlation map
% shiftX_optCuv - Optimum shift in X direction based on the Cuv cross-correlation map
% shiftY_optCuv - Optimum shift in Y direction based on the Cuv cross-correlation map
% shiftX_optCu - Optimum shift in X direction based on the Cu cross-correlation map
% shiftY_optCu - Optimum shift in Y direction based on the Cu cross-correlation map
% shiftX_optCv - Optimum shift in X direction based on the Cv cross-correlation map
% shiftY_optCv - Optimum shift in Y direction based on the Cv cross-correlation map

%% IMPORTANT! The cross-correlation algorithm goes from the last image to
% the first
%%


%% CROSS-CORRELATION ALGORTIHM

Cu = zeros(nRows,max_shiftX);
Cv = zeros(nRows,max_shiftX);
for shiftY = min_shiftY:1:max_shiftY
    for shiftX = min_shiftX:1:max_shiftX
        
        % Defining the overllaping matrices of the uf and vf
        if shiftY>0
            Au = uf1(1:end-shiftY,1+shiftX:end); % Overllaping u-map of the 1st image
            Av = vf1(1:end-shiftY,1+shiftX:end); % Overllaping v-map of the 1st image
            Bu = uf2(1+shiftY:end,1:end-shiftX); % Overllaping u-map of the 2nd image
            Bv = vf2(1+shiftY:end,1:end-shiftX); % Overllaping v-map of the 2nd image
        else
            Au = uf1(1+abs(shiftY):end,1+shiftX:end); % Overllaping u-map of the 1st image
            Av = vf1(1+abs(shiftY):end,1+shiftX:end); % Overllaping v-map of the 1st image
            Bu = uf2(1:end-abs(shiftY),1:end-shiftX); % Overllaping u-map of the 2nd image
            Bv = vf2(1:end-abs(shiftY),1:end-shiftX); % Overllaping v-map of the 2nd image
        end;
        
        % Calculating the mean values
        Au_mean = mean2(Au); % mean u value for the 1st u-map 
        Av_mean = mean2(Av); % mean v value for the 1st v-map 
        Bu_mean = mean2(Bu); % mean u value for the 2nd u-map 
        Bv_mean = mean2(Bv); % mean v value for the 2nd v-map 
        
        % Calculating the std values
        Au_std = std2(Au); % mean u value for the 1st u-map 
        Av_std = std2(Av); % mean v value for the 1st v-map 
        Bu_std = std2(Bu); % mean u value for the 2nd u-map 
        Bv_std = std2(Bv); % mean v value for the 2nd v-map 
        
        
        [I,J] = size(Au); % Getting the size of the overllaping area
        
        % Calculating the Cross-correlation values in the overllaping area
        Cuu = zeros(I,J);
        Cvv = zeros(I,J);
        for i=1:I
            for j=1:J
                Cuu(i,j) = ((Au(i,j) - Au_mean).*(Bu(i,j) - Bu_mean))./(I*J*Au_std*Bu_std);
                Cvv(i,j) = abs(((Av(i,j) - Av_mean).*(Bv(i,j) - Bv_mean))./(I*J*Av_std*Bv_std));
            end;
        end;
        
        % Summing the cross-correlation coefficients in the overllaping area to get the matching for the corresponding shift (X,Y) 
        Cu(shiftY+max_shiftY+1,shiftX) = sum(sum(Cuu));
        Cv(shiftY+max_shiftY+1,shiftX) = sum(sum(Cvv));
        clear Cuu Cvv;
    end;
end;
 
% Calculating the shiftX & shiftY vectors in terms of cells
px = min_shiftX:1:max_shiftX;
py = min_shiftY:1:max_shiftY;


% Getting the peak values of the cross-correlation map
Cuv = sqrt(Cu.^2 + Cv.^2);
Cu_peak = max(Cu(:));
Cv_peak = max(Cv(:));
Cuv_peak = max(Cuv(:));
[Cu_peak_i, Cu_peak_j] = find(Cu == Cu_peak);
[Cv_peak_i, Cv_peak_j] = find(Cv == Cv_peak);
[Cuv_peak_i, Cuv_peak_j] = find(Cuv == Cuv_peak);

if length(Cu_peak_i)>1
    disp('Cross-correlation ERROR! Multiple overlapping was found, probabely due to no wake data in the PIV images...');
end;

% Calculating the OPTIMUM shift in X & Y
shiftX_optCuv = px(Cuv_peak_j);
shiftY_optCuv = py(Cuv_peak_i);
shiftX_optCu = px(Cu_peak_j);
shiftY_optCu = py(Cu_peak_i);
shiftX_optCv = px(Cv_peak_j);
shiftY_optCv = py(Cv_peak_i);


if Cu_peak > Cv_peak  
    shiftX_optCuv = px(Cu_peak_j);
    shiftY_optCuv = py(Cu_peak_i);
else
    shiftX_optCuv = px(Cv_peak_j);
    shiftY_optCuv = py(Cv_peak_i);
end;
%%
