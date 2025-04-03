local timer = {}

-- Define the timer.new function
function timer.new(interval)
  -- Create a new timer object
  local t = {
    interval = interval,
    last_time = globals.real_time()
  }

  -- Return the new timer object
  return t
end

-- Define the timer.check function
function timer.check(t)
  -- Get the current time
  local current_time = globals.real_time()

  -- Check if the timer has reached the interval
  if current_time - t.last_time >= t.interval then
    -- Update the timer's last time
    t.last_time = current_time

    -- Return true to indicate that the timer has reached the interval
    return true
  end

  -- Return false if the timer has not reached the interval yet
  return false
end

return timer