
-- clump table `x` into `n` parts, with remainder
function clump_remain(x, n)
  local len = #x
  local w = math.floor(len/n)
  local remain = len - (w * n)
  
  print("len="..len .. "; w="..w.."; count="..n.."; remain="..remain)
  
  local y = {}
  
  local src_idx = 1
  
  for i=1,n do
    local z={}
    for j=1,w do
      table.insert(z, x[src_idx])
      src_idx = src_idx + 1
    end
    table.insert(y, z)
  end
  if remain > 0 then
    local z = {}
    for i=1,remain do
      table.insert(z, x[src_idx])
      src_idx = src_idx + 1
    end
    table.insert(y, z)
  end
  return y
end


-- clump table `x` into `n` parts, with euclidean distribution
function clump_er(x, n)
  local len = #x
  local y = {}
  local z = {}
  local b = 0
  for i,v in ipairs(x) do
    table.insert(z, v)
    b = b + n
    if b > len then
      table.insert(y, z)
      z = {}
      b = b - len
    end
  end
  if #z > 0 then table.insert(y, z) end
  return y
end

function print_clumps(y) 
  for _,v in pairs(y) do
    print("{")
    for _,w in pairs(v) do
      print("  " .. w)
    end
    print("}")
  end
end