
local QueryPerformanceCounterAddr = utils.find_pattern("tier0.dll", "FF 15 ? ? ? ? 80 3D ? ? ? ? ? 74 16")

local QueryPerformanceFrequency = ffi.cast("bool(__stdcall*)(int64_t*)", ffi.cast("uint32_t**", QueryPerformanceCounterAddr - 0x53 + 2)[0][0])
local QueryPerformanceCounter = ffi.cast("bool(__stdcall*)(int64_t*)", ffi.cast("uint32_t**", QueryPerformanceCounterAddr + 2)[0][0])

local int64ptr = ffi.typeof("int64_t[1]")

local FreqPtr = int64ptr()
QueryPerformanceFrequency(FreqPtr)
local Freq = tonumber(FreqPtr[0])

local function NewBenchmark()
    local time_stamp = int64ptr()
    QueryPerformanceCounter(time_stamp)


    return 
    {
        start_time  = time_stamp,
        end_time    = int64ptr(),
        finish = function (self)
            self.end_time[0] = 0
            QueryPerformanceCounter(self.end_time)


            return tonumber((self.end_time[0] - self.start_time[0])) / Freq
        end,

        restart = function (self)
            self.start_time[0] = 0
            QueryPerformanceCounter(self.start_time)
        end,

        log = function (self)
            local time = self:finish()
            utils.print_console("[Benchmark] ", render.color("#c9a00c"))
            utils.print_console("finished in: ", render.color("#FFFFFF"))
            utils.print_console(string.format("%0.1fms\n", time * 1000), render.color("#7fa7fa"))
        end
    }
end

local GlobalTimestamp = int64ptr()
local function GetTimestamp()
    GlobalTimestamp[0] = 0
    QueryPerformanceCounter(GlobalTimestamp)

    return tonumber(GlobalTimestamp[0]) / Freq
end

return {new = NewBenchmark, timestamp = GetTimestamp}