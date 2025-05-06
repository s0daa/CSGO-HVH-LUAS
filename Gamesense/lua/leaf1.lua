--[[
Self leak
Discord: wyscigufa9, 0lexesh
--]]

local ffi = require("ffi")
local http = require('gamesense/http')
local pui = require("gamesense/pui")
local base64 = require("gamesense/base64")
local vector = require("vector")
local ent_lib = require("gamesense/entity")
local images = require("gamesense/images")
X,Y = client.screen_size()

local lua_name = "LEAF"
local cfg_data = {}

--loader data \
local username = "Admin"

local login = {
    username = username,
    build = "debug"
}
--loader data /

local notify_data = {}

cfg_data.database = {
    configs = ":leaf_cfg:"
}

cfg_data.presets = {
    {name = "preset", config = "W3siZW5hYmxlIjp0cnVlLCJjb25kaXRpb24iOiJydW4iLCJ0ZWFtX3NlbCI6InQiLCJhYV9tb2RlcyI6Im90aGVyIn0seyJ0Ijp7ImR1Y2stbW92ZSI6eyJlbmFibGUiOnRydWUsInBpdGNoIjoib2ZmIiwiYm9keV95YXciOiJvZmYiLCJ5YXdfc2xpZGVyX3IiOjAsInlhd19qaXR0ZXIiOiJvZmYiLCJ5YXdfaml0dGVyX3NsaWRlcl9zdGF0aWMiOjIsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsInlhd19tb2RlIjoiZGVsYXkiLCJ5YXdfYmFzZSI6ImxvY2FsIHZpZXciLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJ5YXdfc2xpZGVyX3N0YXRpYyI6MiwieWF3X2ppdHRlcl9tb2RlIjoic3RhdGljIiwieWF3X3NsaWRlcl9kZWxheSI6MCwieWF3Ijoib2ZmIiwieWF3X3NsaWRlcl9sIjowLCJib2R5X3lhd19zbGlkZXIiOjIsInlhd19qaXR0ZXJfc2xpZGVyX2RlbGF5IjowLCJjdXN0b21fcGl0Y2giOjB9LCJmYWtlbGFnIjp7ImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJvZmYiLCJib2R5X3lhdyI6Im9mZiIsInlhd19zbGlkZXJfciI6MCwieWF3X2ppdHRlciI6Im9mZiIsInlhd19qaXR0ZXJfc2xpZGVyX3N0YXRpYyI6MiwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwieWF3X21vZGUiOiJkZWxheSIsInlhd19iYXNlIjoibG9jYWwgdmlldyIsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsInlhd19zbGlkZXJfc3RhdGljIjoyLCJ5YXdfaml0dGVyX21vZGUiOiJzdGF0aWMiLCJ5YXdfc2xpZGVyX2RlbGF5IjowLCJ5YXciOiJvZmYiLCJ5YXdfc2xpZGVyX2wiOjAsImJvZHlfeWF3X3NsaWRlciI6MiwieWF3X2ppdHRlcl9zbGlkZXJfZGVsYXkiOjAsImN1c3RvbV9waXRjaCI6MH0sInJ1biI6eyJlbmFibGUiOnRydWUsInBpdGNoIjoib2ZmIiwiYm9keV95YXciOiJvZmYiLCJ5YXdfc2xpZGVyX3IiOjAsInlhd19qaXR0ZXIiOiJvZmYiLCJ5YXdfaml0dGVyX3NsaWRlcl9zdGF0aWMiOjIsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsInlhd19tb2RlIjoiZGVsYXkiLCJ5YXdfYmFzZSI6ImxvY2FsIHZpZXciLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJ5YXdfc2xpZGVyX3N0YXRpYyI6MiwieWF3X2ppdHRlcl9tb2RlIjoic3RhdGljIiwieWF3X3NsaWRlcl9kZWxheSI6MCwieWF3Ijoib2ZmIiwieWF3X3NsaWRlcl9sIjowLCJib2R5X3lhd19zbGlkZXIiOjIsInlhd19qaXR0ZXJfc2xpZGVyX2RlbGF5IjowLCJjdXN0b21fcGl0Y2giOjB9LCJnbG9iYWwiOnsiZW5hYmxlIjpmYWxzZSwicGl0Y2giOiJvZmYiLCJib2R5X3lhdyI6Im9mZiIsInlhd19zbGlkZXJfciI6MCwieWF3X2ppdHRlciI6Im9mZiIsInlhd19qaXR0ZXJfc2xpZGVyX3N0YXRpYyI6MiwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwieWF3X21vZGUiOiJkZWxheSIsInlhd19iYXNlIjoibG9jYWwgdmlldyIsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsInlhd19zbGlkZXJfc3RhdGljIjoyLCJ5YXdfaml0dGVyX21vZGUiOiJzdGF0aWMiLCJ5YXdfc2xpZGVyX2RlbGF5IjowLCJ5YXciOiJvZmYiLCJ5YXdfc2xpZGVyX2wiOjAsImJvZHlfeWF3X3NsaWRlciI6MiwieWF3X2ppdHRlcl9zbGlkZXJfZGVsYXkiOjAsImN1c3RvbV9waXRjaCI6MH0sImp1bXAiOnsiZW5hYmxlIjp0cnVlLCJwaXRjaCI6Im9mZiIsImJvZHlfeWF3Ijoib2ZmIiwieWF3X3NsaWRlcl9yIjowLCJ5YXdfaml0dGVyIjoib2ZmIiwieWF3X2ppdHRlcl9zbGlkZXJfc3RhdGljIjoyLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjowLCJ5YXdfbW9kZSI6ImRlbGF5IiwieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwieWF3X2ppdHRlcl9zbGlkZXJfbCI6MCwieWF3X3NsaWRlcl9zdGF0aWMiOjIsInlhd19qaXR0ZXJfbW9kZSI6InN0YXRpYyIsInlhd19zbGlkZXJfZGVsYXkiOjAsInlhdyI6Im9mZiIsInlhd19zbGlkZXJfbCI6MCwiYm9keV95YXdfc2xpZGVyIjoyLCJ5YXdfaml0dGVyX3NsaWRlcl9kZWxheSI6MCwiY3VzdG9tX3BpdGNoIjowfSwiZHVjayI6eyJlbmFibGUiOnRydWUsInBpdGNoIjoib2ZmIiwiYm9keV95YXciOiJvZmYiLCJ5YXdfc2xpZGVyX3IiOjAsInlhd19qaXR0ZXIiOiJvZmYiLCJ5YXdfaml0dGVyX3NsaWRlcl9zdGF0aWMiOjIsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsInlhd19tb2RlIjoiZGVsYXkiLCJ5YXdfYmFzZSI6ImxvY2FsIHZpZXciLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJ5YXdfc2xpZGVyX3N0YXRpYyI6MiwieWF3X2ppdHRlcl9tb2RlIjoic3RhdGljIiwieWF3X3NsaWRlcl9kZWxheSI6MCwieWF3Ijoib2ZmIiwieWF3X3NsaWRlcl9sIjowLCJib2R5X3lhd19zbGlkZXIiOjIsInlhd19qaXR0ZXJfc2xpZGVyX2RlbGF5IjowLCJjdXN0b21fcGl0Y2giOjB9LCJzbG93LXdhbGsiOnsiZW5hYmxlIjp0cnVlLCJwaXRjaCI6Im9mZiIsImJvZHlfeWF3Ijoib2ZmIiwieWF3X3NsaWRlcl9yIjowLCJ5YXdfaml0dGVyIjoib2ZmIiwieWF3X2ppdHRlcl9zbGlkZXJfc3RhdGljIjoyLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjowLCJ5YXdfbW9kZSI6ImRlbGF5IiwieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwieWF3X2ppdHRlcl9zbGlkZXJfbCI6MCwieWF3X3NsaWRlcl9zdGF0aWMiOjIsInlhd19qaXR0ZXJfbW9kZSI6InN0YXRpYyIsInlhd19zbGlkZXJfZGVsYXkiOjAsInlhdyI6Im9mZiIsInlhd19zbGlkZXJfbCI6MCwiYm9keV95YXdfc2xpZGVyIjoyLCJ5YXdfaml0dGVyX3NsaWRlcl9kZWxheSI6MCwiY3VzdG9tX3BpdGNoIjowfSwic3RhbmQiOnsiZW5hYmxlIjp0cnVlLCJwaXRjaCI6Im9mZiIsImJvZHlfeWF3Ijoib2ZmIiwieWF3X3NsaWRlcl9yIjowLCJ5YXdfaml0dGVyIjoib2ZmIiwieWF3X2ppdHRlcl9zbGlkZXJfc3RhdGljIjoyLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjowLCJ5YXdfbW9kZSI6ImRlbGF5IiwieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwieWF3X2ppdHRlcl9zbGlkZXJfbCI6MCwieWF3X3NsaWRlcl9zdGF0aWMiOjIsInlhd19qaXR0ZXJfbW9kZSI6InN0YXRpYyIsInlhd19zbGlkZXJfZGVsYXkiOjAsInlhdyI6Im9mZiIsInlhd19zbGlkZXJfbCI6MCwiYm9keV95YXdfc2xpZGVyIjoyLCJ5YXdfaml0dGVyX3NsaWRlcl9kZWxheSI6MCwiY3VzdG9tX3BpdGNoIjowfSwiZHVjay1qdW1wIjp7ImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJvZmYiLCJib2R5X3lhdyI6Im9mZiIsInlhd19zbGlkZXJfciI6MCwieWF3X2ppdHRlciI6Im9mZiIsInlhd19qaXR0ZXJfc2xpZGVyX3N0YXRpYyI6MiwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwieWF3X21vZGUiOiJkZWxheSIsInlhd19iYXNlIjoibG9jYWwgdmlldyIsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsInlhd19zbGlkZXJfc3RhdGljIjoyLCJ5YXdfaml0dGVyX21vZGUiOiJzdGF0aWMiLCJ5YXdfc2xpZGVyX2RlbGF5IjowLCJ5YXciOiJvZmYiLCJ5YXdfc2xpZGVyX2wiOjAsImJvZHlfeWF3X3NsaWRlciI6MiwieWF3X2ppdHRlcl9zbGlkZXJfZGVsYXkiOjAsImN1c3RvbV9waXRjaCI6MH19LCJjdCI6eyJkdWNrLW1vdmUiOnsiZW5hYmxlIjp0cnVlLCJwaXRjaCI6Im9mZiIsImJvZHlfeWF3Ijoib2ZmIiwieWF3X3NsaWRlcl9yIjowLCJ5YXdfaml0dGVyIjoib2ZmIiwieWF3X2ppdHRlcl9zbGlkZXJfc3RhdGljIjoyLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjowLCJ5YXdfbW9kZSI6ImRlbGF5IiwieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwieWF3X2ppdHRlcl9zbGlkZXJfbCI6MCwieWF3X3NsaWRlcl9zdGF0aWMiOjIsInlhd19qaXR0ZXJfbW9kZSI6InN0YXRpYyIsInlhd19zbGlkZXJfZGVsYXkiOjAsInlhdyI6Im9mZiIsInlhd19zbGlkZXJfbCI6MCwiYm9keV95YXdfc2xpZGVyIjoyLCJ5YXdfaml0dGVyX3NsaWRlcl9kZWxheSI6MCwiY3VzdG9tX3BpdGNoIjowfSwiZmFrZWxhZyI6eyJlbmFibGUiOnRydWUsInBpdGNoIjoib2ZmIiwiYm9keV95YXciOiJvZmYiLCJ5YXdfc2xpZGVyX3IiOjAsInlhd19qaXR0ZXIiOiJvZmYiLCJ5YXdfaml0dGVyX3NsaWRlcl9zdGF0aWMiOjIsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsInlhd19tb2RlIjoiZGVsYXkiLCJ5YXdfYmFzZSI6ImxvY2FsIHZpZXciLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJ5YXdfc2xpZGVyX3N0YXRpYyI6MiwieWF3X2ppdHRlcl9tb2RlIjoic3RhdGljIiwieWF3X3NsaWRlcl9kZWxheSI6MCwieWF3Ijoib2ZmIiwieWF3X3NsaWRlcl9sIjowLCJib2R5X3lhd19zbGlkZXIiOjIsInlhd19qaXR0ZXJfc2xpZGVyX2RlbGF5IjowLCJjdXN0b21fcGl0Y2giOjB9LCJydW4iOnsiZW5hYmxlIjp0cnVlLCJwaXRjaCI6Im9mZiIsImJvZHlfeWF3Ijoib2ZmIiwieWF3X3NsaWRlcl9yIjowLCJ5YXdfaml0dGVyIjoib2ZmIiwieWF3X2ppdHRlcl9zbGlkZXJfc3RhdGljIjoyLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjowLCJ5YXdfbW9kZSI6ImRlbGF5IiwieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwieWF3X2ppdHRlcl9zbGlkZXJfbCI6MCwieWF3X3NsaWRlcl9zdGF0aWMiOjIsInlhd19qaXR0ZXJfbW9kZSI6InN0YXRpYyIsInlhd19zbGlkZXJfZGVsYXkiOjAsInlhdyI6Im9mZiIsInlhd19zbGlkZXJfbCI6MCwiYm9keV95YXdfc2xpZGVyIjoyLCJ5YXdfaml0dGVyX3NsaWRlcl9kZWxheSI6MCwiY3VzdG9tX3BpdGNoIjowfSwiZ2xvYmFsIjp7ImVuYWJsZSI6ZmFsc2UsInBpdGNoIjoib2ZmIiwiYm9keV95YXciOiJvZmYiLCJ5YXdfc2xpZGVyX3IiOjAsInlhd19qaXR0ZXIiOiJvZmYiLCJ5YXdfaml0dGVyX3NsaWRlcl9zdGF0aWMiOjIsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsInlhd19tb2RlIjoiZGVsYXkiLCJ5YXdfYmFzZSI6ImxvY2FsIHZpZXciLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJ5YXdfc2xpZGVyX3N0YXRpYyI6MiwieWF3X2ppdHRlcl9tb2RlIjoic3RhdGljIiwieWF3X3NsaWRlcl9kZWxheSI6MCwieWF3Ijoib2ZmIiwieWF3X3NsaWRlcl9sIjowLCJib2R5X3lhd19zbGlkZXIiOjIsInlhd19qaXR0ZXJfc2xpZGVyX2RlbGF5IjowLCJjdXN0b21fcGl0Y2giOjB9LCJqdW1wIjp7ImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJvZmYiLCJib2R5X3lhdyI6Im9mZiIsInlhd19zbGlkZXJfciI6MCwieWF3X2ppdHRlciI6Im9mZiIsInlhd19qaXR0ZXJfc2xpZGVyX3N0YXRpYyI6MiwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwieWF3X21vZGUiOiJkZWxheSIsInlhd19iYXNlIjoibG9jYWwgdmlldyIsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsInlhd19zbGlkZXJfc3RhdGljIjoyLCJ5YXdfaml0dGVyX21vZGUiOiJzdGF0aWMiLCJ5YXdfc2xpZGVyX2RlbGF5IjowLCJ5YXciOiJvZmYiLCJ5YXdfc2xpZGVyX2wiOjAsImJvZHlfeWF3X3NsaWRlciI6MiwieWF3X2ppdHRlcl9zbGlkZXJfZGVsYXkiOjAsImN1c3RvbV9waXRjaCI6MH0sImR1Y2siOnsiZW5hYmxlIjp0cnVlLCJwaXRjaCI6Im9mZiIsImJvZHlfeWF3Ijoib2ZmIiwieWF3X3NsaWRlcl9yIjowLCJ5YXdfaml0dGVyIjoib2ZmIiwieWF3X2ppdHRlcl9zbGlkZXJfc3RhdGljIjoyLCJ5YXdfaml0dGVyX3NsaWRlcl9yIjowLCJ5YXdfbW9kZSI6ImRlbGF5IiwieWF3X2Jhc2UiOiJsb2NhbCB2aWV3IiwieWF3X2ppdHRlcl9zbGlkZXJfbCI6MCwieWF3X3NsaWRlcl9zdGF0aWMiOjIsInlhd19qaXR0ZXJfbW9kZSI6InN0YXRpYyIsInlhd19zbGlkZXJfZGVsYXkiOjAsInlhdyI6Im9mZiIsInlhd19zbGlkZXJfbCI6MCwiYm9keV95YXdfc2xpZGVyIjoyLCJ5YXdfaml0dGVyX3NsaWRlcl9kZWxheSI6MCwiY3VzdG9tX3BpdGNoIjowfSwic2xvdy13YWxrIjp7ImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJvZmYiLCJib2R5X3lhdyI6Im9mZiIsInlhd19zbGlkZXJfciI6MCwieWF3X2ppdHRlciI6Im9mZiIsInlhd19qaXR0ZXJfc2xpZGVyX3N0YXRpYyI6MiwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwieWF3X21vZGUiOiJkZWxheSIsInlhd19iYXNlIjoibG9jYWwgdmlldyIsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsInlhd19zbGlkZXJfc3RhdGljIjoyLCJ5YXdfaml0dGVyX21vZGUiOiJzdGF0aWMiLCJ5YXdfc2xpZGVyX2RlbGF5IjowLCJ5YXciOiJvZmYiLCJ5YXdfc2xpZGVyX2wiOjAsImJvZHlfeWF3X3NsaWRlciI6MiwieWF3X2ppdHRlcl9zbGlkZXJfZGVsYXkiOjAsImN1c3RvbV9waXRjaCI6MH0sInN0YW5kIjp7ImVuYWJsZSI6dHJ1ZSwicGl0Y2giOiJvZmYiLCJib2R5X3lhdyI6Im9mZiIsInlhd19zbGlkZXJfciI6MCwieWF3X2ppdHRlciI6Im9mZiIsInlhd19qaXR0ZXJfc2xpZGVyX3N0YXRpYyI6MiwieWF3X2ppdHRlcl9zbGlkZXJfciI6MCwieWF3X21vZGUiOiJkZWxheSIsInlhd19iYXNlIjoibG9jYWwgdmlldyIsInlhd19qaXR0ZXJfc2xpZGVyX2wiOjAsInlhd19zbGlkZXJfc3RhdGljIjoyLCJ5YXdfaml0dGVyX21vZGUiOiJzdGF0aWMiLCJ5YXdfc2xpZGVyX2RlbGF5IjowLCJ5YXciOiJvZmYiLCJ5YXdfc2xpZGVyX2wiOjAsImJvZHlfeWF3X3NsaWRlciI6MiwieWF3X2ppdHRlcl9zbGlkZXJfZGVsYXkiOjAsImN1c3RvbV9waXRjaCI6MH0sImR1Y2stanVtcCI6eyJlbmFibGUiOnRydWUsInBpdGNoIjoib2ZmIiwiYm9keV95YXciOiJvZmYiLCJ5YXdfc2xpZGVyX3IiOjAsInlhd19qaXR0ZXIiOiJvZmYiLCJ5YXdfaml0dGVyX3NsaWRlcl9zdGF0aWMiOjIsInlhd19qaXR0ZXJfc2xpZGVyX3IiOjAsInlhd19tb2RlIjoiZGVsYXkiLCJ5YXdfYmFzZSI6ImxvY2FsIHZpZXciLCJ5YXdfaml0dGVyX3NsaWRlcl9sIjowLCJ5YXdfc2xpZGVyX3N0YXRpYyI6MiwieWF3X2ppdHRlcl9tb2RlIjoic3RhdGljIiwieWF3X3NsaWRlcl9kZWxheSI6MCwieWF3Ijoib2ZmIiwieWF3X3NsaWRlcl9sIjowLCJib2R5X3lhd19zbGlkZXIiOjIsInlhd19qaXR0ZXJfc2xpZGVyX2RlbGF5IjowLCJjdXN0b21fcGl0Y2giOjB9fX0seyJkdWNrLW1vdmUiOnsiZW5hYmxlIjp0cnVlLCJ5YXdfaml0dGVyX3NsaWRlciI6MiwicGl0Y2giOiJvZmYiLCJ5YXdfc2xpZGVyIjoyLCJ5YXdfaml0dGVyIjoib2ZmIiwibW9kZSI6ImFsd2F5cyBvbiIsInlhdyI6Im9mZiIsImN1c3RvbV9waXRjaCI6MH0sInJ1biI6eyJlbmFibGUiOmZhbHNlLCJ5YXdfaml0dGVyX3NsaWRlciI6MiwicGl0Y2giOiJvZmYiLCJ5YXdfc2xpZGVyIjoyLCJ5YXdfaml0dGVyIjoib2ZmIiwibW9kZSI6ImFsd2F5cyBvbiIsInlhdyI6Im9mZiIsImN1c3RvbV9waXRjaCI6MH0sImp1bXAiOnsiZW5hYmxlIjp0cnVlLCJ5YXdfaml0dGVyX3NsaWRlciI6MiwicGl0Y2giOiJvZmYiLCJ5YXdfc2xpZGVyIjoyLCJ5YXdfaml0dGVyIjoib2ZmIiwibW9kZSI6ImFsd2F5cyBvbiIsInlhdyI6Im9mZiIsImN1c3RvbV9waXRjaCI6MH0sInN0YW5kIjp7ImVuYWJsZSI6ZmFsc2UsInlhd19qaXR0ZXJfc2xpZGVyIjoyLCJwaXRjaCI6Im9mZiIsInlhd19zbGlkZXIiOjIsInlhd19qaXR0ZXIiOiJvZmYiLCJtb2RlIjoiYWx3YXlzIG9uIiwieWF3Ijoib2ZmIiwiY3VzdG9tX3BpdGNoIjowfSwic2xvdy13YWxrIjp7ImVuYWJsZSI6ZmFsc2UsInlhd19qaXR0ZXJfc2xpZGVyIjoyLCJwaXRjaCI6Im9mZiIsInlhd19zbGlkZXIiOjIsInlhd19qaXR0ZXIiOiJvZmYiLCJtb2RlIjoiYWx3YXlzIG9uIiwieWF3Ijoib2ZmIiwiY3VzdG9tX3BpdGNoIjowfSwiZnJlZXN0YW5kaW5nIjp7ImVuYWJsZSI6ZmFsc2UsInlhd19qaXR0ZXJfc2xpZGVyIjoyLCJwaXRjaCI6Im9mZiIsInlhd19zbGlkZXIiOjIsInlhd19qaXR0ZXIiOiJvZmYiLCJtb2RlIjoiYWx3YXlzIG9uIiwieWF3Ijoib2ZmIiwiY3VzdG9tX3BpdGNoIjowfSwid2VhcG9uLXN3aXRjaCI6eyJlbmFibGUiOnRydWUsInlhd19qaXR0ZXJfc2xpZGVyIjoyLCJwaXRjaCI6Im9mZiIsInlhd19zbGlkZXIiOjIsInlhd19qaXR0ZXIiOiJvZmYiLCJtb2RlIjoiYWx3YXlzIG9uIiwieWF3Ijoib2ZmIiwiY3VzdG9tX3BpdGNoIjowfSwiZHVjayI6eyJlbmFibGUiOnRydWUsInlhd19qaXR0ZXJfc2xpZGVyIjoyLCJwaXRjaCI6Im9mZiIsInlhd19zbGlkZXIiOjIsInlhd19qaXR0ZXIiOiJvZmYiLCJtb2RlIjoiYWx3YXlzIG9uIiwieWF3Ijoib2ZmIiwiY3VzdG9tX3BpdGNoIjowfSwiZHVjay1qdW1wIjp7ImVuYWJsZSI6dHJ1ZSwieWF3X2ppdHRlcl9zbGlkZXIiOjIsInBpdGNoIjoib2ZmIiwieWF3X3NsaWRlciI6MiwieWF3X2ppdHRlciI6Im9mZiIsIm1vZGUiOiJhbHdheXMgb24iLCJ5YXciOiJvZmYiLCJjdXN0b21fcGl0Y2giOjB9fSx7InNhZmVfaGVhZCI6dHJ1ZSwiZnJlZXN0YW5kaW5nIjpbMSwxOCwifiJdLCJlZGdleWF3IjpbMSwwLCJ+Il0sImFudGlfYmFja3N0YWIiOnRydWUsImZyZWVzdGFuZGluZ19kaXNhYmxlcnMiOlsiZHVjayIsImR1Y2stbW92ZSIsImp1bXAiLCJkdWNrLWp1bXAiLCJzbG93LXdhbGsiLCJ+Il19XQ=="}
}

contains = function(tbl, arg)
    for index, value in next, tbl do 
        if value == arg then 
            return true end 
        end 
    return false
end

local x, o = '\x14\x14\x14\xFF', '\x0c\x0c\x0c\xFF'

local pattern = table.concat{
    x,x,o,x,
    o,x,o,x,
    o,x,x,x,
    o,x,o,x
}

local tex_id = renderer.load_rgba(pattern, 4, 4)

function render_ogskeet_border(x,y,w,h,a,text)
    renderer.rectangle(x - 10, y - 48 ,w + 20, h + 16,12,12,12,a)
    renderer.rectangle(x - 9, y - 47 ,w + 18, h + 14,60,60,60,a)
    renderer.rectangle(x - 8, y - 46 ,w + 16, h + 12,40,40,40,a)
    renderer.rectangle(x - 5, y - 43 ,w + 10, h + 6,60,60,60,a)
    renderer.rectangle(x - 4, y - 42 ,w + 8, h + 4,12,12,12,a)
    renderer.texture(tex_id, x - 4, y - 42, w + 8, h + 4, 255, 255, 255, a, "r")
    renderer.gradient(x - 4,y - 42, w /2, 1, 59, 175, 222, a, 202, 70, 205, a,true)               
    renderer.gradient(x - 4 + w / 2 ,y - 42, w /2 + 8.5, 1,202, 70, 205, a,204, 227, 53, a,true)
    renderer.text(x, y - 40, 255,255,255,a, "", nil, text)
end

ffi.cdef [[
	typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

local VGUI_System010 =  client.create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010 )
local get_clipboard_text_count = ffi.cast("get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
local set_clipboard_text = ffi.cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
local get_clipboard_text = ffi.cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")

clipboard_import = function()
    local clipboard_text_length = get_clipboard_text_count(VGUI_System)
   
    if clipboard_text_length > 0 then
        local buffer = ffi.new("char[?]", clipboard_text_length)
        local size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)
   
        get_clipboard_text(VGUI_System, 0, buffer, size )
   
        return ffi.string( buffer, clipboard_text_length-1)
    end

    return ""
end

local function clipboard_export(string)
	if string then
		set_clipboard_text(VGUI_System, string, string:len())
	end
end

references = {
    minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    minimum_damage_override = {ui.reference("RAGE", "Aimbot", "Minimum damage override")},
    double_tap = {ui.reference('RAGE', 'Aimbot', 'Double tap')},
    ps = { ui.reference("MISC", "Miscellaneous", "Ping spike") },
    duck_peek_assist = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
	pitch = {ui.reference('AA', 'Anti-aimbot angles', 'Pitch')},
    yaw_base = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw')},
    yaw_jitter = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')},
    body_yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
    freestanding_body_yaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
	edge_yaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
	freestanding = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
    roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
    slow_motion = {ui.reference('AA', 'Other', 'Slow motion')},
    leg_movement = ui.reference('AA', 'Other', 'Leg movement'),
    on_shot_anti_aim = {ui.reference('AA', 'Other', 'On shot anti-aim')}
}

local ref = {
    aa_enable = ui.reference("AA","anti-aimbot angles","enabled"),
    pitch = ui.reference("AA","anti-aimbot angles","pitch"),
    pitch_value = select(2, ui.reference("AA","anti-aimbot angles","pitch")),
    yaw_base = ui.reference("AA","anti-aimbot angles","yaw base"),
    yaw = ui.reference("AA","anti-aimbot angles","yaw"),
    yaw_value = select(2, ui.reference("AA","anti-aimbot angles","yaw")),
    yaw_jitter = ui.reference("AA","Anti-aimbot angles","Yaw Jitter"),
    yaw_jitter_value = select(2, ui.reference("AA","Anti-aimbot angles","Yaw Jitter")),
    body_yaw = ui.reference("AA","Anti-aimbot angles","Body yaw"),
    body_yaw_value = select(2, ui.reference("AA","Anti-aimbot angles","Body yaw")),
    freestand_body_yaw = ui.reference("AA","Anti-aimbot angles","freestanding body yaw"),
    edgeyaw = ui.reference("AA","anti-aimbot angles","edge yaw"),
    freestand = {ui.reference("AA","anti-aimbot angles","freestanding")},
    roll = ui.reference("AA","anti-aimbot angles","roll"),
    slide = {ui.reference("AA","other","slow motion")},
    fakeduck = ui.reference("rage","other","duck peek assist"),
    quick_peek = {ui.reference("rage", "other", "quick peek assist")},
    doubletap = {ui.reference("rage", "aimbot", "double tap")},
}

local function lerp(a, b, t)
    return a + (b - a) * t
end

function rgba_to_hex(b,c,d,e)
    return string.format('%02x%02x%02x%02x',b,c,d,e)
end

function gradient_text(text, speed, r,g,b,a)
    local final_text = ''
    local curtime = globals.curtime()
    local center = math.floor(#text / 2) + 1  -- calculate the center of the text
    for i=1, #text do
        -- calculate the distance from the center character
        local distance = math.abs(i - center)
        -- calculate the alpha based on the distance and the speed and time
        a = 255 - math.abs(255 * math.sin(speed * curtime / 4 - distance * 4 / 20))
        local col = rgba_to_hex(r,g,b,a)
        final_text = final_text .. '\a' .. col .. text:sub(i, i)
    end
    return final_text
end

local logo
local function downloadFileLogo()
	http.get("https://media.discordapp.net/attachments/1176509765879353424/1176519538574114846/pngwing.com1.png?ex=656f2a34&is=655cb534&hm=c1b96790aa2058d473a56746466ee8fcbcb5df956df5141317932968b706317e&=", function(success, response)
		if not success or response.status ~= 200 then
            return
		end

		logo = images.load(response.body)
	end)
end
downloadFileLogo()

pui.accent = "C3C6FFFF"

local states = {"global", "stand", "run", "duck", "duck-move", "jump", "duck-jump", "slow-walk", "fakelag"}
local states_defensive = {"stand", "run", "duck", "duck-move", "jump", "duck-jump", "slow-walk", "weapon-switch", "freestanding"}
local teams = {"t", "ct"}

local group = pui.group("aa","anti-aimbot angles")

local _ui = {
    lua = {
        tab = group:combobox("\n ", "Anti-aim", "Visuals", "Miscellaneous", "Config"),    
    },

    antiaim = {
        enable = group:checkbox("enable - \v"..login.username),
        aa_modes = group:combobox("\n ", {"builder", "defensive", "other"}),
        condition = group:combobox("\n ", states),
        team_sel = group:combobox("\n ", teams),
    },

    defensive_builder = {
        condition = group:combobox("\n ", states_defensive)
    },

    keybinds = {
        freestanding = group:hotkey("Freestanding"),
        freestanding_disablers = group:multiselect("Freestanding disablers", states),
        edgeyaw = group:hotkey("Edge-Yaw"),
        safe_head = group:checkbox("safe-head"),
        anti_backstab = group:checkbox("anti-backstab")
    },

    visuals = {
        watermark = group:combobox("watermark", {"default", "modern", "og"}),
        watermark_color = ui.new_color_picker("aa","anti-aimbot angles", 195, 198, 255, 255),
        watermark_opt = group:multiselect("\n ", {"fps", "ping", "time", "build"}),
        watermark_pos = group:combobox("\n ", {"left", "right", "bottom"}),
        remove_spaces = group:checkbox("remove spaces"),
        inds = group:combobox("indicators", {"off", "default"}),
        inds_color = ui.new_color_picker("aa","anti-aimbot angles", 195, 198, 255, 255),
        notify_style = group:combobox("notify style", {"default", "modern", "og"}),
        hitlogs = group:multiselect("hitlogs", {"hit", "miss"}),
        hitlogs_color = ui.new_color_picker("aa","anti-aimbot angles", 195, 198, 255, 255),
        other_ind = group:multiselect("other", {"defensive", "slowed-down"}),
        other_color = ui.new_color_picker("aa", "anti-aimbot angles", 195,198,255,255),
    },

    misc = {
        clantag = group:checkbox("clantag"),
        anims = group:checkbox("animation breakers"),
        anims_opt = group:multiselect("\n ", {"Static legs", "Reset pitch on land", "Leg fucker", "Micheal Jackson"})
    },

    antiaim_table = {
        delayek = false,
        paketa_pitch = 0
    },
}

aa_builder = {}
for _, team in ipairs(teams) do
    aa_builder[team] = {}
    for _, state in ipairs(states) do
        aa_builder[team][state] = {}
        local menu = aa_builder[team][state]

        menu.enable = group:checkbox("enable \v" .. state .. "\n" .. team)
        menu.pitch = group:combobox("pitch", {"off", "default", "minimal", "up", "custom"})
        menu.custom_pitch = group:slider("custom pitch", -89, 89, 0, true, "°", 1)
        menu.yaw_base = group:combobox("yaw base", {"local view", "at targets"})
        menu.yaw = group:combobox("yaw", {"off", "180", "spin", "static", "180 Z", "crosshair"})
        menu.yaw_mode = group:combobox("\n ", {"static", "l & r", "delay"})
        menu.yaw_slider_static = group:slider("\n ", -180, 180, 0, true, "°", 1)
        menu.yaw_slider_l = group:slider("left", -180, 180, 0, true, "°", 1)
        menu.yaw_slider_r = group:slider("right", -180, 180, 0, true, "°", 1)
        menu.yaw_slider_delay = group:slider("delay", 0, 15, 0, true, "%", 1)
        menu.yaw_jitter = group:combobox("yaw jitter", {"off", "offset", "center", "random", "skitter"})
        menu.yaw_jitter_mode = group:combobox("\n ", {"static", "l & r"})
        menu.yaw_jitter_slider_static = group:slider("\n ", -180, 180, 0, true, "°", 1)
        menu.yaw_jitter_slider_l = group:slider("left", -180, 180, 0, true, "°", 1)
        menu.yaw_jitter_slider_r = group:slider("right", -180, 180, 0, true, "°", 1)
        menu.yaw_jitter_slider_delay = group:slider("delay", 0, 15, 0, true, "%", 1)
        menu.body_yaw = group:combobox("body yaw", {"off", "opposite", "jitter", "static"})
        menu.body_yaw_slider = group:slider("\n ", -180, 180, 0, true, "°", 1)
        local test_team = team == "ct" and "t" or "ct"
        menu.export_opposite_team = group:button("export to ["..test_team.." - "..state.."]", function()
            export_state(state, team, test_team)
        end)
    end
end

for i, tt in ipairs(teams) do
    for k, ss in ipairs(states) do 
        aa_builder[tt][ss].enable:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {_ui.lua.tab, "Anti-aim"})
        aa_builder[tt][ss].pitch:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"})
        aa_builder[tt][ss].custom_pitch:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {aa_builder[tt][ss].pitch, "custom"}, {_ui.lua.tab, "Anti-aim"})
        aa_builder[tt][ss].yaw_base:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"})
        aa_builder[tt][ss].yaw:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"})
        aa_builder[tt][ss].yaw_mode:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"}, {aa_builder[tt][ss].yaw, function() return aa_builder[tt][ss].yaw.value ~= "off" end})
        aa_builder[tt][ss].yaw_slider_static:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"}, {aa_builder[tt][ss].yaw, function() return aa_builder[tt][ss].yaw.value ~= "off" end}, {aa_builder[tt][ss].yaw_mode, "static"})
        aa_builder[tt][ss].yaw_slider_l:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"}, {aa_builder[tt][ss].yaw, function() return aa_builder[tt][ss].yaw.value ~= "off" end}, {aa_builder[tt][ss].yaw_mode, function() return aa_builder[tt][ss].yaw_mode.value ~= "static" end})
        aa_builder[tt][ss].yaw_slider_r:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"}, {aa_builder[tt][ss].yaw, function() return aa_builder[tt][ss].yaw.value ~= "off" end}, {aa_builder[tt][ss].yaw_mode, function() return aa_builder[tt][ss].yaw_mode.value ~= "static" end})
        aa_builder[tt][ss].yaw_slider_delay:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"}, {aa_builder[tt][ss].yaw, function() return aa_builder[tt][ss].yaw.value ~= "off" end}, {aa_builder[tt][ss].yaw_mode, "delay"})
        aa_builder[tt][ss].yaw_jitter:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"})
        aa_builder[tt][ss].yaw_jitter_mode:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"}, {aa_builder[tt][ss].yaw_jitter, function() return aa_builder[tt][ss].yaw_jitter.value ~= "off" end})
        aa_builder[tt][ss].yaw_jitter_slider_static:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"}, {aa_builder[tt][ss].yaw_jitter, function() return aa_builder[tt][ss].yaw_jitter.value ~= "off" end}, {aa_builder[tt][ss].yaw_jitter_mode, "static"})
        aa_builder[tt][ss].yaw_jitter_slider_l:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"}, {aa_builder[tt][ss].yaw_jitter, function() return aa_builder[tt][ss].yaw_jitter.value ~= "off" end}, {aa_builder[tt][ss].yaw_jitter_mode, function() return aa_builder[tt][ss].yaw_jitter_mode.value ~= "static" end})
        aa_builder[tt][ss].yaw_jitter_slider_r:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"}, {aa_builder[tt][ss].yaw_jitter, function() return aa_builder[tt][ss].yaw_jitter.value ~= "off" end}, {aa_builder[tt][ss].yaw_jitter_mode, function() return aa_builder[tt][ss].yaw_jitter_mode.value ~= "static" end})
        aa_builder[tt][ss].yaw_jitter_slider_delay:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"}, {aa_builder[tt][ss].yaw_jitter, function() return aa_builder[tt][ss].yaw_jitter.value ~= "off" end}, {aa_builder[tt][ss].yaw_jitter_mode, "delay"})
        aa_builder[tt][ss].body_yaw:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"})
        aa_builder[tt][ss].body_yaw_slider:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"}, {aa_builder[tt][ss].body_yaw, function() return aa_builder[tt][ss].body_yaw.value ~= "off" and aa_builder[tt][ss].body_yaw.value ~= "opposite" end})
        aa_builder[tt][ss].export_opposite_team:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"}, {_ui.antiaim.condition, states[k]}, {_ui.antiaim.team_sel, teams[i]}, {aa_builder[tt][ss].enable, true}, {_ui.lua.tab, "Anti-aim"})
    end
end

defensive_builder = {}
for i, state in ipairs(states_defensive) do 
    defensive_builder[state] = {}
    local menu = defensive_builder[state]

    menu.enable = group:checkbox("enable \v".. states_defensive[i])
    menu.pitch = group:combobox("pitch", {"off", "default", "minimal", "up", "custom", "leaf"})
    menu.custom_pitch = group:slider("custom pitch", -89, 89, 0, true, "°", 1)
    menu.yaw = group:combobox("yaw", {"off", "180", "spin", "static", "180 Z", "crosshair"})
    menu.yaw_slider = group:slider("\n ", -180, 180, 0, true, "°", 1)
    menu.yaw_jitter = group:combobox("yaw jitter", {"off", "offset", "center", "random", "skitter"})
    menu.yaw_jitter_slider = group:slider("\n ", -180, 180, 0, true, "°", 1)
    menu.mode = group:combobox("mode", {"always on", "leaf"})
end

for i, state in ipairs(states_defensive) do 
    local menu = defensive_builder[state]
    menu.enable:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "defensive"}, {_ui.defensive_builder.condition, states_defensive[i]}, {_ui.lua.tab, "Anti-aim"})
    menu.pitch:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "defensive"}, {_ui.defensive_builder.condition, states_defensive[i]}, {menu.enable, true}, {_ui.lua.tab, "Anti-aim"})
    menu.custom_pitch:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "defensive"}, {_ui.defensive_builder.condition, states_defensive[i]}, {menu.enable, true}, {menu.pitch, "custom"}, {_ui.lua.tab, "Anti-aim"})
    menu.yaw:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "defensive"}, {_ui.defensive_builder.condition, states_defensive[i]}, {menu.enable, true},  {_ui.lua.tab, "Anti-aim"})
    menu.yaw_slider:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "defensive"}, {_ui.defensive_builder.condition, states_defensive[i]}, {menu.enable, true}, {menu.yaw, function() return menu.yaw.value ~= "off" end}, {_ui.lua.tab, "Anti-aim"})
    menu.yaw_jitter:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "defensive"}, {_ui.defensive_builder.condition, states_defensive[i]}, {menu.enable, true}, {_ui.lua.tab, "Anti-aim"})
    menu.yaw_jitter_slider:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "defensive"}, {_ui.defensive_builder.condition, states_defensive[i]}, {menu.enable, true}, {menu.yaw_jitter, function() return menu.yaw_jitter.value ~= "off" end}, {_ui.lua.tab, "Anti-aim"})
    menu.mode:depend({_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "defensive"}, {_ui.defensive_builder.condition, states_defensive[i]}, {_ui.lua.tab, "Anti-aim"}, {menu.enable, true})
end

_ui.antiaim.enable:depend({_ui.lua.tab, "Anti-aim"})
_ui.antiaim.aa_modes:depend({_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true})
_ui.antiaim.condition:depend({_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"})
_ui.antiaim.team_sel:depend({_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "builder"})
_ui.keybinds.freestanding:depend({_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "other"})
_ui.keybinds.freestanding_disablers:depend({_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "other"})
_ui.keybinds.edgeyaw:depend({_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "other"})
_ui.keybinds.safe_head:depend({_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "other"})
_ui.keybinds.anti_backstab:depend({_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "other"})
_ui.misc.clantag:depend({_ui.lua.tab, "Miscellaneous"})
_ui.defensive_builder.condition:depend({_ui.lua.tab, "Anti-aim"}, {_ui.antiaim.enable, true}, {_ui.antiaim.aa_modes, "defensive"})
_ui.visuals.watermark:depend({_ui.lua.tab, "Visuals"})
_ui.visuals.watermark_opt:depend({_ui.lua.tab, "Visuals"}, {_ui.visuals.watermark, "og"})
_ui.visuals.watermark_pos:depend({_ui.lua.tab, "Visuals"}, {_ui.visuals.watermark, "default"})
_ui.visuals.remove_spaces:depend({_ui.lua.tab, "Visuals"}, {_ui.visuals.watermark, "default"})
_ui.visuals.inds:depend({_ui.lua.tab, "Visuals"})
_ui.visuals.notify_style:depend({_ui.lua.tab, "Visuals"})
_ui.visuals.other_ind:depend({_ui.lua.tab, "Visuals"})
_ui.visuals.hitlogs:depend({_ui.lua.tab, "Visuals"})
_ui.misc.anims:depend({_ui.lua.tab, "Miscellaneous"})
_ui.misc.anims_opt:depend({_ui.lua.tab, "Miscellaneous"}, {_ui.misc.anims, true})

local hide_refs = function(value)
    value = not value
    ui.set_visible(ref.aa_enable, value) ui.set_visible(ref.pitch, value) ui.set_visible(ref.pitch_value, value)
    ui.set_visible(ref.yaw_base, value) ui.set_visible(ref.yaw, value) ui.set_visible(ref.yaw_value, value)
    ui.set_visible(ref.yaw_jitter, value) ui.set_visible(ref.yaw_jitter_value, value) ui.set_visible(ref.body_yaw, value)
    ui.set_visible(ref.body_yaw_value, value) ui.set_visible(ref.edgeyaw, value) ui.set_visible(ref.freestand[1], value)
    ui.set_visible(ref.freestand[2], value) ui.set_visible(ref.roll, value) ui.set_visible(ref.freestand_body_yaw, value)
end

function export_state(state, team, toteam)
    local config = pui.setup({aa_builder[team][state]})

    local data = config:save()
    local encrypted = base64.encode( json.stringify(data) )

    import_state(encrypted, state, toteam)
end

function import_state(encrypted, state,team)
    local data = json.parse(base64.decode(encrypted))

    local config = pui.setup({aa_builder[team][state]})
    config:load(data)
end

local config_items = {
    _ui.antiaim,
    aa_builder,
    defensive_builder,
    _ui.keybinds
}

local prev_simulation_time = 0

local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end

local diff_sim = 0

function sim_diff() 
    local current_simulation_time = time_to_ticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local diff = current_simulation_time - prev_simulation_time
    prev_simulation_time = current_simulation_time
    diff_sim = diff
    return diff_sim
end

local package = pui.setup(config_items)
local ground_tick = 1
local last_sim_time = 0
local defensive_until = 0
local quad_out_value = 0
local ft_prev = 0
local scope_xdxd = 0
local ground_ticks = 0
local safe_head_defensive = false
to_draw = "no"
to_up = "no"
to_draw_ticks = 0
local clantags = {
    '',
    'l',
    'le',
    'lea',
    'leaf',
    'leaf.l',
    'leaf.lua',
    'leaf.lua',
    'leaf.lua',
    'leaf.lua',
    'eaf.lua',
    'af.lua',
    'f.lua',
    'lua',
    'ua',
    'a',
    ''
}

local clantag_prev
local ctx = (function()
    local ctx = {}

    ctx.cfgs = {
        delete_config = function(name)
            local db = database.read(cfg_data.database.configs) or {}
        
            for i, v in pairs(db) do
                if v.name == name then
                    table.remove(db, i)
                    break
                end
            end
        
            for i, v in pairs(cfg_data.presets) do
                if v.name == name then
                    return false
                end
            end
        
            database.write(cfg_data.database.configs, db)
        end,
        if_preset = function(name)
            for i, v in pairs(cfg_data.presets) do
                if v.name == name then
                    return true
                end
            end
            return false
        end,
        get_config = function(name)
            local database = database.read(cfg_data.database.configs)

            for i, v in pairs(database) do
                if v.name == name then
                    return {
                        config = v.config,
                        index = i
                    }
                end
            end
        
            for i, v in pairs(cfg_data.presets) do
                if v.name == name then
                    return {
                        config = v.config,
                        index = i
                    }
                end
            end
        
            return false
        end,
        save_config = function(name)
            local db = database.read(cfg_data.database.configs) or {}
            local config = {}

            if name:match("[^%w]") ~= nil then
                return
            end

            data = package:save()
            local encrypted = base64.encode(json.stringify(data))
            table.insert(config, encrypted)

            local cfg = ctx.cfgs.get_config(name)

            if not cfg then
                table.insert(db, {name = name, config = config})
                print("saved")
            else
                db[cfg.index].config = config
                print("over")
            end

            database.write(cfg_data.database.configs, db)
        end,
        load_config = function(name)
            local cfg = ctx.cfgs.get_config(name)

            local load_cfg
            if ctx.cfgs.if_preset(name) then
                load_cfg = json.parse(base64.decode(cfg.config))
            else
                load_cfg = json.parse(base64.decode(unpack(cfg.config)))
            end

            print(load_cfg)
            package:load(load_cfg)
        end,
        getconfig_list = function()
            local database = database.read(cfg_data.database.configs) or {}
            local config = {}
            local presets = cfg_data.presets
        
            for i, v in pairs(presets) do
                table.insert(config, v.name)
            end
        
            for i, v in pairs(database) do
                table.insert(config, v.name)
            end

            return config
        end,
        export_config = function()
            data = package:save()
            encrypted = base64.encode(json.stringify(data))
            clipboard_export(encrypted)
        end,
        import_config = function()
            decrypted = json.parse(base64.decode(clipboard_import()))
            package:load(decrypted)
        end,
    }

    ctx.m_render = {
        rec = function(self, x, y, w, h, radius, color)
            radius = math.min(x/2, y/2, radius)
            local r, g, b, a = unpack(color)
            renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
            renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
            renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
            renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
            renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
            renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
            renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
        end,

        rec_outline = function(self, x, y, w, h, radius, thickness, color)
            radius = math.min(w/2, h/2, radius)
            local r, g, b, a = unpack(color)
            if radius == 1 then
                renderer.rectangle(x, y, w, thickness, r, g, b, a)
                renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
            else
                renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
                renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
                renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
                renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
                renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
                renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
                renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
                renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
            end
        end,

        glow_module = function(self, x, y, w, h, width, rounding, accent, accent_inner)
            local thickness = 1
            local offset = 1
            local r, g, b, a = unpack(accent)
            if accent_inner then
                self:rec(x , y, w, h + 1, rounding, accent_inner)
            end
            for k = 0, width do
                if a * (k/width)^(1) > 5 then
                    local accent = {r, g, b, a * (k/width)^(2)}
                    self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
                end
            end
        end
    }

    ctx.get_defensive = {
        get = function()
            local diff = sim_diff()

            if diff <= -1 then
                to_draw = "yes"
                to_up = "yes"
            end
        end
    }

    ctx.helps = {
        speed = function()
            if not entity.get_local_player() then return end
            local first_velocity, second_velocity = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
            local speed = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))
            
            return speed
        end,
        get_state = function(speed)
            if not entity.is_alive(entity.get_local_player()) then return end
            local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
            local land = bit.band(flags, bit.lshift(1, 0)) ~= 0
            if land == true then ground_tick = ground_tick + 1 else ground_tick = 0 end
        
            if bit.band(flags, 1) == 1 then
                if not ui.get(ref.doubletap[2]) then return "fakelag" end
                if ground_tick < 10 then if bit.band(flags, 4) == 4 then return "duck-jump" else return "jump" end end
                if bit.band(flags, 4) == 4 and speed > 9 then 
                    return "duck-move"
                end
                if bit.band(flags, 4) == 4 or ui.get(ref.fakeduck) then 
                    return "duck" -- crouching
                else
                    if speed <= 3 then
                        return "stand" -- standing
                    else
                        if ui.get(ref.slide[2]) then
                            return "slow-walk" -- slowwalk
                        else
                            return "run" -- moving
                        end
                    end
                end
            elseif bit.band(flags, 1) == 0 then
                if bit.band(flags, 4) == 4 then
                    return "duck-jump" -- air-c
                else
                    return "jump" -- air
                end
            end
        end,
        get_team = function()
            local me = entity.get_local_player()
            if me == nil then return end
			local index = entity.get_prop(me, "m_iTeamNum")

			return index == 2 and "t" or "ct"
        end,
        get_state_defensive = function(speed)
            if not entity.is_alive(entity.get_local_player()) then return end
            local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
            local land = bit.band(flags, bit.lshift(1, 0)) ~= 0
            if land == true then ground_tick = ground_tick + 1 else ground_tick = 0 end
            local next_attack = entity.get_prop(entity.get_local_player(), 'm_flNextAttack') - globals.curtime()

            if bit.band(flags, 1) == 1 then
                if next_attack / globals.tickinterval() > 2 then return "weapon-switch" end
                if ui.get(ref.freestand[1]) == true then return "freestanding" end 
                if ground_tick < 10 then if bit.band(flags, 4) == 4 then return "duck-jump" else return "jump" end end
                if bit.band(flags, 4) == 4 and speed > 9 then 
                    return "duck-move"
                end
                if bit.band(flags, 4) == 4 or ui.get(ref.fakeduck) then 
                    return "duck" -- crouching
                else
                    if speed <= 3 then
                        return "stand" -- standing
                    else
                        if ui.get(ref.slide[2]) then
                            return "slow-walk" -- slowwalk
                        else
                            return "run" -- moving
                        end
                    end
                end
            elseif bit.band(flags, 1) == 0 then
                if next_attack / globals.tickinterval() > 2 then return "weapon-switch" end
                if ui.get(ref.freestand[1]) == true then return "freestanding" end 
                if bit.band(flags, 4) == 4 then
                    return "duck-jump" -- air-c
                else
                    return "jump" -- air
                end
            end
        end
    }

    ctx.math = {
        calculatePercentage = function(ticks, przez)
            local percentage = (ticks / przez) * 100
            return percentage
        end
    }

    ctx.defensive_checks = {
        is_defensive_active = function()
            local tickcount = globals.tickcount()
            local sim_time = toticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
            local sim_diff = sim_time - last_sim_time

            if sim_diff < 0 then
                defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
            end

            last_sim_time = sim_time

            return defensive_until > tickcount
        end,
        choking = function(cmd)
            local choke = false
        
            if cmd.allow_send_packet == false or cmd.chokedcommands > 1 then
                choke = true
            else
                choke = false
            end
        
            return choke
        end
    }

    ctx.antiaim = {
        run = function(cmd)
            local me = entity.get_local_player()
            if not entity.is_alive(me) then return end
            local bodyYaw = entity.get_prop(me, "m_flPoseParameter", 11) * 120 - 60
            local side = bodyYaw > 0 and 1 or -1

            local state = ctx.helps.get_state(ctx.helps.speed())
            if aa_builder[ctx.helps.get_team()][ctx.helps.get_state(ctx.helps.speed())].enable.value == false then state = "global" end 
            local aa_values = aa_builder[ctx.helps.get_team()][state]
            local aa_defensive = defensive_builder[ctx.helps.get_state_defensive(ctx.helps.speed())]

            if _ui.antiaim_table.paketa_pitch >= -30 then
				_ui.antiaim_table.paketa_pitch = -89
			else
				_ui.antiaim_table.paketa_pitch = _ui.antiaim_table.paketa_pitch + 1
			end

            if globals.tickcount() % aa_values.yaw_slider_delay.value == 1 then
                _ui.antiaim_table.delayek = not _ui.antiaim_table.delayek
            end

            if contains(_ui.keybinds.freestanding_disablers.value, state) then
                ui.set(ref.freestand[1], false)
            else
                if _ui.keybinds.freestanding:get() == true then
                    ui.set(ref.freestand[1], true)
                    ui.set(ref.freestand[2], "Always on")
                else
                    ui.set(ref.freestand[1], false)
                    ui.set(ref.freestand[2], "On hotkey")
                end
            end

            
            ui.set(ref.edgeyaw, ui.get(_ui.keybinds.edgeyaw.ref) and true or false)

            if aa_defensive.enable.value == true and ctx.defensive_checks.is_defensive_active() and not ctx.defensive_checks.choking(cmd) and not safe_head_defensive then
                if aa_defensive.pitch.value == "leaf" then
                    ui.set(ref.pitch, "custom")
                    ui.set(ref.pitch_value, _ui.antiaim_table.paketa_pitch)
                else
                    ui.set(ref.pitch,aa_defensive.pitch.value)
                    ui.set(ref.pitch_value, aa_defensive.custom_pitch.value)
                end
                ui.set(ref.yaw, aa_defensive.yaw.value)
                ui.set(ref.yaw_value, aa_defensive.yaw_slider.value)
                ui.set(ref.yaw_jitter, aa_defensive.yaw_jitter.value)
                ui.set(ref.yaw_jitter_value, aa_defensive.yaw_jitter_slider.value)
            else
                if aa_values.enable.value == true then
                    ui.set(ref.pitch,aa_values.pitch.value)
                    ui.set(ref.pitch_value, aa_values.custom_pitch.value)
                    ui.set(ref.yaw_base, aa_values.yaw_base.value)
                    ui.set(ref.yaw, aa_values.yaw.value)
                    if aa_values.yaw_mode.value == "static" then
                        ui.set(ref.yaw_value, aa_values.yaw_slider_static.value)
                    elseif aa_values.yaw_mode.value == "l & r" then
                        ui.set(ref.yaw_value, side == 1 and aa_values.yaw_slider_l.value or aa_values.yaw_slider_r.value)
                    elseif aa_values.yaw_mode.value == "delay" then
                        ui.set(ref.yaw_value, _ui.antiaim_table.delayek and aa_values.yaw_slider_l.value or aa_values.yaw_slider_r.value)
                    end
                    ui.set(ref.yaw_jitter, aa_values.yaw_jitter.value)
                    if aa_values.yaw_jitter_mode.value == "static" then
                        ui.set(ref.yaw_jitter_value, aa_values.yaw_jitter_slider_static.value)
                    elseif aa_values.yaw_jitter_mode.value == "l & r" then
                        ui.set(ref.yaw_jitter_value, side == 1 and aa_values.yaw_jitter_slider_l.value or aa_values.yaw_jitter_slider_r.value)
                    end
                    ui.set(ref.body_yaw, aa_values.body_yaw.value)
                    ui.set(ref.body_yaw_value, aa_values.body_yaw_slider.value)
                end
            end

            if _ui.keybinds.safe_head.value == true then
                for i, v in pairs(entity.get_players(true)) do
                    local local_player_origin = vector(entity.get_origin(entity.get_local_player()))
                    local player_origin = vector(entity.get_origin(v))
                    local difference = (local_player_origin.z - player_origin.z)
                    local local_player_weapon = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))
        
                    if (local_player_weapon == "CKnife" and state == "duck-jump" and difference > -70) then    
                        ui.set(ref.pitch, "down")
                        ui.set(ref.yaw, "180")
                        ui.set(ref.yaw_value, -1)
                        ui.set(ref.yaw_base, "At targets")
                        ui.set(ref.yaw_jitter, "Off")
                        ui.set(ref.body_yaw, "Static")
                        ui.set(ref.body_yaw_value, 0)
                        ui.set(ref.freestand_body_yaw, false)
                        safe_head_defensive = true
                    else
                        safe_head_defensive = false
                    end
                end
            end
            
            if _ui.keybinds.anti_backstab.value == true then
                for i, v in pairs(entity.get_players(true)) do
                    local player_weapon = entity.get_classname(entity.get_player_weapon(v))
                    local player_distance = math.floor(vector(entity.get_origin(v)):dist(vector(entity.get_origin(entity.get_local_player()))) / 7)
        
                    if player_weapon == "CKnife" then
                        if player_distance < 25 then
                            ui.set(ref.yaw, "180")
                            ui.set(ref.yaw_value, -180)
                            ui.set(ref.yaw_base, "At targets")
                            ui.set(ref.yaw_jitter, "Off")
                        end
                    end
                end
            end

            if aa_defensive.enable.value == true then
                if aa_defensive.mode.value == "always on" then
                    cmd.force_defensive = true
                else
                    cmd.force_defensive = cmd.command_number % 5 ~= 3 or cmd.weaponselect ~= 0 or cmd.quick_stop == 1
                end
            end
        end
    }

    ctx.notify = {
        easeInOut = function(t)
			return (t > 0.5) and 4*((t-1)^3)+1 or 4*t^3;
		end,
        clamp = function(val, lower, upper)
			if lower > upper then lower, upper = upper, lower end
			return math.max(lower, math.min(upper, val))
		end,
        render = function()
            local Offset = 0
            for i, info_noti in ipairs(notify_data) do
                if i > 7 then
                    table.remove(notify_data, i)
                end

                if info_noti.text ~= nil and info_noti.text ~= "" then
                    if info_noti.timer + 4.1 < globals.realtime() then
                        info_noti.fraction = ctx.notify.clamp(info_noti.fraction - globals.frametime() / 0.3, 0, 1)
                    else
                        info_noti.fraction = ctx.notify.clamp(info_noti.fraction + globals.frametime() / 0.3, 0, 1)
                        info_noti.time_left = ctx.notify.clamp(info_noti.time_left + globals.frametime() / 4.1, 0, 1)
                    end
                end
                
                local fraction = ctx.notify.easeInOut(info_noti.fraction)
                
                local width = vector(renderer.measure_text("c", info_noti.text))
                local color = info_noti.color
                -- = Offset + (14 + 2 *2 + math.sqrt(2/10)*10 + 8)
                if _ui.visuals.notify_style.value == "og" then
                    render_ogskeet_border(X / 2 - width.x /2, Y - 50 - 50 - 31 * i * fraction, width.x, 13, 255 * fraction, info_noti.text)
                end
                --render_ogskeet_border(X / 2 - width.x /2, Y - 450 + 50 + 30 * i * fraction, width.x, 14, 255 * fraction, info_noti.text)
                if _ui.visuals.notify_style.value == "default" then
                    ctx.m_render:glow_module(X / 2 - width.x /2 - 33, Y - 50 - 50 - 31 * i * fraction,10+15,20, 10,2,{color[1], color[2], color[3],50 * fraction}, {30,30,30,120 * fraction})
                    if logo ~= nil then
                        logo:draw(X / 2 - width.x /2 - 31, Y - 50 - 50 - 31 * i * fraction + 1, 20, 20, 255,255,255,255 * fraction)
                    else
                        downloadFileLogo()
                    end
                    renderer.blur(X / 2 - width.x /2 - 31, Y - 50 - 50 - 31 * i * fraction, 10+15, 20, 1, 1)
                    --log
                    ctx.m_render:glow_module(X / 2 - width.x /2, Y - 50 - 50 - 31 * i * fraction, width.x + 10,20, 10,2,{color[1], color[2], color[3],50 * fraction}, {30,30,30,120 * fraction})
                    renderer.text(X / 2 + 5, Y - 50 - 50 - 31 * i * fraction + 9, 255, 255, 255, 255 * fraction, "c", 0, info_noti.text)
                    renderer.blur(X / 2 - width.x /2, Y - 50 - 50 - 31 * i * fraction, width.x, 20, 1, 1)
                end

                if _ui.visuals.notify_style.value == "modern" then
                    local me = entity.get_local_player()
                    if me == nil then
                        return
                    end
                    local steam_id = entity.get_steam64(me)
                    local steam_avatar = images.get_steam_avatar(steam_id)

                    renderer.rectangle(X/2 - width.x / 2 - 17, Y - 50 - 50 - 27 * i * fraction, width.x + 28, 18, 0,0,0, 60*fraction)
                    renderer.rectangle(X/2 - width.x / 2 - 17, Y - 50 - 50 - 27 * i * fraction, width.x + 28, 18, color[1], color[2], color[3], 10*fraction)
                    renderer.gradient(X/2 - width.x / 2 + 1, Y - 50 - 50 - 27 * i * fraction + 1, width.x * info_noti.time_left + 14, 16, color[1], color[2], color[3],255*fraction,color[1], color[2], color[3],0, true)
                    renderer.blur(X / 2 - width.x /2, Y - 50 - 50 - 27 * i * fraction, width.x + 12, 18, 1, 1)
                    steam_avatar:draw(X/2 - width.x /2 - 16, Y - 50 - 50 - 27 * i * fraction + 1, 16, 16, 255,255,255,255*fraction)
                    renderer.text(X/2 - width.x /2 + 5, Y - 50 - 50 - 27 * i * fraction + 2, 255,255,255,255*fraction, "", nil, info_noti.text)
                end

                if info_noti.timer + 4.3 < globals.realtime() then
                    table.remove(notify_data,i)
                end
            end
        end
    }

    ctx.defensive_ind = {
        render = function()
            local defensive = {ui.get(_ui.visuals.other_color)}

            if to_draw == "yes" and ui.get(ref.doubletap[2]) and contains(_ui.visuals.other_ind.value, "defensive") then
            
                draw_art = to_draw_ticks * 100 / 27
            
                ctx.m_render:glow_module(X / 2 - 50, Y / 2 * 0.5, 100,4, 10,2,{defensive[1],defensive[2],defensive[3],50}, {30,30,30,100})
                renderer.blur(X / 2 - 50, Y / 2  * 0.5,-draw_art /2, 100, 6, 1, 1)
                renderer.rectangle(X / 2, Y / 2  * 0.5,-draw_art /2 + 1,4,defensive[1],defensive[2],defensive[3],255)
                renderer.rectangle(X / 2, Y / 2  * 0.5,draw_art /2 - 1,4,defensive[1],defensive[2],defensive[3],255)
                renderer.text(X / 2 , Y / 2  * 0.5 - 10 ,255,255,255,255,"c",0,"- defensive -")

                if to_draw_ticks == 27 then
                    to_draw_ticks = 0
                    to_draw = "no"
                end
                to_draw_ticks = to_draw_ticks + 1
            end
        end
    }

    ctx.slowed_down = {
        render = function()
            local me = entity.get_local_player()
            if me == nil then return end
            if not entity.is_alive(me) then return end
            local r,g,b,a = ui.get(_ui.visuals.other_color)

            local slowed_down_value = entity.get_prop(me,"m_flVelocityModifier") * 100
            local is_defensive = to_draw == "yes" and ui.get(ref.doubletap[2]) and contains(_ui.visuals.other_ind.value, "defensive")

            if contains(_ui.visuals.other_ind.value, "slowed-down") and slowed_down_value < 100 then
                local size_bar = slowed_down_value * 98 / 100
                renderer.text(X / 2 , is_defensive and Y / 2 * 0.55 - 10 or Y / 2  * 0.5 - 10 , 255, 255, 255, 255, "c", 0, string.format("\aFFFFFFFFslowed down \aFFFFFFFF(\a%s%s%%\aFFFFFFFF)", rgba_to_hex(r, g, b, 255), math.floor(ctx.math.calculatePercentage(size_bar, 100))))
                ctx.m_render:glow_module(X / 2 - 50, is_defensive and Y / 2 * 0.55 or Y / 2 * 0.5,100,4, 10,2,{r,g,b,50}, {30,30,30,100})
                renderer.rectangle(X / 2, is_defensive and Y / 2 * 0.55 or Y / 2 * 0.5,size_bar / 2,4,r,g,b,255)
                renderer.rectangle(X / 2, is_defensive and Y / 2 * 0.55 or Y / 2 * 0.5,-size_bar / 2,4,r,g,b,255)
            end
        end
    }

    ctx.watermark = {
        table_lerp = function(a, b, percentage)
            local result = {}
            for i=1, #a do
                result[i] = lerp(a[i], b[i], percentage)
            end
            return result
        end,
        round = function(num, numDecimalPlaces)
            local mult = 10^(numDecimalPlaces or 0)
            return math.floor(num * mult + 0.5) / mult
        end,
        clamp = function(cur_val, min_val, max_val)
            return math.min(math.max(cur_val, min_val), max_val)
        end,
        colored = function(r,g,b,a, text, r2,g2,b2,a2) 
            return "\a"..rgba_to_hex(r,g,b,a)..text.."\a"..rgba_to_hex(r2,g2,b2,a2)
        end,
        lerp_color_yellow_red = function(val, max_normal, max_yellow, max_red, default, yellow, red)
            default = default or {255, 255, 255}
            yellow = yellow or {230, 210, 40}
            red = red or {255, 32, 32}
            if val > max_yellow then
                return unpack(ctx.watermark.table_lerp(yellow, red, ctx.watermark.clamp((val-max_yellow)/(max_red-max_yellow), 0, 1)))
            else
                return unpack(ctx.watermark.table_lerp(default, yellow, ctx.watermark.clamp((val-max_normal)/(max_yellow-max_normal), 0, 1)))
            end
        end,
        get_fps = function()
            ft_prev = ft_prev * 0.9 + globals.absoluteframetime() * 0.1
            return ctx.watermark.round(1 / ft_prev)
        end,
        og = function()
            local r,g,b,a = ui.get(_ui.visuals.watermark_color)
            local text = "\affffffe5le\a"..rgba_to_hex(r,g,b,230).."af\affffffe5 | "..login.username..""

            if contains(_ui.visuals.watermark_opt.value, "build") then
                text = text .. " | "..login.build..""
            end

            if contains(_ui.visuals.watermark_opt.value, "fps") then
                text = text .. " | " .. ctx.watermark.get_fps() .. " fps"
            end
            
            if contains(_ui.visuals.watermark_opt.value, "ping") then
                local fr_r, fr_g, fr_b = ctx.watermark.lerp_color_yellow_red(client.latency(), 210, 240, 300, {255,255,255})
                text = text .. " | \a"..rgba_to_hex(fr_r,fr_g,fr_b,229).."".. ctx.watermark.round(client.latency() * 1000, 0) .. "ms\affffffe5"
            end

            if contains(_ui.visuals.watermark_opt.value, "time") then
                local hours, minutes, seconds, milliseconds = client.system_time()
                hours, minutes = string.format("%02d", hours), string.format("%02d", minutes)
                text = text .. " | ".. hours .. ":" .. minutes .. ""
            end

            local width = vector(renderer.measure_text("", text))

            render_ogskeet_border(X - width.x - 20, 60, width.x, 13, 255, text)
        end,
        modern = function()
            local r,g,b,a = ui.get(_ui.visuals.watermark_color)
            local hours, minutes, seconds, milliseconds = client.system_time()
            hours, minutes = string.format("%02d", hours), string.format("%02d", minutes)
            local text = "leaf | "..login.username.. " | "..ctx.watermark.round(client.latency() * 1000, 0) .."ms | ".. hours .. ":" .. minutes .. ""
            local width = vector(renderer.measure_text("", text))
            renderer.gradient(X - width.x - 35, 15, width.x +36, 20, r,g,b,0, r,g,b,210, true)
            renderer.text(X - width.x - 2, 18, 255,255,255,255, "", nil, text)

            if logo ~= nil then
                logo:draw(X - width.x - 26, 16, 20,20,255,255,255,255)
            else
                downloadFileLogo()
            end
        end,
        default = function()
            local r,g,b,a = ui.get(_ui.visuals.watermark_color)

            local text = "L E A F"

            if _ui.visuals.remove_spaces.value == true then
                text = text:gsub(" ", "")
            end

            if _ui.visuals.watermark_pos.value == "left" then
                renderer.text(30, Y /2 - 50, 255,255,255,255, "", nil, gradient_text(text, 3, r,g,b,a).."\a"..rgba_to_hex(r,g,b,255 * math.abs(math.cos(globals.curtime()*2))).." ["..string.upper(login.build).."]")
            elseif _ui.visuals.watermark_pos.value == "right" then
                renderer.text(X - 90, Y /2 - 50, 255,255,255,255, "", nil, gradient_text(text, 3, r,g,b,a).."\a"..rgba_to_hex(r,g,b,255 * math.abs(math.cos(globals.curtime()*2))).." ["..string.upper(login.build).."]")
            elseif _ui.visuals.watermark_pos.value == "bottom" then
                renderer.text(X / 2, Y - 10, 255,255,255,255, "c", nil, gradient_text(text, 3, r,g,b,a).."\a"..rgba_to_hex(r,g,b,255 * math.abs(math.cos(globals.curtime()*2))).." ["..string.upper(login.build).."]")
            end
        end,
        render = function()
            if _ui.visuals.watermark.value == "og" then
                ctx.watermark.og()
            elseif _ui.visuals.watermark.value == "modern" then
                ctx.watermark.modern()
            elseif _ui.visuals.watermark.value == "default" then
                ctx.watermark.default()
            end
        end
    }

    ctx.inds = {
        default = function(scope)
            local r,g,b,a = ui.get(_ui.visuals.inds_color)

            local binds = string.format("\a%sQP  \a%sFS  \a%sHS", ui.get(ref.quick_peek[2]) and rgba_to_hex(r,g,b,255) or rgba_to_hex(130,130,130,190), ui.get(ref.freestand[1]) and rgba_to_hex(r,g,b,255) or rgba_to_hex(130,130,130,190), ui.get(references.on_shot_anti_aim[2]) and rgba_to_hex(r,g,b,255) or rgba_to_hex(130,130,130,190))
            local exploit = string.format("\a%sDT", ui.get(ref.doubletap[2]) and rgba_to_hex(r,g,b,255) or rgba_to_hex(130,130,130,190)) --local lua_color = {r = 176, g = 149, b = 255}

            if ui.get(ref.doubletap[2]) and ui.get(ref.quick_peek[2]) then exploit = "\a"..rgba_to_hex(r,g,b,255).."IDEAL-TICK" end
            
            local width = vector(renderer.measure_text("c-", exploit))

            renderer.text(X/2 + 16 * scope, Y/2 + 15, 0, 0, 0, 50, "c-", 0, gradient_text("LEAF.LUA", 10, r,g,b,255))
            renderer.text(X/2 + width.x /2 * scope, Y/2 + 15 + 24 - 8 * scope, 255, 255, 255, 255, "c-", 0, exploit)
            renderer.text(X/2 + 17 * scope, Y/2 + 15 + 8, 255, 255, 255, 255, "c-", 0, binds)
            renderer.text(X/2 + 17 * scope, Y/2 + 15 + 16 + 2000 * scope, 255, 255, 255, 255, "c-", 0, string.upper(ctx.helps.get_state(ctx.helps.speed())))
        end,
        render = function()
            local me = entity.get_local_player()
            if not entity.is_alive(me) then return end
            if entity.get_prop(me, "m_bIsScoped") == 1 then
                scope_xdxd = ctx.notify.clamp(scope_xdxd + globals.frametime() / 0.3, 0, 1)
            else
                scope_xdxd = ctx.notify.clamp(scope_xdxd - globals.frametime() / 0.3, 0, 1)
            end

            local fraction = ctx.notify.easeInOut(scope_xdxd)

            if _ui.visuals.inds.value == "default" then
                ctx.inds.default(fraction)
            end
        end
    }

    ctx.clantag = {
        run = function()
            local cur = math.floor(globals.tickcount() / 30) % #clantags
            local clantag = clantags[cur+1]
        
            if clantag ~= clantag_prev then
                clantag_prev = clantag
                if _ui.misc.clantag.value == true then
                    client.set_clan_tag(clantag)
                else
                    client.set_clan_tag("")
                end
            end
        end
    }

    ctx.anims = {
        run = function()
            local lp = entity.get_local_player()
            if not lp then return end
            if _ui.misc.anims.value == false then return end
            local flags = entity.get_prop(lp, "m_fFlags")
            ground_ticks = bit.band(flags, 1) == 0 and 0 or (ground_ticks < 5 and ground_ticks + 1 or ground_ticks)
        
            if contains(_ui.misc.anims_opt.value, "Static legs") and bit.band(flags, 1) == 0 then
                entity.set_prop(lp, "m_flPoseParameter", 1, 6) 
            end
        
            if contains(_ui.misc.anims_opt.value, "Leg fucker") then
                entity.set_prop(lp, "m_flPoseParameter", 1, globals.tickcount() % 4 > 1 and 5 / 10 or 1)
            end
        
            if contains(_ui.misc.anims_opt.value, "Reset pitch on land") then
                ground_ticks = bit.band(flags, 1) == 1 and ground_ticks + 1 or 0
        
                if ground_ticks > 20 and ground_ticks < 150 then
                    entity.set_prop(lp, "m_flPoseParameter", 0.5, 12)
                end
            end
        
            if contains(_ui.misc.anims_opt.value, "Micheal Jackson") then
                entity.set_prop(lp, "m_flPoseParameter", 1, 7)
                ui.set(references.leg_movement, "Never slide")
            end
        end
    }

    return ctx
end)()

function new_notify(string, r, g, b, a)
    local notification = {
        text = string,
        timer = globals.realtime(),
        color = { r, g, b, a },
        alpha = 0,
        fraction = 0,
        time_left = 0
    }

    if #notify_data == 0 then
        notification.y = Y + 20
    else
        local lastNotification = notify_data[#notify_data]
        notification.y = lastNotification.y + 20 
    end

    table.insert(notify_data, notification)
end

local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}

local function aim_hit(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local r,g,b,a = ui.get(_ui.visuals.hitlogs_color)

    if contains(_ui.visuals.hitlogs.value, "hit") then
        new_notify(string.format("\aFFFFFFFFHit \a%s%s\aFFFFFFFF in the \a%s%s\aFFFFFFFF for \a%s%d\aFFFFFFFF damage (%d health remaining)", rgba_to_hex(r,g,b,255), entity.get_player_name(e.target), rgba_to_hex(r,g,b,255), group, rgba_to_hex(r,g,b,255), e.damage, entity.get_prop(e.target, "m_iHealth") ), r,g,b,255)
    end
end

client.set_event_callback("aim_hit", aim_hit)

local function aim_miss(e)
    local group = hitgroup_names[e.hitgroup + 1] or "?"

    if contains(_ui.visuals.hitlogs.value, "miss") then
        new_notify(string.format("\aFFFFFFFFMissed \a%s%s\aFFFFFFFF (\a%s%s\aFFFFFFFF) due to \a%s%s", rgba_to_hex(219, 99, 96,255), entity.get_player_name(e.target), rgba_to_hex(219, 99, 96,255), group, rgba_to_hex(219, 99, 96,255), e.reason), 219, 99, 96,255)
    end
end

client.set_event_callback("aim_miss", aim_miss)

ui_configs = ui.new_listbox("aa", "anti-aimbot angles", "Configs", ""), function() 
    return
end
ui_configs_name = ui.new_textbox("aa", "anti-aimbot angles", "Config name", ""), function() 
    return 
end
ui_load_cfgs = ui.new_button("aa", "anti-aimbot angles", "\aC3C6FFFFLoad", function() end), function() 
    return
end
ui_save_cfgs = ui.new_button("aa", "anti-aimbot angles", "\aC3C6FFFFSave", function() end), function() 
    return
end
ui_delete_cfgs = ui.new_button("aa", "anti-aimbot angles", "\aC3C6FFFFDelete", function() end), function() 
    return
end
ui_import_cfgs = ui.new_button("aa", "anti-aimbot angles", "\aC3C6FFFFImport settings", function() end)
ui_export_cfgs = ui.new_button("aa", "anti-aimbot angles", "\aC3C6FFFFExport settings", function() end)

ui.update(ui_configs, ctx.cfgs.getconfig_list())
ui.set_callback(ui_configs, function(value)
ui.set(ui_configs_name, ctx.cfgs.getconfig_list()[ui.get(ui_configs)+1])
end)
ui.set_callback(ui_import_cfgs, function()
    local protected = function()
        ctx.cfgs.import_config()
    end

    if pcall(protected) then
        new_notify("Successfully! Imported settings from clipboard", 195, 198, 255,255)
    else
        new_notify("Errror! While importing cfg", 195, 198, 255,255)
    end
end)
ui.set_callback(ui_export_cfgs, function()
    local protected = function()
        ctx.cfgs.export_config()
    end

    if pcall(protected) then
        new_notify("Successfully! Exported settings to clipboard", 195, 198, 255,255)
    else
        new_notify("Errror! While exporting cfg", 195, 198, 255,255)
    end
end)
ui.set_callback(ui_save_cfgs, function()
    local name = ui.get(ui_configs_name)
    if name == "" then return end

    if name:match("[^%w]") ~= nil then
        --"invalid chars"
        return
    end

    local protected = function()
        ctx.cfgs.save_config(name)
    end

    if pcall(protected) then
        new_notify("Successfully! Saved settings ("..name..")", 195, 198, 255,255)
    else
        new_notify("Errror! While saving cfg", 195, 198, 255,255)
    end
    ui.update(ui_configs, ctx.cfgs.getconfig_list())
end)
ui.set_callback(ui_load_cfgs, function()
    local name = ui.get(ui_configs_name)
    if name == "" then return end

    if name:match("[^%w]") ~= nil then
        print("invalid chars")
        return
    end

    local protected = function()
        ctx.cfgs.load_config(name)
    end

    if pcall(protected) then
        new_notify("Successfully! Loaded settings ("..name..")", 195, 198, 255,255)
    else
        new_notify("Errror! While loading cfg", 195, 198, 255,255)
    end
end)
ui.set_callback(ui_delete_cfgs, function()
    local name = ui.get(ui_configs_name)
    if name == "" then return end

    if ctx.cfgs.delete_config(name) == false then
        ui.update(ui_configs, ctx.cfgs.getconfig_list())
        return
    end

    local protected = function()
        ctx.cfgs.delete_config(name)
    end

    if pcall(protected) then
        ui.update(ui_configs, ctx.cfgs.getconfig_list())
        ui.set(ui_configs, #cfg_data.presets + #database.read(cfg_data.database.configs) - #database.read(cfg_data.database.configs))
        new_notify("Successfully! deleted the config", 195, 198, 255,255)
    else
        new_notify("Failed to delete the config", 195, 198, 255,255)
    end
end)

client.set_event_callback("setup_command", function(e)
    ctx.antiaim.run(e)
    ctx.get_defensive.get()
end)

client.set_event_callback("paint", function()
    ctx.watermark.render()
    ctx.inds.render()
    ctx.defensive_ind.render()
    ctx.slowed_down.render()
end)

client.set_event_callback("paint_ui", function()    
    ctx.notify.render()
    ui.set_visible(_ui.visuals.watermark_color, _ui.lua.tab.value == "Visuals")
    ui.set_visible(_ui.visuals.inds_color, _ui.lua.tab.value == "Visuals" and _ui.visuals.inds.value ~= "off")
    ui.set_visible(_ui.visuals.hitlogs_color, _ui.lua.tab.value == "Visuals")
    ui.set_visible(_ui.visuals.other_color, _ui.lua.tab.value == "Visuals")
    hide_refs(true)
    
    ui.set_visible(ui_configs, _ui.lua.tab.value == "Config")
    ui.set_visible(ui_configs_name, _ui.lua.tab.value == "Config")
    ui.set_visible(ui_load_cfgs, _ui.lua.tab.value == "Config")
    ui.set_visible(ui_save_cfgs, _ui.lua.tab.value == "Config")
    ui.set_visible(ui_delete_cfgs, _ui.lua.tab.value == "Config")
    ui.set_visible(ui_import_cfgs, _ui.lua.tab.value == "Config")
    ui.set_visible(ui_export_cfgs, _ui.lua.tab.value == "Config")

end)

client.set_event_callback("pre_render", function()
    ctx.anims.run()
end)

client.set_event_callback("shutdown", function()
    hide_refs(false)
end)

client.set_event_callback("net_update_end", function()
    ctx.clantag:run()
end)