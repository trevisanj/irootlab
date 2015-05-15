%> @brief Makes one block from many
%> @file
%> @ingroup misc conversion
%>
%> Iterates throught the cell of blocks. If an element is a @ref block_cascade_base, extracts its blocks; otherwise adds the element
%
%> @param cob Cell of blocks
%> @return one a @ref block_cascade_base block
function one = make_one(cob)

one = block_cascade_base();

for i = 1:numel(cob)
    b = cob{i};
    if isa(b, 'block_cascade_base')
        one.blocks = [one.blocks, b.blocks];
    else
        one.blocks{end+1} = b;
    end;
end;
