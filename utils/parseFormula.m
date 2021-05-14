%Parses chemical formula and returns a vector with the relative amount of
%each element
function [amount i] = parseFormula(formula, i)
amount = zeros(1,118);
if ~exist('i','var')
    i = 1;
end
while i <= length(formula)
    if formula(i)=='('
        [current, i] = parseFormula(formula, i+1);
        i = i+1;
    elseif isstrprop(formula(i),'upper')
        i = i+1;
        if i<=length(formula) && isstrprop(formula(i),'lower')
            i = i+1;
            if i<=length(formula) && isstrprop(formula(i),'lower')
                i = i+1;
                symbol = formula(i-3:i-1);
            else
                symbol = formula(i-2:i-1);
            end
        else
            symbol = formula(i-1);
        end
        current = zeros(1,118);
        current(atomicNumber(symbol)) = 1;
    elseif formula(i) == ')'
        return;
    else
        warning(['Error in chemical formula. Unexpected character: '...
            formula(i)]);
        i = i+1;
    end
    [A, count, errmsg, nextindex] = sscanf(formula(i:end),'%g',1);
    if count
        current = current*A;
        i = i+nextindex-1;
    end
    amount = amount+current;
end

%returns the atomic number of an element given its chemical symbol
function Z = atomicNumber(symbol)
%persistent so that it must not be reloaded for each function call
persistent symbols;
if isempty(symbols)
    file = fopen('utils/scatteringFactors/elements.txt');
    fgetl(file);  %read file header
    symbols = cell(1,118);
    for i = 1:118
        symbols{i} = fscanf(file,'%s',1); %read symbol
        fscanf(file,'%g',1); %read past mass
    end
    fclose(file);
end
Z = find(strcmp(symbols,symbol));
if isempty(Z)
    warning(['Could not find element with symbol ' symbol '.']);
end