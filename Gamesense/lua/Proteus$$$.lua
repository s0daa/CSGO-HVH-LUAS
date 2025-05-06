local ffi = require('ffi')

function catch(what)
    return what[1]
end
 
function try(what)
    status, result = pcall(what[1])
    if not status then
        what[2](result)
    end
    return result
end

local revealer = { set_cheat = function(target, cheat) end }
try {
    function()
        revealer = require('gamesense/cheat_revealer')
    end,
    function(err) end
}

local signatures = { }
local natives = { }
local modules = { }
local constants = { }
local procedures = { }
local menu = { }
local tools = { }
local proteus = { }

local timer = 0
local ev0lve_counter = 0

tools.uint32_to_bytes = function(uint32)
    local raw_addr = ffi.new('uint32_t[1]')
    raw_addr[0] = ffi.cast('uint32_t', uint32)
    return ffi.cast('const void*', raw_addr)
end

tools.uint32_to_number = function(uint32)
    return tonumber(ffi.cast('uint32_t', uint32))
end

proteus.send_fatality_voice_data = function()
    local base_voice_data = ffi.new('base_voice_data[1]')
    base_voice_data[0].current_len = 0
    base_voice_data[0].max_len = 15

    local msg_voice_data = ffi.new('CCLCMsg_VoiceData[1]')
    ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data, ffi.cast('void *', 0))
    natives.write_raw(ffi.cast('uint32_t', msg_voice_data) + 0x18, ffi.new('char[?]', 8, {0xFA, 0x7F, 0x00, 0x00, 0x9A, 0x9F, 0xEA, 0xFF}), 8)
    msg_voice_data[0].sequence_bytes = math.random(0, 0xFFFFFFF)
    msg_voice_data[0].section_number = math.random(0, 0xFFFFFFF)
    msg_voice_data[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
    msg_voice_data[0].data = base_voice_data
    msg_voice_data[0].format = 0
    msg_voice_data[0].flags = 63

    ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data), false, true)
end

proteus.send_rifk7_voice_data = function()
    local base_voice_data = ffi.new('base_voice_data[1]')
    base_voice_data[0].current_len = 0
    base_voice_data[0].max_len = 15

    local msg_voice_data = ffi.new('CCLCMsg_VoiceData[1]')
    ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data, ffi.cast('void *', 0))
    natives.write_raw(ffi.cast('uint32_t', msg_voice_data) + 0x18, ffi.new('char[?]', 8, {0x34, 0x01, 0x00, 0x00, 0x9A, 0x9F, 0xEA, 0xFF}), 8)
    msg_voice_data[0].sequence_bytes = math.random(0, 0xFFFFFFF)
    msg_voice_data[0].section_number = math.random(0, 0xFFFFFFF)
    msg_voice_data[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
    msg_voice_data[0].data = base_voice_data
    msg_voice_data[0].format = 0
    msg_voice_data[0].flags = 63

    ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data), false, true)
end

proteus.send_onetap_voice_data = function()
    local base_voice_data = ffi.new('base_voice_data[1]')
    base_voice_data[0].current_len = 0
    base_voice_data[0].max_len = 15

    local msg_voice_data = ffi.new('CCLCMsg_VoiceData[1]')
    ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data, ffi.cast('void *', 0))
    natives.write_raw(ffi.cast('uint32_t', msg_voice_data) + 0x18, ffi.new('char[?]', 8, {0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF}), 8)
    msg_voice_data[0].sequence_bytes = 0x33333333
    msg_voice_data[0].section_number = 0x22222222
    msg_voice_data[0].uncompressed_sample_offset = 0x11111111
    msg_voice_data[0].data = base_voice_data
    msg_voice_data[0].format = 0
    msg_voice_data[0].flags = 63

    ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data), false, true)
end

proteus.send_airflow_voice_data = function()
    local base_voice_data = ffi.new('base_voice_data[1]')
    base_voice_data[0].current_len = 0
    base_voice_data[0].max_len = 15

    local msg_voice_data = ffi.new('CCLCMsg_VoiceData[1]')
    ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data, ffi.cast('void *', 0))
    natives.write_raw(ffi.cast('uint32_t', msg_voice_data) + 0x18, ffi.new('char[?]', 8, {0xF1, 0xAF, 0x00, 0x00, 0x9A, 0x9F, 0xEA, 0xFF}), 8)
    msg_voice_data[0].sequence_bytes = math.random(0, 0xFFFFFFF)
    msg_voice_data[0].section_number = math.random(0, 0xFFFFFFF)
    msg_voice_data[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
    msg_voice_data[0].data = base_voice_data
    msg_voice_data[0].format = 0
    msg_voice_data[0].flags = 63

    ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data), false, true)
end

proteus.send_pandora_voice_data = function()
    local base_voice_data = ffi.new('base_voice_data[1]')
    base_voice_data[0].current_len = 0
    base_voice_data[0].max_len = 15

    local msg_voice_data = ffi.new('CCLCMsg_VoiceData[1]')
    ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data, ffi.cast('void *', 0))
    natives.write_raw(ffi.cast('uint32_t', msg_voice_data) + 0x18, ffi.new('char[?]', 8, {0x5B, 0x69, 0x00, 0x00, 0x9A, 0x9F, 0xEA, 0xFF}), 8)
    msg_voice_data[0].sequence_bytes = math.random(0, 0xFFFFFFF)
    msg_voice_data[0].section_number = math.random(0, 0xFFFFFFF)
    msg_voice_data[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
    msg_voice_data[0].data = base_voice_data
    msg_voice_data[0].format = 0
    msg_voice_data[0].flags = 63

    ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data), false, true)
end

proteus.send_nixware_voice_data = function()
    local base_voice_data = ffi.new('base_voice_data[1]')
    base_voice_data[0].current_len = 0
    base_voice_data[0].max_len = 15

    local msg_voice_data0 = ffi.new('CCLCMsg_VoiceData[1]')
    ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data0, ffi.cast('void *', 0))
    natives.write_virtual(ffi.cast('uint32_t', msg_voice_data0) + 0x18, {2, 0, 0, 0})
    msg_voice_data0[0].sequence_bytes = math.random(0, 0xFFFFFFF)
    msg_voice_data0[0].section_number = math.random(0, 0xFFFFFFF)
    msg_voice_data0[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
    msg_voice_data0[0].data = base_voice_data
    msg_voice_data0[0].format = 0
    msg_voice_data0[0].flags = 63

    ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data0), false, true)
end

proteus.send_plague_voice_data = function()
    local base_voice_data = ffi.new('base_voice_data[1]')
    base_voice_data[0].current_len = 0
    base_voice_data[0].max_len = 15

    local msg_voice_data0 = ffi.new('CCLCMsg_VoiceData[1]')
    ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data0, ffi.cast('void *', 0))
    natives.write_virtual(ffi.cast('uint32_t', msg_voice_data0) + 0x18, {math.random(0, 0xFF), math.random(0, 0xFF), math.random(0, 0xFF), math.random(0, 0xFF), math.random(0, 0xFF), math.random(0, 0xFF), math.random(0, 0xFF), math.random(0, 0xFF)})
    msg_voice_data0[0].sequence_bytes = math.random(0, 0xFFFFFFF)
    msg_voice_data0[0].section_number = math.random(0, 0xFFFFFFF)
    msg_voice_data0[0].uncompressed_sample_offset = 0x7275
    msg_voice_data0[0].data = base_voice_data
    msg_voice_data0[0].format = 0
    msg_voice_data0[0].flags = 63

    ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data0), false, true)
end

proteus.send_neverlose_voice_data = function()
    local base_voice_data = ffi.new('base_voice_data[1]')
    base_voice_data[0].current_len = 0
    base_voice_data[0].max_len = 15

    local msg_voice_data0 = ffi.new('CCLCMsg_VoiceData[1]')
    ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data0, ffi.cast('void *', 0))
    natives.write_virtual(ffi.cast('uint32_t', msg_voice_data0) + 0x18, {0, 1, 2, 3, 4, 5, 6, 7})
    msg_voice_data0[0].sequence_bytes = math.random(0, 0xFFFFFFF)
    msg_voice_data0[0].section_number = math.random(0, 0xFFFFFFF)
    msg_voice_data0[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
    msg_voice_data0[0].data = base_voice_data
    msg_voice_data0[0].format = 0
    msg_voice_data0[0].flags = 63

    ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data0), false, true)
end

proteus.send_ev0lve_voice_data = function(counter)
    local base_voice_data = ffi.new('base_voice_data[1]')
    base_voice_data[0].current_len = 0
    base_voice_data[0].max_len = 15

    local msg_voice_data0 = ffi.new('CCLCMsg_VoiceData[1]')
    ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data0, ffi.cast('void *', 0))
    natives.write_virtual(ffi.cast('uint32_t', msg_voice_data0) + 0x18, {2, 0, 0, 0, 2, 0, 0, 0})
    msg_voice_data0[0].sequence_bytes = math.random(0, 0xFFFFFFF)
    msg_voice_data0[0].section_number = math.random(0, 0xFFFFFFF)
    msg_voice_data0[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
    msg_voice_data0[0].data = base_voice_data
    msg_voice_data0[0].format = 0
    msg_voice_data0[0].flags = 63

    local msg_voice_data1 = ffi.new('CCLCMsg_VoiceData[1]')
    ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data1, ffi.cast('void *', 0))
    natives.write_virtual(ffi.cast('uint32_t', msg_voice_data1) + 0x18, {2, 0, 0, 0, 2, 0, 0, 0})
    msg_voice_data1[0].sequence_bytes = math.random(0, 0xFFFFFFF)
    msg_voice_data1[0].section_number = math.random(0, 0xFFFFFFF)
    msg_voice_data1[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
    msg_voice_data1[0].data = base_voice_data
    msg_voice_data1[0].format = 0
    msg_voice_data1[0].flags = 63

    local msg_voice_data2 = ffi.new('CCLCMsg_VoiceData[1]')
    ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data2, ffi.cast('void *', 0))
    natives.write_virtual(ffi.cast('uint32_t', msg_voice_data2) + 0x18, {2, 0, 0, 0, 2, 0, 0, 0})
    msg_voice_data2[0].sequence_bytes = math.random(0, 0xFFFFFFF)
    msg_voice_data2[0].section_number = math.random(0, 0xFFFFFFF)
    msg_voice_data2[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
    msg_voice_data2[0].data = base_voice_data
    msg_voice_data2[0].format = 0
    msg_voice_data2[0].flags = 63

    local msg_voice_data3 = ffi.new('CCLCMsg_VoiceData[1]')
    ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data3, ffi.cast('void *', 0))
    natives.write_virtual(ffi.cast('uint32_t', msg_voice_data3) + 0x18, {3, 0, 0, 0, 3, 0, 0, 0})
    msg_voice_data3[0].sequence_bytes = math.random(0, 0xFFFFFFF)
    msg_voice_data3[0].section_number = math.random(0, 0xFFFFFFF)
    msg_voice_data3[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
    msg_voice_data3[0].data = base_voice_data
    msg_voice_data3[0].format = 0
    msg_voice_data3[0].flags = 63

    local msg_voice_data4 = ffi.new('CCLCMsg_VoiceData[1]')
    ffi.cast('msg_voicedata_constructor', signatures.voicedata_constructor)(msg_voice_data4, ffi.cast('void *', 0))
    natives.write_virtual(ffi.cast('uint32_t', msg_voice_data4) + 0x18, {3, 0, 0, 0, 3, 0, 0, 0})
    msg_voice_data4[0].sequence_bytes = math.random(0, 0xFFFFFFF)
    msg_voice_data4[0].section_number = math.random(0, 0xFFFFFFF)
    msg_voice_data4[0].uncompressed_sample_offset = math.random(0, 0xFFFFFFF)
    msg_voice_data4[0].data = base_voice_data
    msg_voice_data4[0].format = 0
    msg_voice_data4[0].flags = 63

    if ev0lve_counter == 0 then ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data0), false, true) end
    if ev0lve_counter == 1 then ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data1), false, true) end
    if ev0lve_counter == 2 then ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data2), false, true) end
    if ev0lve_counter == 3 then ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data3), false, true) end
    if ev0lve_counter == 4 then ffi.cast('send_net_msg_t', signatures.send_net_msg)(ffi.cast('i_net_channel_info *', signatures.client_state[0].m_NetChannel), ffi.cast('void *', 0), ffi.cast('c_net_message *', msg_voice_data4), false, true) end
end

local function init_signatures()
    ffi.cdef([[
        typedef struct i_net_channel_info { } i_net_channel_info;
        typedef struct c_net_message { } c_net_message;

        typedef bool( __fastcall *send_net_msg_t )( i_net_channel_info *, void *, c_net_message *, bool, bool );
        typedef uintptr_t( __thiscall *get_mod_address_t )( void *, const char * );
        typedef uintptr_t( __thiscall *get_proc_address_t )( void *, uintptr_t, const char * );

        typedef uintptr_t( __thiscall *virtual_alloc_t )( uintptr_t, uintptr_t, uintptr_t, uintptr_t, uintptr_t );
        typedef void *( __thiscall *virtual_protect_t )( uintptr_t, uintptr_t, uintptr_t, uint32_t, uint32_t * );

        typedef struct CCLCMsg_VoiceData
        {
            uint32_t INetMessage_vtable;         // 0x0000
            char pad_0004[ 4 ];                  // 0x0004
            uint32_t CCLCMsg_VoiceData_vtable;   // 0x0008
            char pad_000C[ 8 ];                  // 0x000C
            void* data;                          // 0x0014
            uint64_t xuid;                       // 0x0018
            int32_t format;                      // 0x0020
            int32_t sequence_bytes;              // 0x0024
            uint32_t section_number;             // 0x0028
            uint32_t uncompressed_sample_offset; // 0x002C
            int32_t cached_size;                 // 0x0030
            uint32_t flags;                      // 0x0034
            char pad_0038[ 255 ];                // 0x0038
        } CCLCMsg_VoiceData;

        typedef struct CNetChannel
        {
            int32_t vtable;                        // 0x0000 
            void* msgbinder1;                      // 0x0004 
            void* msgbinder2;
            void* msgbinder3;
            void* msgbinder4;
            unsigned char m_bProcessingMessages;
            unsigned char m_bShouldDelete;
            char pad_0x0016[ 0x2 ];
            int32_t m_nOutSequenceNr;
            int32_t m_nInSequenceNr;
            int32_t m_nOutSequenceNrAck;
            int32_t m_nOutReliableState;
            int32_t m_nInReliableState;
            int32_t m_nChokedPackets;
            char pad_0030[ 112 ];                  // 0x0030
            int32_t m_Socket;                      // 0x009C
            int32_t m_StreamSocket;                // 0x00A0
            int32_t m_MaxReliablePayloadSize;      // 0x00A4
            char remote_address[ 32 ];             // 0x00A8
            char m_szRemoteAddressName[ 64 ];      // 0x00A8
            float last_received;                   // 0x010C
            float connect_time;                    // 0x0110
            char pad_0114[ 4 ];                    // 0x0114
            int32_t m_Rate;                        // 0x0118
            char pad_011C[ 4 ];                    // 0x011C
            float m_fClearTime;                    // 0x0120
            char pad_0124[ 16688 ];                // 0x0124
            char m_Name[ 32 ];                     // 0x4254
            unsigned int m_ChallengeNr;            // 0x4274
            float m_flTimeout;                     // 0x4278
            char pad_427C[ 32 ];                   // 0x427C
            float m_flInterpolationAmount;         // 0x429C
            float m_flRemoteFrameTime;             // 0x42A0
            float m_flRemoteFrameTimeStdDeviation; // 0x42A4
            int32_t m_nMaxRoutablePayloadSize;     // 0x42A8
            int32_t m_nSplitPacketSequence;        // 0x42AC
            char pad_42B0[ 40 ];                   // 0x42B0
            bool m_bIsValveDS;                     // 0x42D8
            char pad_42D9[ 65 ];                   // 0x42D9
        } CNetChannel;

        typedef struct IClientState
        {
            char pad_0000[ 0x9C ];         // 0x0000
            CNetChannel* m_NetChannel;     // 0x009C
            uint32_t m_nChallengeNr;       // 0x00A0
            char pad_00A4[ 0x64 ];         // 0x00A4
            uint32_t m_nSignonState;       // 0x0108
            char pad_010C[ 0x8 ];          // 0x010C
            float m_flNextCmdTime;         // 0x0114
            uint32_t m_nServerCount;       // 0x0118
            uint32_t m_nCurrentSequence;   // 0x011C
            char pad_0120[ 4 ];            // 0x0120
            char m_ClockDriftMgr[ 0x50 ];  // 0x0124
            int32_t m_nDeltaTick;          // 0x0174
            bool m_bPaused;                // 0x0178
            char pad_0179[ 7 ];            // 0x0179
            uint32_t m_nViewEntity;        // 0x0180
            uint32_t m_nPlayerSlot;        // 0x0184
            char m_szLevelName[ 260 ];     // 0x0188
            char m_szLevelNameShort[ 40 ]; // 0x028C
            char m_szGroupName[ 40 ];      // 0x02B4
            char pad_02DC[ 52 ];           // 0x02DC
            uint32_t m_nMaxClients;        // 0x0310
            char pad_0314[ 18820 ];        // 0x0314
            float m_flLastServerTickTime;  // 0x4C98
            bool insimulation;             // 0x4C9C
            char pad_4C9D[ 3 ];            // 0x4C9D
            uint32_t oldtickcount;         // 0x4CA0
            float m_tickRemainder;         // 0x4CA4
            float m_frameTime;             // 0x4CA8
            char pad_4CAC[ 0x78 ];         // 0x4CAC
            char temp[ 0x8 ];              // 0x4CAC
            int32_t lastoutgoingcommand;   // 0x4CAC
            int32_t chokedcommands;        // 0x4CB0
            int32_t last_command_ack;      // 0x4CB4
            int32_t last_server_tick;      // 0x4CB8
            int32_t command_ack;           // 0x4CBC
            char pad_4CC0[ 80 ];           // 0x4CC0
            char viewangles[ 0xC ];        // 0x4D10
            char pad_4D14[ 0xD0 ];         // 0x4D1C
            void* m_Events;                // 0x4DEC
        } IClientState;

        typedef struct base_voice_data
        {
            char data[ 16 ];
            uint32_t current_len;
            uint32_t max_len;
        } base_voice_data;

        typedef struct voice_usable_fields
        {
            uint64_t xuid;
            int32_t sequence_bytes;
            uint32_t section_number;
            uint32_t uncompressed_sample_offset;
        } voice_usable_fields;

        typedef struct fatality_shared_esp_data
        {
            uint16_t identifier;
            uint8_t user_id;
            uint8_t weapon_id;
            uint32_t server_tick;
            char pos[ 12 ];
        } fatality_shared_esp_data;
    
        typedef uint32_t( __fastcall *msg_voicedata_constructor )( CCLCMsg_VoiceData *, void * );
    ]])

    signatures.send_net_msg = client.find_signature('engine.dll', string.char(0x55, 0x8B, 0xEC, 0x83, 0xEC, 0x08, 0x56, 0x8B, 0xF1, 0x8B, 0x4D, 0x04))
    assert(tonumber(ffi.cast('uint32_t', signatures.send_net_msg)) ~= 0, 'Failed to find pattern \"send_net_msg\"')

    signatures.voicedata_constructor = client.find_signature('engine.dll', string.char(0xC6, 0x46, 0xCC, 0xCC, 0x5E, 0xC3, 0x56, 0x57, 0x8B, 0xF9, 0x8D, 0x4F, 0xCC, 0xC7, 0x07, 0xCC, 0xCC, 0xCC, 0xCC, 0xE8))
    signatures.voicedata_constructor = ffi.cast('uint32_t', signatures.voicedata_constructor) + 6
    assert(tonumber(ffi.cast('uint32_t', signatures.voicedata_constructor)) ~= 6, 'Failed to find pattern \"voicedata_constructor\"')

    signatures.client_state = client.find_signature('engine.dll', string.char(0xA1, 0xCC, 0xCC, 0xCC, 0xCC, 0x8B, 0x80, 0xCC, 0xCC, 0xCC, 0xCC, 0xC3)) or error('Failed to find pattern \"client_state\"')
    signatures.client_state = ffi.cast('IClientState ***', ffi.cast('uint32_t', signatures.client_state) + 1)[0][0]

    signatures.get_mod_address = client.find_signature('client.dll', string.char(0xC6, 0x06, 0x00, 0xFF, 0x15, 0xCC, 0xCC, 0xCC, 0xCC, 0x50))
    assert(tonumber(ffi.cast('uint32_t', signatures.get_mod_address)) ~= 0, 'Failed to find pattern \"get_mod_address\"')

    signatures.get_proc_address = client.find_signature('client.dll', string.char(0x50, 0xFF, 0x15, 0xCC, 0xCC, 0xCC, 0xCC, 0x85, 0xC0, 0x0F, 0x84, 0xCC, 0xCC, 0xCC, 0xCC, 0x6A, 0x00))
    assert(tonumber(ffi.cast('uint32_t', signatures.get_proc_address)) ~= 0, 'Failed to find pattern \"get_proc_address\"')

    signatures.call_stub = client.find_signature("client.dll", string.char(0x51, 0xC3))
    assert(tonumber(ffi.cast('uint32_t', signatures.call_stub)) ~= 0, 'Failed to find pattern \"call_stub\"')
end

local function init_natives()
    natives.send_net_msg = ffi.cast('send_net_msg_t', signatures.send_net_msg)
    natives.get_mod_address = ffi.cast('void***', ffi.cast('char*', signatures.get_mod_address) + 5)[0][0]
    natives.get_proc_address = ffi.cast('void***', ffi.cast('char*', signatures.get_proc_address) + 3)[0][0]

    natives.virtual_alloc = function(address, size, memtype, protect)
        return ffi.cast('virtual_alloc_t', signatures.call_stub)(procedures.virtual_alloc, address, size, memtype, protect)
    end
    natives.virtual_protect = function(address, size, new_prot, old_prot)
        return ffi.cast('virtual_protect_t', signatures.call_stub)(procedures.virtual_protect, address, size, new_prot, old_prot)
    end

    natives.write_virtual = function(dest, bytes)
        local old_prot = ffi.new('uint32_t[1]')
        natives.virtual_protect(ffi.cast('uintptr_t', dest), #bytes, constants.PAGE_EXECUTE_READWRITE, old_prot)
        ffi.copy(ffi.cast('void*', dest), ffi.new('char[?]', #bytes, bytes), #bytes)
        natives.virtual_protect(ffi.cast('uintptr_t', dest), #bytes, old_prot[0], old_prot)
    end
    natives.write_raw = function(dest, rawbuf, len)
        local old_prot = ffi.new('uint32_t[1]')
        natives.virtual_protect(ffi.cast('uintptr_t', dest), len, constants.PAGE_EXECUTE_READWRITE, old_prot)
        ffi.copy(ffi.cast('void*', dest), rawbuf, len)
        natives.virtual_protect(ffi.cast('uintptr_t', dest), len, old_prot[0], old_prot)
    end
    natives.read_virtual = function(dest, buf, len)
        ffi.copy(ffi.cast('void*', buf), ffi.cast('const void*', dest), len)
    end
end

local function init_modules()
    modules.kernel32 = ffi.cast('get_mod_address_t', signatures.call_stub)(natives.get_mod_address, 'kernel32.dll')
    assert(tonumber(ffi.cast('uint32_t', modules.kernel32)) ~= 0, 'Failed to find module \"kernel32.dll\"')

    modules.ucrtbase = ffi.cast('get_mod_address_t', signatures.call_stub)(natives.get_mod_address, 'ucrtbase.dll')
    assert(tonumber(ffi.cast('uint32_t', modules.ucrtbase)) ~= 0, 'Failed to find module \"ucrtbase.dll\"')
end

local function init_procedures()
    procedures.virtual_alloc = ffi.cast('get_proc_address_t', signatures.call_stub)(natives.get_proc_address, modules.kernel32, 'VirtualAlloc')
    procedures.virtual_protect = ffi.cast('get_proc_address_t', signatures.call_stub)(natives.get_proc_address, modules.kernel32, 'VirtualProtect')
end

local function init_constants()
    constants.MEM_COMMIT = 0x1000
    constants.MEM_RESERVE = 0x2000
    constants.PAGE_EXECUTE = 0x10
    constants.PAGE_EXECUTE_READ = 0x20
    constants.PAGE_EXECUTE_READWRITE = 0x40
    constants.PAGE_EXECUTE_WRITECOPY = 0x80
    constants.PAGE_NOACCESS = 0x1
    constants.PAGE_READONLY = 0x2
    constants.PAGE_READWRITE = 0x4
    constants.PAGE_WRITECOPY = 0x8
end

local function init_menu()
    menu.enable = ui.new_checkbox('misc', 'settings', '\aFF89D0FFProteus')
    menu.cheat = ui.new_combobox('misc', 'settings', 'Cheat', {
        'anonymous',
        '\aC1C1C1FFgame\a9FCA2BFFsense',
        '\aEC4B82FFfatality',
        '\a7D68BDFFairflow',
        '\aFFFFFFFFnixware',
        '\a0095B9FFneverlose',
        '\aC09DFCFFpandora',
        '\aF7A414FFonetap',
        '\a00F300FFrifk\aFF00FFFF7',
        '\a6BFF87FFplague',
        '\a3ABBFFFFev0lve'
    })
end

local function init()
    init_signatures()
    init_natives()
    init_modules()
    init_procedures()
    init_constants()
    init_menu()

    local shared_esp = ui.reference('visuals', 'other esp', 'shared esp')
    ui.set(shared_esp, false)
    ui.set_visible(shared_esp, false)
end

init()

client.set_event_callback('net_update_start', function()
    if not ui.get(menu.enable) then
        return
    end

    if timer > globals.curtime() then
        return
    end

    local shared_esp = ui.reference('visuals', 'other esp', 'shared esp')

    local cheat = ui.get(menu.cheat)
    if cheat == 'anonymous' then
        ui.set(shared_esp, false)
        revealer.set_cheat(entity.get_local_player(), 'wh')
        return
    elseif cheat == '\aC1C1C1FFgame\a9FCA2BFFsense' then
        ui.set(shared_esp, true)
        revealer.set_cheat(entity.get_local_player(), 'gs')
        return
    elseif cheat == '\aEC4B82FFfatality' then
        ui.set(shared_esp, false)
        proteus.send_fatality_voice_data()
        revealer.set_cheat(entity.get_local_player(), 'ft')
    elseif cheat == '\a7D68BDFFairflow' then
        ui.set(shared_esp, false)
        proteus.send_airflow_voice_data()
        revealer.set_cheat(entity.get_local_player(), 'af')
    elseif cheat == '\aFFFFFFFFnixware' then
        ui.set(shared_esp, false)
        proteus.send_nixware_voice_data()
        revealer.set_cheat(entity.get_local_player(), 'nw')
    elseif cheat == '\aF7A414FFonetap' then
        ui.set(shared_esp, false)
        proteus.send_onetap_voice_data()
        revealer.set_cheat(entity.get_local_player(), 'ot')
    elseif cheat == '\aC09DFCFFpandora' then
        ui.set(shared_esp, false)
        proteus.send_pandora_voice_data()
        revealer.set_cheat(entity.get_local_player(), 'pd')
    elseif cheat == '\a00F300FFrifk\aFF00FFFF7' then
        ui.set(shared_esp, false)
        proteus.send_rifk7_voice_data()
        revealer.set_cheat(entity.get_local_player(), 'r7')
    elseif cheat == '\a6BFF87FFplague' then
        ui.set(shared_esp, false)
        proteus.send_plague_voice_data()
        revealer.set_cheat(entity.get_local_player(), 'pl')
    elseif cheat == '\a3ABBFFFFev0lve' then
        ui.set(shared_esp, false)
        proteus.send_ev0lve_voice_data()
        revealer.set_cheat(entity.get_local_player(), 'ev')
    elseif cheat == '\a0095B9FFneverlose' then
        ui.set(shared_esp, false)
        proteus.send_neverlose_voice_data()
        revealer.set_cheat(entity.get_local_player(), 'nl2')
    end

    ev0lve_counter = ev0lve_counter + 1
    if ev0lve_counter >= 5 then ev0lve_counter = 0 end

    timer = globals.curtime() + 0.5
end)

client.set_event_callback('game_newmap', function()
    timer = 0
    ev0lve_counter = 0
end)

client.set_event_callback('game_start', function()
    timer = 0
    ev0lve_counter = 0
end)

client.set_event_callback('round_start', function()
    timer = 0
    ev0lve_counter = 0
end)

client.set_event_callback('shutdown', function()
    local shared_esp = ui.reference('visuals', 'other esp', 'shared esp')
    ui.set_visible(shared_esp, true)
end)