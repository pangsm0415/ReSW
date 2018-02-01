% preprocess
function output = preprocess(input, datatype)
switch datatype
    case 'vgg16'
        output = yael_vecs_normalize(input,2,0);
    case {'siaMac','netvlad'}
        output = sign(input) .* abs(input) .^ 0.5;
end