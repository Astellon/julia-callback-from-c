const lib = joinpath(pwd(), "async.so")

done = true

function job(async)
  global done
  sleep(2)  # heavy task
  println("job is done")
  done = true
end

cond = Base.AsyncCondition(job)

function CB(handle)
  global done
  done = false
  ccall(:uv_async_send, Cint, (Ptr{Cvoid},), handle)  
  while !done end
  return
end

cb_ptr = @cfunction(CB, Cvoid, (Ptr{Cvoid},))

ccall((:set,  lib), Cvoid, (Ptr{Cvoid},), cb_ptr)
ccall((:call, lib), Cvoid, (Ptr{Cvoid},), cond.handle)

