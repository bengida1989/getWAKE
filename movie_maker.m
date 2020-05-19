function movie_maker(A, INPUTS, path, fps, vort_thresh, thresh_criterion,...
    MASK, disp_vec, vec_space, vec_size, contour_min, contour_max, scale_map, colormap_selection)

% LAST UPDATE IN: 05/11/2015
% By: Hadar Ben-Gida



%% INPUTS
% A - .mat file consist with all the flow data
% INPUTS - Vector containing all the different paramters for the program 
% INPUTS = [laser_dt, p_cm, dt, chord, wingspan, body_l, body_w, weight,...
%    Uinf, density, viscosity, horizontal_cut, vertical_cut,...
%    ni, nf];
% path - The name of the movie .avi file
% fps - frames per second
%%




%% METER TO PIXEL PARAMETERS 
p_cm = INPUTS(2); %[pixel/cm]
m_p = (1/p_cm)/100; %[m/pixel]
%%



%% WING PARAMETERS
c = INPUTS(4); % Bird's characteristic chord [m]
b = INPUTS(5); % Bird's wingspan [m] (includes the body width)
W = INPUTS(8); % Bird's weight [kg]
g = 9.81; % Gravitational acceleration [m/sec2]
bl = INPUTS(6); % Bird's body length [m]
bw = INPUTS(7); % Bird's body width [m]
%%



%% FLOW PARAMETERS
rho = INPUTS(10); % Air Density [kg/m3] at 14.8oC
Mu = INPUTS(11); %[Pa*sec] Air Viscosity
D_Mu = Mu/rho; % Dynamic Viscosity [m^2/sec]
U_inf = INPUTS(9); % Free Stream Velocity [m/sec]
Re = (U_inf*rho*c)/(Mu);
disp('                                              ');
disp(['Re =                                   ' num2str(Re)]);
disp('                                              ');
%%



%% GETTING THE FLOW QUANTITIES AND RE-DEFINE THE VELOVITY MAP SIZE
ni = INPUTS(14); % Initial velocity map in the sequence
nf = INPUTS(15); % Final velocity map image in the sequence
dt_laser = INPUTS(1); % [sec] Time difference between consecutive PIV images
dt = INPUTS(3); % [sec] Time difference between consecutive velocity maps
h_cut = INPUTS(12); % number of vectors we slice from the vertical edges of the PIV image
v_cut = INPUTS(13); % number of vectors we slice from the horizontal edges of the PIV image


A.x = A.x(1+v_cut:end-v_cut, 1+h_cut:end-h_cut);
x = (A.x - A.x(1,1)).*m_p;  % x Coordinate [m]
X_c = x./c; % x/c

A.y = A.y(1+v_cut:end-v_cut, 1+h_cut:end-h_cut);
y = (A.y - A.y(1,1)).*m_p;  % y Coordinate [m]
y = y - (y(end)*0.5); % Placing the origin at the center of the Y-axis
Y_c = y./c; % x/c


dx = A.dx*m_p; %dx=16pixels * (meter/pixel)
dy = A.dy*m_p; %dy=16pixels * (meter/pixel)

% Getting the different flow parameters (u, v, u', v', du/dx, du/dy,...)
A.u = A.u(1+v_cut:end-v_cut, 1+h_cut:end-h_cut, :);
u = A.u.*(m_p/dt_laser);
    
A.v = A.v(1+v_cut:end-v_cut, 1+h_cut:end-h_cut, :);
v = A.v.*(m_p/dt_laser);
    
A.uf = A.uf(1+v_cut:end-v_cut, 1+h_cut:end-h_cut, :);
uf = A.uf*(m_p/dt_laser);
    
A.vf = A.vf(1+v_cut:end-v_cut, 1+h_cut:end-h_cut, :);
vf = A.vf*(m_p/dt_laser);
    
A.dudx = A.dudx(1+v_cut:end-v_cut, 1+h_cut:end-h_cut, :);
dudx = A.dudx.*(1/dt_laser);
    
A.dvdx = A.dvdx(1+v_cut:end-v_cut, 1+h_cut:end-h_cut, :);
dvdx = A.dvdx.*(1/dt_laser);
    
A.dudy = A.dudy(1+v_cut:end-v_cut, 1+h_cut:end-h_cut, :);
dudy = A.dudy.*(1/dt_laser);
    
A.dvdy = A.dvdy(1+v_cut:end-v_cut, 1+h_cut:end-h_cut, :);
dvdy = A.dvdy.*(1/dt_laser);


% Fixing the map images in case the coordinate system origin is at the left
% down corner of the image
if dy < 0 
    y = (A.y - A.y(end,1)).*m_p;  % y Coordinate [m]
    y = y - (y(1)*0.5); % Placing the origin at the center of the Y-axis
    dy = dy*(-1);  
end;
%% 



%% VORTICITY CALCULATION
VORTICITY = (dvdx(:,:,ni:nf) - dudy(:,:,ni:nf)); %[1/sec]

%% SWIRL CALCULATION
SWIRL = imag( sqrt( 0.25.*((dudx(:,:,ni:nf) + dvdy(:,:,ni:nf)).^2) + (dudy(:,:,ni:nf).*dvdx(:,:,ni:nf)) - (dudx(:,:,ni:nf).*dvdy(:,:,ni:nf)) )); % [1/sec^2]2

UF = uf(:,:,ni:nf);
VF = vf(:,:,ni:nf);
[nRows, nColumns, nTime] = size(VORTICITY);
%%


%% MOVIE MAKER
writerObj = VideoWriter(path); % create the video writer with 1 fps
writerObj.FrameRate = fps; % Changing the frames per second
open(writerObj);  % open the video writer


for n = 1:nTime
        % Focusing on Figure 1  
        figure(1)
        labelsize = 26; % fontsize of the labels
        fontname = 'Century'; % font name
        axessize = 21; % fontsize of the axes    
        x_axis1{1} = X_c; % x1 values
        x_axis1{2} = '$x/c$'; % x1 label
        y_axis{1} = Y_c; % y values
        y_axis{2} = '$y/c$'; % y label
        VORTICITY_NORM = (c/U_inf).*(vorticity_threshold(VORTICITY(:,:,n), SWIRL(:,:,n), thresh_criterion, vort_thresh, MASK)); % Thresholding on the vorticity
        c_axis{1} = VORTICITY_NORM; % c values
        c_axis{2} = '\omega_z\cdotc/U_\infty'; % c label
        c_axis{3} = [contour_min contour_max]; % c limits
        color_bar{1} = COLOR(colormap_selection)./255; % colormap
        color_bar{2} = 5; % colorbar delta ticks
        fonts{1} = labelsize; % labels font size
        fonts{2} = fontname; % font name
        fonts{3} = axessize; % axes font size
        if disp_vec == 1
            q_axis{1} = UF(:,:,n); % quiver u velocity
            q_axis{2} = VF(:,:,n); % quiver v velocity
            q_axis{3} = 0.3; % quiver LineWidth
            q_axis{4} = vec_size; % quiver AutoScaleFactor
            q_axis{5} = vec_space;
            if scale_map == 1
                contourxy(x_axis1, y_axis, c_axis, color_bar, fonts, q_axis);
            else 
                 contourxy_not_scaled(x_axis1, y_axis, c_axis, color_bar, fonts, q_axis);
            end;
        else 
            if scale_map == 1
                contourxy(x_axis1, y_axis, c_axis, color_bar, fonts, '');
            else 
                contourxy_not_scaled(x_axis1, y_axis, c_axis, color_bar, fonts, '');
            end;
        end;
        set(gcf,'units','normalized','outerposition',[0 0 0.9 0.9]); % enlarging the figure to fullscreen
        set(gcf,'PaperPositionMode','auto'); % settings to prepare the figure for print in the right size
        set(gcf, 'color', 'w');
        writeVideo(writerObj,getframe(gcf)); % Write the images into the video
        clf(figure(1)); % reset the figure
end;
% close the writer object
close(figure(1)); 
close(writerObj);
