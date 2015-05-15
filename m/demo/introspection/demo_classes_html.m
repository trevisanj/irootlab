%> @brief Generates IRootLab classes hierarchical tree in HTML, using object colors.
%> @ingroup demo introspection
%> @file

classmap_assert;
global CLASSMAP;

s = stylesheet();
s = cat(2, s, CLASSMAP.root.to_html());

filename = 'irr_classes.html';
h = fopen(filename, 'w');
fwrite(h, s);
fclose(h);

web(filename, '-new');
