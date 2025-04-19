-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_create_interface, client_set_event_callback, ui_get, ui_new_checkbox = client.create_interface, client.set_event_callback, ui.get, ui.new_checkbox

local ffi = require 'ffi'
ffi.cdef[[
  typedef bool(__thiscall *DispatchUserMessage_t)(void*, int messageType, int passthroughFlags, int size, const void* data);
  typedef bool(__thiscall *hkDispatchUserMessage_t)(void*, int messageType, int passthroughFlags, int size, const void* data);
]]

-- Get a pointer to the interface table of the client module
local interface = ffi.cast('uintptr_t**', client_create_interface('client.dll', 'VClient018'))

-- Get a pointer to the original function table
local orig_table = ffi.cast('uintptr_t*', interface[0])

-- Get the size of the original function table
local table_size = 0
while orig_table[table_size] ~= 0x0 do table_size = table_size + 1 end

-- Create a new function table with the same size as the original one
local hooked_table = ffi.new('uintptr_t[?]', table_size)

-- Copy the original functions into the new table
for i = 0, table_size - 1 do hooked_table[i] = orig_table[i] end

-- Replace the original function table with the new one
interface[0] = hooked_table

-- Define the list of blocked messages (by message type)
local blocked_messages = {
  [1] = true, -- CS_UM_VGUIMenu
  [5] = true, -- CS_UM_SayText
  [7] = true, -- CS_UM_TextMsg
  [22] = true -- CS_UM_RadioText
}

-- Get the original dispatch user message function
local oDispatch = ffi.cast('DispatchUserMessage_t', orig_table[38])

-- Create a menu checkbox to toggle whether it's enabled
local enabled = ui_new_checkbox('Misc', 'Miscellaneous', 'Block server chat advertisements')

-- Define the hook function for the dispatch user message function
local function hkDispatch(this, type, flags, size, data)
  -- Return the result of the original dispatch user message function if the message type is not blocked, otherwise return true
  return (blocked_messages[type] and ui_get(enabled)) and true or oDispatch(this, type, flags, size, data)
end

-- Replace the original dispatch user message function with the hook function
hooked_table[38] = ffi.cast('uintptr_t', ffi.cast('void*', ffi.cast('hkDispatchUserMessage_t', hkDispatch)))

-- Set a shutdown event callback to restore the original function table
client_set_event_callback('shutdown', function()
  hooked_table[38] = orig_table[38]
  interface[0] = orig_table
end)