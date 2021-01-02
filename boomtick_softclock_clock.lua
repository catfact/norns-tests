--- clock timing test

engine.name = 'Boomtick'

-- two 16-note patterns
-- should be independent but synchronized

pattern_1 = {4, 4, 4, 3, 1}
pattern_2 = {2, 3, 3}

state_1 = { 
  stage= 1,
  count= 0,
  nstages = #pattern_1
}

state_2 = { 
  stage= 1,
  count= 0,
  nstages = #pattern_2
}

function update(state, pattern, action)
  if state.count == 0 then action() end
  state.count = state.count + 1
  if state.count == pattern[state.stage] then
    state.count = 0
    state.stage = state.stage + 1
    if state.stage > state.nstages then 
      state.stage = 1
    end
  end
  return state
end

main = function()
  state_1 = update(state_1, pattern_1, function() engine.boom() end)
  state_2 = update(state_2, pattern_2, function() engine.tick() end)
end

init = function() 
  params:set("reverb", 1)
  local m = metro.init(main, 60 / (120 * 4))
  m:start()
end 