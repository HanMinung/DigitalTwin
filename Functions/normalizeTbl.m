% Function to normalize a table
% If a column exists with non-numeric variable --> pass

function Tbl = normalizeTbl(inputTable)
    
    Tbl = inputTable;

    numColumns = width(inputTable);

    for varIdx = 1:numColumns

        if isnumeric(inputTable{:, varIdx})

            Tbl{:, varIdx} = normalize(inputTable{:, varIdx});
        end
    end
end