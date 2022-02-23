init = function()
  
  callback = function(result)
    print('child process is done')
    print(result)
    -- we expect the result to be in the form of a lua table 
    fn = load("return "..result)
    user=fn()
    tab.print(user)
  end
  
  cmd = "/home/we/dust/code/tests/lib/shdemo.sh"
  norns.system_cmd(cmd, callback)
  
  print('waiting for child process, doing some work...')
  
end
