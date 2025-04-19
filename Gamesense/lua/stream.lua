--[[
Lua Stream API 1.0.0
Created 2016 by Michael Karneim.
For detailed documentation on the Lua Stream API please see <http://github.com/mkarneim/lua-stream-api>.

  This is free and unencumbered software released into the public domain.

  Anyone is free to copy, modify, publish, use, compile, sell, or
  distribute this software, either in source code form or as a compiled
  binary, for any purpose, commercial or non-commercial, and by any
  means.

  In jurisdictions that recognize copyright laws, the author or authors
  of this software dedicate any and all copyright interest in the
  software to the public domain. We make this dedication for the benefit
  of the public at large and to the detriment of our heirs and
  successors. We intend this dedication to be an overt act of
  relinquishment in perpetuity of all present and future rights to this
  software under copyright law.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  OTHER DEALINGS IN THE SOFTWARE.

  For more information, please refer to <http://unlicense.org>

This function returns a sequential stream with the provided input as its source.
The input parameter must be nil or one of type table, boolean, number, string, or function.
* If input is of type table, then the the new stream is created from the elements of the table,
  assuming that the table is an array indexed with consecutive numbers from 1 to n, containing
  no nil values.
* If input is a single value of type boolean, number, or string, then the new stream contains
  just this value as its only element.
* If input if of type function, then the new stream is created with this function as its
  iterator function, which must be a parameterless function that produces the "next" element on
  each call.
* If input is nil (or not provided at all), then the new stream is empty.
--]]

local function stream(input)

	-- The following _* functions are internal functions that implement the stream's behaviour based
	-- on iterator functions.
	-- The documentation of these functions is obmitted since it can be easiy deduced from the
	-- documentation of the corresponding stream function at the end of this file.

	local function _iterator(input)
		if input == nil then
			error("input must be of type table, but was nil")
		elseif type(input)~="table" then
			error("input must be of type table, but was a "..type(input)..": "..input)
		end
		local len = #input
		local i = 0
		local result = function()
			i = i + 1
			if i > len then
				return nil
			else
				return input[i]
			end
		end
		return result
	end

	local function _next(iter)
		return iter()
	end

	local function _concat(itarr)
		local len = #itarr
		local i = 1
		local it = itarr[i]
		local result = function()
			if i > len then
				return nil
			else
				while true do
					local e = it()
					if e ~= nil then
						return e
					else
						i = i + 1
						if i > len then
							return nil
						else
							it = itarr[i]
						end
					end
				end
			end
		end
		return result
	end

	local function _peek(iter,c)
		if c == nil then
			error("c must be of type function, but was nil")
		end
		if type(c)~="function" then
			error("c must be of type function, but was a "..type(c))
		end
		local result = function()
			local e = iter()
			if e ~= nil then
				c(e)
			end
			return e
		end
		return result
	end

	local function _filter(iter,p)
		if p == nil then
			error("p must be of type function, but was nil")
		end
		if type(p)~="function" then
			error("p must be of type function, but was a "..type(p))
		end
		local result = function()
			local e = iter()
			while e ~= nil do
				if p(e) then
					return e
				else
					e = iter()
				end
			end
			return nil
		end
		return result
	end

	local function _pack(iter,n)
		return function()
			local result = nil
			for i=1,n do
				local e = iter()
				if e == nil then
					return result
				else
					if result == nil then
						result = {}
					end
					table.insert(result,e)
				end
			end
			return result
		end
	end

	local function _map(iter,f)
		if f == nil then
			error("f must be of type function, but was nil")
		end
		if type(f)~="function" then
			error("f must be of type function, but was a "..type(f))
		end
		local result = function()
			local e = iter()
			if e ~= nil then
				return f(e)
			else
				return nil
			end
		end
		return result
	end

	local function _flatmap(iter,f)
		if f == nil then
			error("f must be of type function, but was nil")
		end
		if type(f)~="function" then
			error("f must be of type function, but was a "..type(f))
		end
		local it = nil
		local result = function()
			while true do
				if it == nil then
					local e = iter()
					if e == nil then
						return nil
					else
						it = _iterator(f(e))
					end
				else
					local e = it()
					if e ~= nil then
						return e
					else
						it = nil
					end
				end
			end
		end
		return result
	end

	local function _flatten(iter)
		return _flatmap(iter, function(e) return e end)
	end

	local function _distinct(iter)
		local processed = {}
		local result = function()
			local e = iter()
			while e ~= nil do
				if processed[e]==nil then
					processed[e]=true
					return e
				else
					e = iter()
				end
			end
			return nil
		end
		return result
	end

	local function _limit(iter,max)
		local count = 0
		local result = function()
			count = count + 1
			if count > max then
				return nil
			else
				return iter()
			end
		end
		return result
	end

	local function _skip(iter,num)
		local i = 0
		while i<num do
			i = i + 1
			local e = iter()
			if e == nil then
				break
			end
		end
		return iter
	end

	local function _last(iter)
		local result = nil
		for e in iter do
			result = e
		end
		return result
	end

	local function _foreach(iter,c)
		if c == nil then
			error("c must be of type function, but was nil")
		end
		if type(c)~="function" then
			error("c must be of type function, but was a "..type(c))
		end
		for e in iter do
			c(e)
		end
	end

	local function _toarray(iter)
		local result = {}
		local i = 0
		for e in iter do
			i = i + 1
			result[i] = e
		end
		return result
	end

	local function _shuffle(iter)
		local result = _toarray(iter)
		local rand = math.random
		local iterations = #result
		local j
		for i = iterations, 2, -1 do
			j = rand(i)
			result[i], result[j] = result[j], result[i]
		end
		return _iterator(result)
	end

	local function _group(iter,f)
		if f == nil then
			error("f must be of type function, but was nil")
		end
		if type(f)~="function" then
			error("f must be of type function, but was a "..type(f))
		end
		local result = {}
		for e in iter do
			local key = f(e)
			local values = result[key]
			if values == nil then
				values = {}
				result[key] = values
			end
			values[#values+1] = e
		end
		return result
	end

	local function _split(iter,f)
		if f == nil then
			error("f must be of type function, but was nil")
		end
		if type(f)~="function" then
			error("f must be of type function, but was a "..type(f))
		end
		local a1 = {}
		local a2 = {}
		local function pull(match,amatch,anomatch)
			return function()
				if amatch[1] ~= nil then
					return table.remove(amatch,1)
				else
					local e = iter()
					while e ~= nil do
						if f(e) == match then
							return e
						else
							table.insert(anomatch,e)
							e = iter()
						end
					end
					return nil
				end
			end
		end
		local it1 = pull(true,a1,a2)
		local it2 = pull(false,a2,a1)
		return stream(it1), stream(it2)
	end

	local function _merge(itarr)
		local idx = 1
		return function()
			local len = #itarr
			if len == 0 then
				return nil
			end
			for i=1,len do
				if idx > len then
					idx = 1
				end
				local it = itarr[idx]
				local e = it()
				if e ~= nil then
					idx = idx + 1
					return e
				else
					table.remove(itarr, idx)
					len = #itarr
				end
			end

			local nilcount = 0
			local result = {}
			for i,it in ipairs(itarr) do
				local e = it()
				if e == nil then
					nilcount = nilcount + 1
				else
					result[i-nilcount] = e
				end
			end
			if nilcount >= #itarr then
				return nil
			else
				return result
			end
		end
	end

	local function _reduce(iter,init,op)
		if op == nil then
			error("op must be of type function, but was nil")
		end
		if type(op)~="function" then
			error("op must be of type function, but was a "..type(op))
		end
		local result = init
		for e in iter do
			result = op(result,e)
		end
		return result
	end

	local function _reverse(iter)
		local result = _toarray(iter)
		local len = #result
		for i=1, len/2 do
			result[i], result[len-i+1] = result[len-i+1], result[i]
		end
		return _iterator(result)
	end

	local function _sort(iter,comp)
		local result = _toarray(iter)
		table.sort(result,comp)
		return _iterator(result)
	end

	local function _count(iter)
		local result = 0
		for e in iter do
			result = result + 1
		end
		return result
	end

	local function _max(iter,comp)
		local result = nil
		for e in iter do
			if result == nil or (comp ~= nil and comp(result,e)) or result < e then
				result = e
			end
		end
		return result
	end

	local function _min(iter,comp)
		local result = nil
		for e in iter do
			if result == nil or (comp ~= nil and comp(e,result)) or e < result then
				result = e
			end
		end
		return result
	end

	local function _sum(iter)
		local result = 0
		for e in iter do
			result = result + e
		end
		return result
	end

	local function _avg(iter)
		local sum = 0
		local count = 0;
		for e in iter do
			count = count + 1
			sum = sum + e
		end
		if count == 0 then
			return nil
		else
			return sum/count
		end
	end

	local function _allmatch(iter,p)
		if p == nil then
			error("p must be of type function, but was nil")
		end
		if type(p)~="function" then
			error("p must be of type function, but was a "..type(p))
		end
		for e in iter do
			if not p(e) then
				return false
			end
		end
		return true
	end

	local function _anymatch(iter,p)
		if p == nil then
			error("p must be of type function, but was nil")
		end
		if type(p)~="function" then
			error("p must be of type function, but was a "..type(p))
		end
		for e in iter do
			if p(e) then
				return true
			end
		end
		return false
	end

	local function _nonematch(iter,p)
		return not _anymatch(iter,p)
	end

	-- Returns a new stream created form the given interator function.
	local function _stream(iter)
		local result = {
			-- Returns the iterator function for the elements of this stream.
			iter = function()
				return iter
			end,
			-- Returns the next (aka first) element of this stream, or nil if the stream is empty.
			next = function()
				return _next(iter)
			end,
			-- Returns a lazily concatenated stream whose elements are all the elements of this stream
			-- followed by all the elements of the streams provided by the varargs parameter.
			concat = function(...)
				local streams = {iter}
				for i,s in ipairs({...}) do
					streams[i+1] = s.iter()
				end
				return stream(_concat(streams))
			end,
			-- Returns a stream consisting of the elements of this stream, additionally performing
			-- the provided action on each element as elements are consumed from the resulting stream.
			peek = function(c)
				return stream(_peek(iter,c))
			end,
			-- Returns a stream consisting of the elements of this stream that match the given predicate.
			filter = function(p)
				return stream(_filter(iter,p))
			end,
			-- Returns a stream consisting of chunks, made of n adjacent elements of the original stream.
			pack = function(n)
				return stream(_pack(iter,n))
			end,
			-- Returns a stream consisting of the results of applying the given function
			-- to the elements of this stream.
			map = function(f)
				return stream(_map(iter,f))
			end,
			-- Returns a stream consisting of the flattened results
			-- produced by applying the provided mapping function on each element.
			flatmap = function(f)
				return stream(_flatmap(iter,f))
			end,
			-- Returns a stream consisting of the flattened elements.
			flatten = function()
				return stream(_flatten(iter))
			end,
			-- Returns a stream consisting of the elements of this stream,
			-- truncated to be no longer than maxsize in length.
			limit = function(maxsize)
				return stream(_limit(iter,maxsize))
			end,
			-- Returns a stream consisting of the remaining elements of this stream
			-- after discarding the first n elements of the stream. If this stream contains
			-- fewer than n elements then an empty stream will be returned.
			skip = function(n)
				return stream(_skip(iter,n))
			end,
			-- Returns the last element of this stream.
			last = function()
				return _last(iter)
			end,
			-- Performs the given action for each element of this stream.
			foreach = function(c)
				_foreach(iter,c)
			end,
			-- Returns an array containing the elements of this stream.
			toarray = function()
				return _toarray(iter)
			end,
			-- Returns a stream consisting of the elements of this stream, ordered randomly.
			-- Call math.randomseed( os.time() ) first to get nice random orders.
			shuffle = function()
				return stream(_shuffle(iter))
			end,
			-- Returns a table which is grouping the elements of this stream by keys provided from
			-- the specified classification function.
			group = function(f)
				return _group(iter,f)
			end,
			-- Returns two streams consisting of the elements of this stream
			-- separated by the given predicate.
			split = function(f)
				return _split(iter,f)
			end,
			-- Returns a lazily merged stream whose elements are all the elements of this stream
			-- and of the streams provided by the varargs parameter. The elements are taken from all
			-- streams round-robin.
			merge = function(...)
				local itarr = {iter}
				for i,s in ipairs({...}) do
					itarr[i+1] = s.iter()
				end
				return stream(_merge(itarr))
			end,
			-- Returns the result of the given collector that is supplied
			-- with an iterator for the elements of this stream.
			collect = function(c)
				return c(iter)
			end,
			-- Performs a reduction on the elements of this stream, using the provided initial value
			-- and the associative accumulation function, and returns the reduced value.
			reduce = function(init,op)
				return _reduce(iter,init,op)
			end,
			-- Returns a stream consisting of the elements of this stream in reversed order.
			reverse = function()
				return stream(_reverse(iter))
			end,
			-- Returns a stream consisting of the elements of this stream, sorted according to the
			-- provided comparator.
			-- See table.sort for details on the comp parameter.
			-- If comp is not given, then the standard Lua operator < is used.
			sort = function(comp)
				return stream(_sort(iter,comp))
			end,
			-- Returns a stream consisting of the distinct elements
			-- (according to the standard Lua operator ==) of this stream.
			distinct = function()
				return stream(_distinct(iter))
			end,
			-- Returns the count of elements in this stream.
			count = function()
				return _count(iter)
			end,
			-- Returns the maximum element of this stream according to the provided comparator,
			-- or nil if this stream is empty.
			-- See table.sort for details on the comp parameter.
			-- If comp is not given, then the standard Lua operator < is used.
			max = function(comp)
				return _max(iter,comp)
			end,
			-- Returns the minimum element of this stream according to the provided comparator,
			-- or nil if this stream is empty.
			-- See table.sort for details on the comp parameter.
			-- If comp is not given, then the standard Lua operator < is used.
			min = function(comp)
				return _min(iter,comp)
			end,
			-- Returns the sum of elements in this stream.
			sum = function()
				return _sum(iter)
			end,
			-- Returns the arithmetic mean of elements of this stream, or nil if this stream is empty.
			avg = function()
				return _avg(iter)
			end,
			-- Returns whether all elements of this stream match the provided predicate.
			-- If the stream is empty then true is returned and the predicate is not evaluated.
			allmatch = function(p)
				return _allmatch(iter,p)
			end,
			-- Returns whether any elements of this stream match the provided predicate.
			-- If the stream is empty then false is returned and the predicate is not evaluated.
			anymatch = function(p)
				return _anymatch(iter,p)
			end,
			-- Returns whether no elements of this stream match the provided predicate.
			-- If the stream is empty then true is returned and the predicate is not evaluated.
			nonematch = function(p)
				return _nonematch(iter,p)
			end
		}
		return result
	end

	-- create an appropriate stream depending on the input type
	if input==nil then
		return _stream(_iterator({}))
	elseif type(input)=="table" then
		return _stream(_iterator(input))
	elseif type(input)=="boolean" or type(input)=="number" or type(input)=="string" then
		return _stream(_iterator({input}))
	elseif type(input)=="function" then
		return _stream(input)
	else
		error("input must be nil or of type table, boolean, number, string, or function, but was a "..type(input))
	end
end

return stream;