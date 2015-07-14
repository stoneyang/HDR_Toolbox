function imgOut = normalizedImage(img)

C = zeros(size(img));

window_size = 24;
window_size_sq = window_size * window_size;

for i=1:size(img,3)
    img_max = ordfilt2(img(:,:,i), 1, true(window_size));
    img_min = ordfilt2(img(:,:,i), window_size_sq, true(window_size));    
    C(:,:,i) = img_max - img_min;
end

img_mean = imfilter(img, ones(window_size, window_size) / window_size_sq, 'replicate');

imgOut = RemoveSpecials(0.5 + (img - img_mean) ./ img_mean);

end