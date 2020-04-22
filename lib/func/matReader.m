function data = matReader(filename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    b = load(filename);
    data = b.x; 
end

