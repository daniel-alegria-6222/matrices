utl = require("utils")

local Imaginario = {}
Imaginario.mt = {__index = Imaginario}

function Imaginario.new( rel, img )
    this = setmetatable({}, Imaginario.mt)
    this.clsname = "Imaginario"
    this.rel = rel
    this.img = img or 0
    return this
end
function Imaginario.mt.__tostring( t )
        -- TODO: dont show real part when it is 0
        -- TODO: fix anoyances
    local rel_str = t.rel == 0 and "" or tostring(t.rel) .. " "

    img_str = ""
    if t.img ~= 0 then
        local img_sign = t.img < 0 and "-" or "+"
        local spc = rel_str == "" and "" or " "
        local img_k = t.img < 0 and -1 or 1

        img_str = img_sign .. spc .. tostring(img_k*t.img) .. "i"
    end

    return rel_str .. img_str
end

-- OPERACIONES ENTRE IMAGINARIOS
function Imaginario.mt.__unm (t)
    return Imaginario.new( -t.rel, -t.img )
end
function Imaginario.mt.__add (t1, t2)
    if type(t1) == "number" then
        return Imaginario.new( t1+t2.rel, t2.img )
    elseif type(t2) == "number" then
        return Imaginario.new( t1.rel+t2, t1.img )
    end
    return Imaginario.new( t1.rel+t2.rel, t1.img+t2.img )
end
function Imaginario.mt.__sub (t1, t2)
    if type(t1) == "number" then
        return Imaginario.new( t1-t2.rel, -t2.img )
    elseif type(t2) == "number" then
        return Imaginario.new( t1.rel-t2, t1.img )
    end
    return Imaginario.new( t1.rel-t2.rel, t1.img-t2.img )
end
function Imaginario.mt.__mul (t1, t2)
    if type(t1) == "number" then
        return Imaginario.new( t1*t2.rel, t1*t2.img )
    elseif type(t2) == "number" then
        return Imaginario.new( t2*t1.rel, t2*t1.img )
    end
    local rel = t1.rel*t2.rel - t1.img*t2.img
    local img = t1.rel*t2.img + t1.img*t2.rel
    return Imaginario.new( rel, img )
end
function Imaginario.mt.__pow (t, n)
end

-- OTRAS OPERACINES ESPECIALES
function Imaginario.conjugada ( t )
    return Imaginario.new(t.rel, -t.img)
end

return Imaginario
