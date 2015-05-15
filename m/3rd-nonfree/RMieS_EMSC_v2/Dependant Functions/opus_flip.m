function [new_WN new_data] = opus_flip( WN , data);
% WN is the reversed bizarro Wavenumber vector
% data is a matrix in rows, reversed again
%
% Written by Paul Bassan, University of Manchester, UK
%
% Last revised 27/11/09


if WN(2) > WN(1);
    error('~~~ Data not reversed, flip not needed ~~~')
end

if size(data,1) == length(WN);
    data = data';
end



[N K] = size(data);


L = length(WN);

j = 0;
for i = 0 : L-1;
    j = j + 1;
    new_WN(j,:) = WN(L-i);
end


new_data = zeros(N,K);

j = 0;
for i = 0 : L-1;
    j = j + 1;
    new_data(:,j) = data(:,L-i);
end

