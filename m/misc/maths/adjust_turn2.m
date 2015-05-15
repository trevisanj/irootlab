%> @ingroup maths
%> @file
%> @brief Turns loadings vectors
%>
%> Turns loadings vectors so that they make less than 90 degrees with their corresponding loadings vectors from a reference block.
%>
%> Works both with @ref fcon_linear blocks and @ref block_cascade_base blocks. In case of block_cascade_base, only acts on the last block
%>
%> This function makes sense with eigenvectors of some matrix, e.g., loadings from PCA/LDA/PLS
%>
%> Acts on the columns of L separately.
%>
%> as_crossc
%
%
%> @param b Block to act on. Block must have the @c L property
%> @param bref Reference block
%> @return a [nf]x[nf] "turning" matrix/ This matrix is diagonal with elements either +1 or -1. <code>L*M</code> turns the loadings vector
function M = adjust_turn2(b, bref)

% flag_cascade = isa(b, 'block_cascade_base');
% 
% if flag_cascade
%     L = b.blocks{end}.L;
%     Lref = bref.blocks{end}.L;
% else
    L = b.L;
    Lref = bref.L;
% end;

if size(L, 2) ~= size(Lref, 2)
    irerror(sprintf('Number of loadings do not match: %d against %d', size(L, 2), size(Lref, r)));
end;


% figure;subplot(2, 1, 1); plot(L(:, 1)); title('L');subplot(2, 1, 2); plot(Lref(:, 1)); title('Lref');
% dbstack;
% keyboard;
% close;

flag_any = 0;
M = eye(size(L, 2));
for i = 1:size(L, 2)
    Li = L(:, i);
    if Li'*Lref(:, i) < 0
        M(i, i) = -1;
        L(:, i) = -Li;
        flag_any = 1;
    end;
end;

if ~flag_any
    M = [];
end;
