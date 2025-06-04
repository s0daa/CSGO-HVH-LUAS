local m_vSmokeColor = engine.get_netvar_offset("client.dll", "C_SmokeGrenadeProjectile", "m_vSmokeColor")
register_callback("paint", function() -- colored smoke
    entitylist.get_entities("C_SmokeGrenadeProjectile", function(smoke)
        local address = smoke[m_vSmokeColor]
        ffi.cast("float*", address)[0] = 255
        ffi.cast("float*", address)[1] = 0
        ffi.cast("float*", address)[2] = 0
    end)
end)