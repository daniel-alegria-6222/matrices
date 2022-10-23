utl = require("utils")
Imaginario = require("imaginario")

local Matriz = {}
Matriz.mt = {__index = Matriz}

function Matriz.new( arr )
    local this = setmetatable({}, Matriz.mt)

    this.clsname = "Matriz"
    this.arr = arr
    this.i = #arr
    this.j = #arr[1]

    return this
end

-- IMPRIMIR MATRICES
function Matriz.mt.__tostring(m)
    local str = ""
    for i = 1, m.i, 1 do
        str = str .. "| "
        for j = 1, m.j, 1 do
            -- elem = m.arr[i][j] == 0 and 0 or 1
            elem = m.arr[i][j]
            str = str .. tostring(elem) .. ", "
        end
        str = str .. "|\n"
    end
    return "\n" .. str .. ""
end

-- FUNCIONES UTILES
function Matriz.esRowDivisible( m, i, num )
    -- checkea si una fila 'i' es divisible por un numero 'num'
    if i < 1 or i > m.i or num == 0 then return nil end
    for j=1, m.j do
        if m.arr[i][j] % num ~= 0 then return false end
    end
    return true
end

function Matriz.swapRow( m, r1, r2 )
    if r1 == r2 then return end
    local arr_r1 = m.arr[r1]
    m.arr[r1] = m.arr[r2]
    m.arr[r2] = arr_r1
end

function Matriz.concatRight( m1, m2 )
    local new_t = m1.arr
    if m1.i ~= m2.i then return nil end
    for i=1, m2.i do
        for j=1, m2.j do
            elem = m2.arr[i][j]
            new_t[i][j+m1.j] = elem
        end
    end
    return Matriz.new(new_t)
end

function Matriz.contarCeroRows( m )
    -- contar las filas con solo ceros
    local count = 0
    for i=1, m.i do
        if utl.sumTable( m.arr[i] ) == 0 then count = count + 1 end
    end
    return count
end

function Matriz.spliceByColumns( m , j1, j2 )
    -- te da una parte de la matriz delimitada por las columnas j1 y j2
    local new_t = {}
    for i=1, m.i do
        new_t[i] = {}
        for j=j1, j2 do
            new_t[i][j+1-j1] = m.arr[i][j]
        end
    end
    return Matriz.new(new_t)
end

-- OPERACIONES ENTRE MATRICES
function Matriz.mt.__eq (m1, m2)
    if m1.i ~= m2.i or m1.j ~= m2.j then return false end
    for i=1, m1.i do
        for j=1, m1.j do
            if m1.arr[i][j] ~= m2.arr[i][j] then return false end
        end
    end
    return true
end

function Matriz.mt.__add (m1, m2)
    if type(m1) == "number" or type(m2) == "number" then
        error("Can't add matriz with number")
    elseif m1.i ~= m2.i or m1.j ~= m2.j then
        error("Can't add, array dimensions don't match")
    end

    local new_t = {}

    -- find the sum of two arrays
    for i = 1, m1.i, 1 do
        new_t[i] = {}

        for j = 1, m1.j, 1 do
            -- new_t[i][j] = elem == 0 and 0 or 1
            elem = m1.arr[i][j] + m2.arr[i][j]
            new_t[i][j] = elem
        end
    end

    return Matriz.new(new_t)
end
function Matriz.mt.__sub (m1, m2)
    -- return Matriz.mt.__sum(m1, -m2)
    if type(m1) == "number" or type(m2) == "number" then
        error("Can't add matriz with number")
    elseif m1.i ~= m2.i or m1.j ~= m2.j then
        error("Can't add, array dimensions don't match")
    end

    local new_t = {}

    -- find the sum of two arrays
    for i = 1, m1.i, 1 do
        new_t[i] = {}

        for j = 1, m1.j, 1 do
            -- new_t[i][j] = elem <= 0 and 0 or 1
            elem = m1.arr[i][j] - m2.arr[i][j]
            new_t[i][j] = elem
        end
    end

    return Matriz.new(new_t)
end

function Matriz.mt.__mul (m1, m2) -- parameters have to be 'number' or 'Matriz'
    local new_t = {}

    is1num = type(m1) == "number" 
    is2num = type(m2) == "number"
    if is1num or is2num then
        local k = is1num and m1 or m2
        local m = is2num and m1 or m2
        for i=1, #m.arr do
            new_t[i] = {}
            for j=1, #m.arr[1] do
                new_t[i][j] = m.arr[i][j] * k 
            end
        end
        return Matriz.new(new_t)
    elseif m1.j ~= m2.i then
        error("Can't multiply, array dimensions don't match")
    end

    local ntimes = m1.j  -- m2.i
    -- find the value of the product of two arrays
    for i = 1, m1.i, 1 do
        new_t[i] = {}

        for j = 1, m2.j, 1 do
            elem = 0
            for n = 1, ntimes, 1 do
                elem = elem + m1.arr[i][n] * m2.arr[n][j]
            end
            -- new_t[i][j] = elem == 0 and 0 or 1
            new_t[i][j] = elem
        end
    end

    return Matriz.new(new_t)
end

function Matriz.mt.__pow (m, n)
    if m.i ~= m.j then
        error("Can't elevate, array dimensions don't match")
    elseif n == 0 then
        return Matriz.IDENTIDAD(m.i)
    elseif n < 0 then
        error("Can't elevate, index has to be >= 1")
    end
    local new_m = m
    for i=1, n-1 do
        new_m = new_m * m
    end
    return new_m
end

-- MATRICES NOTABLES
function Matriz.ESCALAR(lenij, n)
    local escalar = {}
    for i=1, lenij do
        escalar[i] = {}
        for j=1, lenij do
            if i == j then elem = n
            else elem = 0 end
            escalar[i][j] = elem
        end
    end
    return Matriz.new(escalar)
end

function Matriz.IDENTIDAD(lenij)
    return Matriz.ESCALAR(lenij, 1)
end

function Matriz.NULA(leni, lenj)
    if leni == nil then return nil end
    local lenj = lenj or leni

    local nula = {}
    for i=1, leni do
        nula[i] = {}
        for j=1, lenj do
            nula[i][j] = 0
        end
    end
    return Matriz.new(nula)
end

-- COSAS QUE SE OBTIENEN DE UNA MATRIZ
function Matriz.getTraza( m )
    if m.i ~= m.j then return nil end
    local sum = 0
    for n=1, m.i do
        sum = sum + m.arr[n][n]
    end
    return sum
end

function Matriz.getTraspuesta( m )
    local tras = {}
    for j=1, m.j do
        tras[j] = {}
        for i=1, m.i do
            -- elem = m.arr[i][j] == 0 and 0 or 1
            elem = m.arr[i][j]
            tras[j][i] = elem
        end
    end
    return Matriz.new(tras)
end

function Matriz.getConjugada( m )
    -- TODO: No urgente. Um, creo que solo yo podria implemetar esta funcion, requiere modulo 'imaginario'
end

function Matriz.getEscalonada( m , ... )
    -- Los argumentos opcionales son otras matrices a las cuales aplicar las 
    -- operaciones se uso para que 'm' se escalonara.

    matrices = {...}
    -- TODO: arreglar este desastre completamente
    -- local new_m = m
    -- local elem

    -- local j = 1
    -- while j <= m.j do
    --         for i=j, m.i do
    --             elem = m.arr[i][j]
    --             if elem == 1 then
    --                 break
    --         end
    -- end

    -- return new_m
end

function Matriz.getRango( m )
    local escalonada = m:getEscalonada()
    if escalonada then
        return escalonada.i - escalonada:contarCeroRows()
    end
end

function Matriz.getIdentidadDeEscalonada( m , ... )
    -- transforma la matriz escalonada 'm' con una serie de operaciones, y tambien
    -- las aplica a los parametros opcionales

    -- TODO: implementar esta funcion
    matrices = {...}
end

function Matriz.getInversaPorGauss( m )
    if m.i ~= m.j then return nil end
    -- TODO: implementar esta funcion usando el modulo getEscalonada y la teoria

    -- local escalonada = m:concatRight(Matriz.INDETIDAD(m.j)):getEscalonada()
    -- if escalonada then
    --     local result = escalonada:spliceByColumns(1, m.j)
    --     local inversa = escalonada:spliceByColumns(m.j+1, joined.j)
    -- end
end

function Matriz.getDeterminante( m , length )
    if m.i ~= m.j or m.i < 2 then return nil end
    local length = length or m.i

    if length == 2 then
        return m.arr[1][1] * m.arr[2][2] - m.arr[2][1] * m.arr[1][2]

    elseif length == 3 then
        local suma1 = 0
        local suma2 = 0
        local mul1, mul2

        for n=0, length-1 do
            mul1 = 1; mul2 = 1

            for j=0, length-1 do
                _i = (j+n) % length
                mul1 = mul1 * m.arr[_i+1][j+1]
                mul2 = mul2 * m.arr[_i+1][length-j]
            end
            suma1 = suma1 + mul1
            suma2 = suma2 + mul2
        end

        return suma1 - suma2
    else
        return m:getDeterminantePorCofactores()
    end
end

function Matriz.getInversaPorAdjunta( m )
    if m.i ~= m.j then return nil end
    local determinante = m:getDeterminante()
    if determinante ~= 0 then
        return ( 1 / determinante ) * m:getAdjunta()
    end
end

Matriz.getInversa = Matriz.getInversaPorAdjunta

function Matriz.getMenorComplementario( m, i0, j0 )
    if m.i ~= m.j or m.i < 2 then return nil end
    local new_t = {}
    for i=1, m.i-1 do
        new_t[i] = {}
        for j=1, m.j-1 do
            new_t[i][j] = m.arr[ i<i0 and i or i+1 ][ j<j0 and j or j+1 ]
        end
    end
    return Matriz.new(new_t):getDeterminante()
end

function Matriz.getCofactor( m, i, j )
    if m.i ~= m.j then return nil end
    return ( -1 ) ^ ( (i+j)%2 ) * m:getMenorComplementario(i,j)
end

function Matriz.getDeterminantePorCofactores( m )
    if m.i ~= m.j then return nil end
    local suma = 0
    for j=1, m.j do
        suma = suma + m.arr[1][j] * m:getCofactor(1,j)
    end
    return suma
end

function Matriz.getMatrizDeCofactores( m )
    if m.i ~= m.j then return nil end

    local new_t = {}
    for i=1, m.i do
        new_t[i] = {}
        for j=1, m.j do
            new_t[i][j] = m:getCofactor(i,j)
        end
    end

    return Matriz.new(new_t)
end

function Matriz.getAdjunta( m )
    return m:getMatrizDeCofactores():getTraspuesta()
end


--- PROPIEDADES DE UNA MATRIZ (devuelven un bool)
function Matriz.esSimetrica( m )
    if m.i ~= m.j then return false end
    ---- otra forma de hallar si es simetrica
    -- return m == m:getTraspuesta()

    local count = 1
    for i = 2, m.i, 1 do
        for j = 1, count, 1 do
            _ij = m.arr[i][j]
            _ji = m.arr[j][i]

            if _ij ~= _ji then
                return false
            end
        end
        count = count + 1
    end

    return true
end

function Matriz.esAntisimetrica( m )
    return m == -m:getTraspuesta()
end

function Matriz.esIdempotente( m )
    if m.i ~= m.j then return false end
    return m^2 == m
end

function Matriz.esInvolutiva( m )
    if m.i ~= m.j then return false end
    return m^2 == Matriz.IDENTIDAD(m.i)
end

function Matriz.esNilpotente( m , i )
    if m.i ~= m.j then return false end

    local nula = Matriz.NULA(m.i)

    if i ~= nil then return m^i == nula and i or nil end

    local i = 1
    while i < 100 do
        if m^i == nula then
            return i
        end
        i = i + 1
    end

    return nil
end

function Matriz.esPeriodica( m , i )
    if m.i ~= m.j then return false end

    if i ~= nil then return m^(i+1) == m and i or nil end

    local i = 1
    while i < 100 do
        if m^(i+1) == m then
            return i
        end
        i = i + 1
    end

    return nil
end

function Matriz.esAutoadjunta( m )
    if m.i ~= m.j then return false end
    return m == m:getConjugada():getTraspuesta()
end

function Matriz.esHermitiana( m )
    return m:esAutoadjunta()
end

function Matriz.esOrtogonal( m )
    if m.i ~= m.j then return false end
    return m:getInversa() == m:getTraspuesta()
end

function Matriz.esSingular( m )
    if m.i ~= m.j then return false end
    return m:getDeterminante() == 0
end

--- CERRADURA
-- function Matriz.cerrReflexiva( m )
--     return m + Matriz.IDENTIDAD(m.i)
-- end
-- function Matriz.cerrSimetrica( m )
--     return m + Matriz.getTraspuesta( m )
-- end
-- function Matriz.cerrTransitiva( m )
--     return m + m * m 
-- end

return Matriz
