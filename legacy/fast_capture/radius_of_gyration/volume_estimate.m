% function to convert BF mask to volumn 
function volume = volume_estimate(bfmask)
mask = bfmask;
labels = max(unique(bfmask));
for l = 1:labels %for each cell
    curr_mask = mask;
    
    % __ volume measurements below __
    curr_mask(curr_mask ~= l) = 0; %leave only mask for current cell
    curr_mask = curr_mask ./ l; % convert mask value to 1
    curr_mask_RP=regionprops(curr_mask,'boundingbox','Orientation'); %get bounding box and major and minor axes
    
    xc=round(curr_mask_RP.BoundingBox(1)):-1+round((curr_mask_RP.BoundingBox(1)+curr_mask_RP.BoundingBox(3))); %crop mask to the bounding box
    yc=round(curr_mask_RP.BoundingBox(2)):-1+round((curr_mask_RP.BoundingBox(2)+curr_mask_RP.BoundingBox(4)));
    curr_mask1=curr_mask(yc,xc);
    
    rotated_mask = imrotate(curr_mask1,-curr_mask_RP.Orientation); %rotate cell mask so that its major axis is horizontal
    
    rotated_mask_RP=regionprops(rotated_mask,'boundingbox'); %crop mask to bounding box again
    xc2=round(rotated_mask_RP.BoundingBox(1)):-1+round((rotated_mask_RP.BoundingBox(1)+rotated_mask_RP.BoundingBox(3)));
    yc2=round(rotated_mask_RP.BoundingBox(2)):-1+round((rotated_mask_RP.BoundingBox(2)+rotated_mask_RP.BoundingBox(4)));           
    rotated_mask=rotated_mask(yc2,xc2);
    
    [xs,ys]=size(rotated_mask);
    vol_ht = NaN(1,ys); 
    for i=1:ys; %for each pixel (aka unit distance) in major axis
        r_h=(sum(rotated_mask(:,i))./2); %find the mean distance of both orthogonals above and below the pixel to the edge of the mask
        vol_ht(i)=pi.*(r_h).^2; %use that value as the radius to find the area of a circle
    end
    volume(l) = sum(vol_ht); % sum all the areas together to get an estimate of the volume
end
end
