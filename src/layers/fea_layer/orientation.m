function top = orientation(bottom, param)
% {image,level}[x,y,channel]

% laod
img_data = bottom.data;

% init
img_num   = size(img_data,1);
img_level_num = size(img_data,2);
map_data  = cell(img_num, img_level_num);

lambda  = param.lambda;
angle   = param.angle ./ 180 * pi;
psi     = param.psi;
gamma   = param.gamma;
bw      = param.bw;

% processing
for i_img = 1:img_num
    im_size = size(img_data{i_img,1});
    map_size = fix(im_size(1:2)./ max(im_size(1:2)) .* param.maxlen);    
    for i_level = 1:img_level_num
        
        % read input data
        im = img_data{i_img, i_level};
        if size(im,3) == 3
            im = rgb2gray(im);
        end
        
        % processing
        im_fea = zeros([size(im,1), size(im,2), length(angle)]);
        im_map = zeros([map_size(1:2), length(angle)]);
        for i_angle = 1:length(angle)
            
            % generate gabor filter
            gb = gabor_fn(bw,gamma,psi(1),lambda,angle(i_angle))...
                + 1i * gabor_fn(bw,gamma,psi(2),lambda,angle(i_angle));
            
            % gb is the n-th gabor filter
            map = imfilter(im, gb, 'symmetric');
            map = sum(abs(map).^2, 3).^0.5;
            
            % normalize
            map =  map ./ max(map(:));
            im_fea(:,:,i_angle) = map;
        end
        
        for i_map = 1:size(im_map,3)
            im_map(:,:,i_map) = imresize(im_fea(:,:,i_map), map_size, 'bicubic');
        end
        
        map_data{i_img,i_level} = im_map;
    end
end

% result
top.data = map_data;


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function gb = gabor_fn(bw,gamma,psi,lambda,theta)
% bw    = bandwidth, (1)
% gamma = aspect ratio, (0.5)
% psi   = phase shift, (0)
% lambda= wave length, (>=2)
% theta = angle in rad, [0 pi)
 
sigma = lambda/pi*sqrt(log(2)/2)*(2^bw+1)/(2^bw-1);
sigma_x = sigma;
sigma_y = sigma/gamma;

% sz=fix(8*max(sigma_y,sigma_x));
% if mod(sz,2)==0, sz=sz+1;end

% alternatively, use a fixed size
sz = 27;
 
[x,y]=meshgrid(-fix(sz/2):fix(sz/2),fix(sz/2):-1:fix(-sz/2));
% x (right +)
% y (up +)

% Rotation 
x_theta=x*cos(theta)+y*sin(theta);
y_theta=-x*sin(theta)+y*cos(theta);
 
gb=exp(-0.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*cos(2*pi/lambda*x_theta+psi);
% imshow(imresize(gb/2+0.5,10));
end


