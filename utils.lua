local utils = {}

function utils.tableContains(table, element)
    for _, value in ipairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function utils.transformTable( arr1, arr2, func, length  )
    -- 'arr1' is transformed with the elements of 'arr2' through 'func'
    -- ejemplo de func: function func(a, b) a + 2b end
    -- length parameter is optional
    length = length or #arr1
    for i=1, length do
        arr1[i] = func( arr1[i], arr2[i] )
    end
end

return utils
