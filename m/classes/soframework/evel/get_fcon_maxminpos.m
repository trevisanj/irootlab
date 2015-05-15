%> Creates a fcon_maxminpos object
function o = get_fcon_maxminpos()

o = fcon_maxminpos();



o.map = [1670, 1620, 0; % Amide I
      1560, 1500, 0; % Amide II
      1468, 1435, 0; % Proteins
      1418, 1380, 0; % Proteins
      1260, 1215, 0; % Amide III
      1120, 1040, 0; % Various DNA/RNA
     ];