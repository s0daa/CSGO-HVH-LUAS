-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

-- made by swify x ivg x EssenceXC

local ffi = require"ffi"
local pui = require"neverlose/pui"
local clipboard = require"neverlose/clipboard"
local base64 = require"neverlose/base64"
local drag_system = require"neverlose/drag_system"
local gradient = require"neverlose/gradient"
local lerp = require"neverlose/lerp"


local print_meta = function(...)
    local tbl = {...}
    for k, v in pairs(tbl) do
        if type(v) == "string" then
            tbl[k] = pui.string(v)
        end
    end
    print_raw(pui.string("\v[metaset] "), unpack(tbl))
end

pui.colors.lb = color(157, 168, 214)
files.create_folder("nl\\metaset")
local lua = {
    version = "recode",
    user = string.lower(common.get_username()),
    path = "nl\\metaset\\",
}
local vars = {
    screensize = render.screen_size()
}
local configs = {
    path = "nl\\metaset\\metaset.cfg",
    default = "eyJhY2NlbnQiOnsiY29sb3IiOiIjOURBOEQ2RkYifSwiYW50aWFpbSI6eyJidWlsZGVydHlwZSI6MS4wLCJmYWtlbGFnZW5hYmxlIjp0cnVlLCJmYWtlbGFndGlja3MiOjE0LjAsImZsaWNrZXIiOmZhbHNlLCJtYW51YWxzIjoibm9uZSIsInNlbGVjdCI6ImR1Y2siLCJzdGVhbGVyIjp7InBsaXN0IjoxLjB9LCJzdGVhbHNlbGVjdCI6ImFpciIsInRhcmdldCI6ImF0IHRhcmdldCIsIn5mYWtlbGFnZW5hYmxlIjp7InR5cGVzIjoibmV2ZXJsb3NlIn0sIn5mbGlja2VyIjp7ImludmVydGVyIjpmYWxzZX0sIn5tYW51YWxzIjp7InN0YXRpYyI6dHJ1ZX0sIn50YXJnZXQiOnsiYmFja3N0YWIiOnRydWUsInNhZmUiOlsia25pZmUgaW4gYWlyK2MiLCJ+Il19fSwiYnVpbGRlciI6W3siY3VzdG9tIjp7ImRlc3luYyI6dHJ1ZSwibW9kaWZpZXIiOiJsZWZ0IC8gcmlnaHQiLCJvdmVycmlkZSI6dHJ1ZSwicGl0Y2giOiJkb3duIiwieWF3IjoiYmFja3dhcmQiLCJ+ZGVzeW5jIjp7ImludmVydGVyIjpmYWxzZSwibGVmdCI6NjAuMCwibW9kcyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0Ijo2MC4wfSwifm1vZGlmaWVyIjp7ImFuZ2xlIjowLjAsImRlbGF5IjoxLjAsImxlZnQiOjI4LjAsIm9mZnNldCI6MC4wLCJyaWdodCI6NDQuMH0sIn55YXciOnsib2Zmc2V0IjowLjB9fSwiZGVmYXVsdCI6eyJkZWZlbnNpdmUiOiJvZmYiLCJkZXN5bmMiOnRydWUsIm1vZGlmaWVyIjoibm9uZSIsIm92ZXJyaWRlIjp0cnVlLCJwaXRjaCI6ImRvd24iLCJ5YXciOiJiYWNrd2FyZCIsIn5kZWZlbnNpdmUiOnsiZGVsYXkiOi0xLjAsIm9mZnNldCI6MC4wLCJwaXRjaCI6Im9mZiIsInBpdGNob2Zmc2V0IjowLjAsInBpdGNob2Zmc2V0MiI6MC4wLCJwaXRjaHRpbWUiOjIwLjAsInJhbmdlIjowLjAsInN5bmMiOiJpbmRlcGVuZGVudCIsInlhdyI6Im9mZiJ9LCJ+ZGVzeW5jIjp7ImZzIjoicGVlayByZWFsIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0Ijo2MC4wLCJtb2RzIjpbImppdHRlciIsInJhbmRvbWl6ZSBqaXR0ZXIiLCJhbnRpIGJydXRlZm9yY2UiLCJ+Il0sInJpZ2h0Ijo2MC4wfSwifm1vZGlmaWVyIjp7Im9mZnNldCI6MC4wfSwifnlhdyI6eyJkZWxheSI6MC4wLCJsZWZ0IjowLjAsIm9mZnNldCI6MC4wLCJyYW5kb21sIjowLjAsInJhbmRvbXIiOjAuMCwicmlnaHQiOjAuMH19fSx7ImN1c3RvbSI6eyJkZXN5bmMiOnRydWUsIm1vZGlmaWVyIjoibGVmdCAvIHJpZ2h0Iiwib3ZlcnJpZGUiOnRydWUsInBpdGNoIjoiZG93biIsInlhdyI6ImJhY2t3YXJkIiwifmRlc3luYyI6eyJpbnZlcnRlciI6ZmFsc2UsImxlZnQiOjYwLjAsIm1vZHMiOlsiSml0dGVyIiwifiJdLCJyaWdodCI6NjAuMH0sIn5tb2RpZmllciI6eyJhbmdsZSI6MC4wLCJkZWxheSI6MS4wLCJsZWZ0IjoyMy4wLCJvZmZzZXQiOjAuMCwicmlnaHQiOjQxLjB9LCJ+eWF3Ijp7Im9mZnNldCI6MC4wfX0sImRlZmF1bHQiOnsiZGVmZW5zaXZlIjoiZm9yY2UiLCJkZXN5bmMiOnRydWUsIm1vZGlmaWVyIjoibm9uZSIsIm92ZXJyaWRlIjp0cnVlLCJwaXRjaCI6ImRvd24iLCJ5YXciOiJsZWZ0IC8gcmlnaHQiLCJ+ZGVmZW5zaXZlIjp7ImRlbGF5IjotMS4wLCJvZmZzZXQiOjAuMCwicGl0Y2giOiJvZmYiLCJwaXRjaG9mZnNldCI6MC4wLCJwaXRjaG9mZnNldDIiOjAuMCwicGl0Y2h0aW1lIjoyMC4wLCJyYW5nZSI6MC4wLCJzeW5jIjoiaW5kZXBlbmRlbnQiLCJ5YXciOiJvZmYifSwifmRlc3luYyI6eyJmcyI6Im9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdCI6NTYuMCwibW9kcyI6WyJqaXR0ZXIiLCJ+Il0sInJpZ2h0Ijo0NS4wfSwifm1vZGlmaWVyIjp7Im9mZnNldCI6MC4wfSwifnlhdyI6eyJkZWxheSI6MC4wLCJsZWZ0IjotMjMuMCwib2Zmc2V0IjotNzEuMCwicmFuZG9tbCI6MC4wLCJyYW5kb21yIjowLjAsInJpZ2h0Ijo0My4wfX19LHsiY3VzdG9tIjp7ImRlc3luYyI6ZmFsc2UsIm1vZGlmaWVyIjoibm9uZSIsIm92ZXJyaWRlIjpmYWxzZSwicGl0Y2giOiJvZmYiLCJ5YXciOiJmb3J3YXJkIiwifmRlc3luYyI6eyJpbnZlcnRlciI6ZmFsc2UsImxlZnQiOjAuMCwibW9kcyI6WyJ+Il0sInJpZ2h0IjowLjB9LCJ+bW9kaWZpZXIiOnsiYW5nbGUiOjAuMCwiZGVsYXkiOjEuMCwibGVmdCI6MC4wLCJvZmZzZXQiOjAuMCwicmlnaHQiOjAuMH0sIn55YXciOnsib2Zmc2V0IjowLjB9fSwiZGVmYXVsdCI6eyJkZWZlbnNpdmUiOiJhbnRpYWltIiwiZGVzeW5jIjp0cnVlLCJtb2RpZmllciI6Im5vbmUiLCJvdmVycmlkZSI6dHJ1ZSwicGl0Y2giOiJkb3duIiwieWF3IjoibGVmdCAvIHJpZ2h0IiwifmRlZmVuc2l2ZSI6eyJkZWxheSI6LTEuMCwib2Zmc2V0IjowLjAsInBpdGNoIjoib2ZmIiwicGl0Y2hvZmZzZXQiOjAuMCwicGl0Y2hvZmZzZXQyIjowLjAsInBpdGNodGltZSI6MzAuMCwicmFuZ2UiOjAuMCwic3luYyI6ImluZGVwZW5kZW50IiwieWF3Ijoib2ZmIn0sIn5kZXN5bmMiOnsiZnMiOiJvZmYiLCJpbnZlcnRlciI6ZmFsc2UsImxlZnQiOjQ4LjAsIm1vZHMiOlsiaml0dGVyIiwifiJdLCJyaWdodCI6NDEuMH0sIn5tb2RpZmllciI6eyJvZmZzZXQiOjAuMH0sIn55YXciOnsiZGVsYXkiOjAuMCwibGVmdCI6LTMzLjAsIm9mZnNldCI6MC4wLCJyYW5kb21sIjowLjAsInJhbmRvbXIiOjAuMCwicmlnaHQiOjQ0LjB9fX0seyJjdXN0b20iOnsiZGVzeW5jIjp0cnVlLCJtb2RpZmllciI6ImxlZnQgLyByaWdodCIsIm92ZXJyaWRlIjp0cnVlLCJwaXRjaCI6ImRvd24iLCJ5YXciOiJiYWNrd2FyZCIsIn5kZXN5bmMiOnsiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0Ijo2MC4wLCJtb2RzIjpbIkppdHRlciIsIn4iXSwicmlnaHQiOjYwLjB9LCJ+bW9kaWZpZXIiOnsiYW5nbGUiOjAuMCwiZGVsYXkiOjMuMCwibGVmdCI6MjcuMCwib2Zmc2V0Ijo2NS4wLCJyaWdodCI6MzguMH0sIn55YXciOnsib2Zmc2V0IjowLjB9fSwiZGVmYXVsdCI6eyJkZWZlbnNpdmUiOiJmb3JjZSIsImRlc3luYyI6dHJ1ZSwibW9kaWZpZXIiOiJub25lIiwib3ZlcnJpZGUiOnRydWUsInBpdGNoIjoiZG93biIsInlhdyI6ImxlZnQgLyByaWdodCIsIn5kZWZlbnNpdmUiOnsiZGVsYXkiOi0xLjAsIm9mZnNldCI6MC4wLCJwaXRjaCI6Im9mZiIsInBpdGNob2Zmc2V0IjowLjAsInBpdGNob2Zmc2V0MiI6MC4wLCJwaXRjaHRpbWUiOjIwLjAsInJhbmdlIjowLjAsInN5bmMiOiJpbmRlcGVuZGVudCIsInlhdyI6Im9mZiJ9LCJ+ZGVzeW5jIjp7ImZzIjoib2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0Ijo2MC4wLCJtb2RzIjpbImppdHRlciIsIn4iXSwicmlnaHQiOjYwLjB9LCJ+bW9kaWZpZXIiOnsib2Zmc2V0IjowLjB9LCJ+eWF3Ijp7ImRlbGF5IjowLjAsImxlZnQiOi0yNS4wLCJvZmZzZXQiOi03Ni4wLCJyYW5kb21sIjowLjAsInJhbmRvbXIiOjAuMCwicmlnaHQiOjQ5LjB9fX0seyJjdXN0b20iOnsiZGVzeW5jIjp0cnVlLCJtb2RpZmllciI6ImxlZnQgLyByaWdodCIsIm92ZXJyaWRlIjp0cnVlLCJwaXRjaCI6ImRvd24iLCJ5YXciOiJiYWNrd2FyZCIsIn5kZXN5bmMiOnsiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0Ijo2MC4wLCJtb2RzIjpbIkppdHRlciIsIkFudGkgQnJ1dGVmb3JjZSIsIn4iXSwicmlnaHQiOjYwLjB9LCJ+bW9kaWZpZXIiOnsiYW5nbGUiOjAuMCwiZGVsYXkiOjUuMCwibGVmdCI6MjIuMCwib2Zmc2V0IjowLjAsInJpZ2h0Ijo0OS4wfSwifnlhdyI6eyJvZmZzZXQiOjAuMH19LCJkZWZhdWx0Ijp7ImRlZmVuc2l2ZSI6ImZvcmNlIiwiZGVzeW5jIjp0cnVlLCJtb2RpZmllciI6Im5vbmUiLCJvdmVycmlkZSI6dHJ1ZSwicGl0Y2giOiJkb3duIiwieWF3IjoibGVmdCAvIHJpZ2h0IiwifmRlZmVuc2l2ZSI6eyJkZWxheSI6LTEuMCwib2Zmc2V0IjotMzYuMCwicGl0Y2giOiJjdXN0b20iLCJwaXRjaG9mZnNldCI6LTM2LjAsInBpdGNob2Zmc2V0MiI6MC4wLCJwaXRjaHRpbWUiOjIwLjAsInJhbmdlIjowLjAsInN5bmMiOiJpbmRlcGVuZGVudCIsInlhdyI6Im9mZiJ9LCJ+ZGVzeW5jIjp7ImZzIjoib2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0Ijo2MC4wLCJtb2RzIjpbImppdHRlciIsIn4iXSwicmlnaHQiOjYwLjB9LCJ+bW9kaWZpZXIiOnsib2Zmc2V0IjowLjB9LCJ+eWF3Ijp7ImRlbGF5IjowLjAsImxlZnQiOi0yMi4wLCJvZmZzZXQiOjAuMCwicmFuZG9tbCI6MC4wLCJyYW5kb21yIjowLjAsInJpZ2h0Ijo0OS4wfX19LHsiY3VzdG9tIjp7ImRlc3luYyI6dHJ1ZSwibW9kaWZpZXIiOiJsZWZ0IC8gcmlnaHQiLCJvdmVycmlkZSI6dHJ1ZSwicGl0Y2giOiJkb3duIiwieWF3IjoiYmFja3dhcmQiLCJ+ZGVzeW5jIjp7ImludmVydGVyIjpmYWxzZSwibGVmdCI6NjAuMCwibW9kcyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0Ijo2MC4wfSwifm1vZGlmaWVyIjp7ImFuZ2xlIjowLjAsImRlbGF5Ijo0LjAsImxlZnQiOjI5LjAsIm9mZnNldCI6MC4wLCJyaWdodCI6NDYuMH0sIn55YXciOnsib2Zmc2V0IjowLjB9fSwiZGVmYXVsdCI6eyJkZWZlbnNpdmUiOiJmb3JjZSIsImRlc3luYyI6dHJ1ZSwibW9kaWZpZXIiOiJub25lIiwib3ZlcnJpZGUiOnRydWUsInBpdGNoIjoiZG93biIsInlhdyI6ImxlZnQgLyByaWdodCIsIn5kZWZlbnNpdmUiOnsiZGVsYXkiOi0xLjAsIm9mZnNldCI6LTkuMCwicGl0Y2giOiJjdXN0b20iLCJwaXRjaG9mZnNldCI6LTkuMCwicGl0Y2hvZmZzZXQyIjowLjAsInBpdGNodGltZSI6MjAuMCwicmFuZ2UiOjAuMCwic3luYyI6ImluZGVwZW5kZW50IiwieWF3Ijoib2ZmIn0sIn5kZXN5bmMiOnsiZnMiOiJvZmYiLCJpbnZlcnRlciI6ZmFsc2UsImxlZnQiOjYwLjAsIm1vZHMiOlsiaml0dGVyIiwifiJdLCJyaWdodCI6NjAuMH0sIn5tb2RpZmllciI6eyJvZmZzZXQiOjAuMH0sIn55YXciOnsiZGVsYXkiOjAuMCwibGVmdCI6LTI3LjAsIm9mZnNldCI6MC4wLCJyYW5kb21sIjowLjAsInJhbmRvbXIiOjAuMCwicmlnaHQiOjM4LjB9fX0seyJjdXN0b20iOnsiZGVzeW5jIjp0cnVlLCJtb2RpZmllciI6ImxlZnQgLyByaWdodCIsIm92ZXJyaWRlIjp0cnVlLCJwaXRjaCI6ImRvd24iLCJ5YXciOiJiYWNrd2FyZCIsIn5kZXN5bmMiOnsiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0Ijo2MC4wLCJtb2RzIjpbIkppdHRlciIsIn4iXSwicmlnaHQiOjYwLjB9LCJ+bW9kaWZpZXIiOnsiYW5nbGUiOjAuMCwiZGVsYXkiOjEuMCwibGVmdCI6MjIuMCwib2Zmc2V0IjowLjAsInJpZ2h0Ijo0Ni4wfSwifnlhdyI6eyJvZmZzZXQiOjAuMH19LCJkZWZhdWx0Ijp7ImRlZmVuc2l2ZSI6ImZvcmNlIiwiZGVzeW5jIjp0cnVlLCJtb2RpZmllciI6Im5vbmUiLCJvdmVycmlkZSI6dHJ1ZSwicGl0Y2giOiJkb3duIiwieWF3IjoibGVmdCAvIHJpZ2h0IiwifmRlZmVuc2l2ZSI6eyJkZWxheSI6LTEuMCwib2Zmc2V0IjotNy4wLCJwaXRjaCI6ImN1c3RvbSIsInBpdGNob2Zmc2V0IjotNy4wLCJwaXRjaG9mZnNldDIiOjAuMCwicGl0Y2h0aW1lIjoyMC4wLCJyYW5nZSI6MC4wLCJzeW5jIjoiaW5kZXBlbmRlbnQiLCJ5YXciOiJvZmYifSwifmRlc3luYyI6eyJmcyI6Im9mZiIsImludmVydGVyIjpmYWxzZSwibGVmdCI6NjAuMCwibW9kcyI6WyJqaXR0ZXIiLCJ+Il0sInJpZ2h0Ijo2MC4wfSwifm1vZGlmaWVyIjp7Im9mZnNldCI6MC4wfSwifnlhdyI6eyJkZWxheSI6MC4wLCJsZWZ0IjotMjcuMCwib2Zmc2V0IjotNDQuMCwicmFuZG9tbCI6MC4wLCJyYW5kb21yIjowLjAsInJpZ2h0IjozOC4wfX19LHsiY3VzdG9tIjp7ImRlc3luYyI6dHJ1ZSwibW9kaWZpZXIiOiJsZWZ0IC8gcmlnaHQiLCJvdmVycmlkZSI6dHJ1ZSwicGl0Y2giOiJkb3duIiwieWF3IjoiYmFja3dhcmQiLCJ+ZGVzeW5jIjp7ImludmVydGVyIjpmYWxzZSwibGVmdCI6NjAuMCwibW9kcyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0Ijo2MC4wfSwifm1vZGlmaWVyIjp7ImFuZ2xlIjowLjAsImRlbGF5Ijo1LjAsImxlZnQiOjIyLjAsIm9mZnNldCI6MC4wLCJyaWdodCI6NDYuMH0sIn55YXciOnsib2Zmc2V0IjowLjB9fSwiZGVmYXVsdCI6eyJkZWZlbnNpdmUiOiJmb3JjZSIsImRlc3luYyI6dHJ1ZSwibW9kaWZpZXIiOiJub25lIiwib3ZlcnJpZGUiOnRydWUsInBpdGNoIjoiZG93biIsInlhdyI6ImxlZnQgLyByaWdodCIsIn5kZWZlbnNpdmUiOnsiZGVsYXkiOi0xLjAsIm9mZnNldCI6LTg0LjAsInBpdGNoIjoiaml0dGVyIiwicGl0Y2hvZmZzZXQiOi04NC4wLCJwaXRjaG9mZnNldDIiOi03MC4wLCJwaXRjaHRpbWUiOjIwLjAsInJhbmdlIjowLjAsInN5bmMiOiJpbmRlcGVuZGVudCIsInlhdyI6InJhbmRvbSJ9LCJ+ZGVzeW5jIjp7ImZzIjoib2ZmIiwiaW52ZXJ0ZXIiOmZhbHNlLCJsZWZ0Ijo2MC4wLCJtb2RzIjpbImppdHRlciIsIn4iXSwicmlnaHQiOjYwLjB9LCJ+bW9kaWZpZXIiOnsib2Zmc2V0IjowLjB9LCJ+eWF3Ijp7ImRlbGF5IjowLjAsImxlZnQiOi0yMi4wLCJvZmZzZXQiOi02NS4wLCJyYW5kb21sIjowLjAsInJhbmRvbXIiOjAuMCwicmlnaHQiOjM4LjB9fX1dLCJjb25maWciOnsiY29uZmlnbGlzdCI6MS4wLCJjb25maWduYW1lIjoiYmF0aHR1YiIsIm1vZGUiOiJsb2NhbCJ9LCJoZWxwZXJzIjp7ImN1c3RvbXpldXMiOnRydWUsImZpeHJldm8iOnRydWUsImluZGljYXRvcnMiOnRydWUsInNtYXJ0Ym9keSI6dHJ1ZSwic21hcnRqdW1wIjp0cnVlLCJzbWFydHNhZmUiOnRydWUsIn5pbmRpY2F0b3JzIjp7Im9uX3BlZWsiOmZhbHNlLCJvcHRpb25zIjpbImJhaW0iLCJzYWZlIiwiemV1cyIsInJldm8iLCJqdW1wc2NvdXQgaGl0Y2hhbmNlIiwifiJdfSwifnNtYXJ0anVtcCI6eyJkaXN0YW5jZSI6NjAuMCwib3B0aW9ucyI6WyJhZGFwdGl2ZSBoaXRjaGFuY2UiLCJsaW1pdCB2ZWxvY2l0eSIsIn4iXSwidmVsb2NpdHkiOjIyOC4wfSwifnNtYXJ0c2FmZSI6eyJtb2RlIjoiZm9yY2UiLCJvcHRpb25zIjpbIn4iXX19LCJoaWRkZW4iOnsiZG1nX3giOjk2My4wLCJkbWdfeSI6NTI3LjAsInBhbmVsX3giOjAuMCwicGFuZWxfeSI6NTE5LjAsInNvbHVzX3giOjQ0Mi4wLCJzb2x1c195Ijo0ODIuMH0sIm1pc2MiOnsiYW5pbWF0aW9uIjp0cnVlLCJjbGFudGFnIjp0cnVlLCJsYWRkZXIiOnRydWUsImxvZ3MiOnRydWUsIm1vZGVsIjpmYWxzZSwibmFkZWZpeCI6dHJ1ZSwicGluZ19zcGlrZSI6dHJ1ZSwidHJhc2h0YWxrIjpmYWxzZSwid2FsbHMiOmZhbHNlLCJ+YW5pbWF0aW9uIjp7ImFpciI6IlxuIiwiZ3JvdW5kIjoiXG4iLCJsZWFuIjowLjAsInNsaWRlIjpbIn4iXX0sIn5sb2dzIjp7ImNvbG9yIjoiI0YzNjk2OUZGIiwic2NyZWVuIjoiZGVmYXVsdCIsInR5cGVzIjpbIm9uIHNjcmVlbiIsImNvbnNvbGUiLCJ0b3AgbGVmdCIsIn4iXX0sIn5tb2RlbCI6eyJuYWRlIjoyNTUuMCwic2NvcGUiOjE3MS4wLCJ0eXBlcyI6WyJvbiBOYWRlIiwifiJdfSwifnBpbmdfc3Bpa2UiOnsiYW1vdW50IjoyMDAuMH0sIn50cmFzaHRhbGsiOnsidHlwZXMiOiJhZHZlcnRpc2VtZW50In0sIn53YWxscyI6eyJkaXN0YW5jZSI6Mi4wfX0sIm1vZGUiOjEuMCwibW9kdWxlcyI6eyJsaXN0IjpbMS4wLDIuMCwzLjAsNC4wLCJ+Il19LCJ2aXN1YWxzIjp7ImFzcGVjdCI6dHJ1ZSwiY3VzdG9tX3VpIjpmYWxzZSwiZGFtYWdlX2luZGljYXRvciI6dHJ1ZSwiZ3NfaW5kaWNhdG9yIjpmYWxzZSwiaGl0bWFya2VyIjp0cnVlLCJpbmRpY2F0b3JzIjp0cnVlLCJwYW5lbCI6dHJ1ZSwic29sdXMiOnRydWUsInZpZXdtb2RlbCI6ZmFsc2UsIndhcm5pbmdzIjp0cnVlLCJ+YXNwZWN0Ijp7ImFtb3VudCI6MTI4LjB9LCJ+Y3VzdG9tX3VpIjp7ImNvbG9yIjoiIzlEQThENkZGIn0sIn5kYW1hZ2VfaW5kaWNhdG9yIjp7ImZvbnQiOiJwaXhlbCIsImxlcnAiOmZhbHNlLCJtb2RzIjoib3ZlcnJpZGUgb25seSJ9LCJ+Z3NfaW5kaWNhdG9yIjp7InR5cGVzIjpbImRvdWJsZXRhcCIsIn4iXX0sIn5oaXRtYXJrZXIiOnsiY29sb3IiOiIjRkZGRkZGRkYifSwifmluZGljYXRvcnMiOnsiY29sb3IiOiIjQzVDNUM1OUYiLCJpdGVtcyI6WyJkb3VibGV0YXAiLCJoaWRlc2hvdHMiLCJkYW1hZ2UiLCJmcmVlc3RhbmQiLCJmYWtlZHVjayIsImJhaW0iLCJzYWZlcG9pbnQiLCJ+Il19LCJ+cGFuZWwiOnsiY29sb3IiOiIjRjM2OTY5RkYifSwifnNvbHVzIjp7ImNvbG9yIjoiI0YzNjk2OUZGIn0sIn52aWV3bW9kZWwiOnsiZm92Ijo2MC4wLCJ4IjoxMC4wLCJ5IjoxMC4wLCJ6IjotMTUuMH0sIn53YXJuaW5ncyI6eyJjb2xvciI6IiNGRkZGRkZGRiIsInR5cGVzIjpbInZlbG9jaXR5IiwifiJdfX19",
    check = function(self)
        if not files.read(self.path) or (files.read(self.path) == "[]") then
            local temptable = {
                default = self.default
            }

            files.create_folder("nl\\metaset")
            files.write(self.path, json.stringify(temptable))
        end

        if json.parse(files.read(self.path)).default ~= self.default then
            local temptable = json.parse(files.read(self.path))
            temptable.default = self.default
            files.write(self.path, json.stringify(temptable))
            print_meta("Updated default config")
        end
    end,
}
local screen = {
    size = render.screen_size(),
    scale = render.screen_size().x / 1920
}
local references = {
    slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    nl_enable = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    yaw_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    yaw_modifier_degree = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    body_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    fs_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    fs_disable_yaw_mod = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    fs_body_fs = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"),
    roll_pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"),
    roll_roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll"),
    freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    lag_option = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
    hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    hslag = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
    autopeek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
    baim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
    safe = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
    mindmg = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
    hitchance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"),
    hitchance_zeus = ui.find("Aimbot", "Ragebot", "Selection", "Taser", "Hit Chance"),
    hitchance_scout = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance"),
    autostop_scout = ui.find("Aimbot", "Ragebot", "Accuracy", "SSG-08", "Auto Stop", "Options"),
    airstrafe = ui.find("Miscellaneous", "Main", "Movement", "air Strafe"),
    legmovement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    fakeping = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
    fakeduck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    fakelagenable = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
    fakelaglimit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
    actions = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"),
    speed = ui.find("Settings", "Animation Speed"),
    attarget = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
}
local refs = references
local hitgroup_str = {
    [0] = "generic",
    "head",
    "chest",
    "stomach",
    "left arm",
    "right arm",
    "left leg",
    "right leg",
    "neck",
    "generic",
    "gear"
}
local defensive = {
    db = {},
    is_active = function(self, player, safe, mode)
        if not mode then
            mode = false
        end
        if type(player) == "number" then
            player = entity.get(player)
        end

        if player == nil or not player then return end

        local idx = player:get_index()
        local tickcount = globals.tickcount
        local sim_time = to_ticks(player.m_flSimulationTime or 0)

        self.db[idx] = self.db[idx] and self.db[idx] or {last_sim_time = 0, defensive_until = 0}

        if self.db[idx].last_sim_time == 0 then
            self.db[idx].last_sim_time = sim_time
            return safe and false or {tick = 0, active = false}
        end

        local sim_diff = sim_time - self.db[idx].last_sim_time

        if sim_diff < 0 then
            self.db[idx].defensive_until = tickcount + math.abs(sim_diff)

            if safe then
                self.db[idx].defensive_until = self.db[idx].defensive_until - to_ticks(utils.net_channel().latency[0])
            end
        end
        
        self.db[idx].last_sim_time = sim_time

        local ret = {
            tick = self.db[idx].defensive_until or 0,
            active = self.db[idx].defensive_until and (self.db[idx].defensive_until > tickcount) or false,
        }

        return mode and ret or self.db[idx].defensive_until > tickcount
    end
}
local E_POSE_PARAMETERS = {
    STRAFE_YAW = 0,
    STAND = 1,
    LEAN_YAW = 2,
    SPEED = 3,
    LADDER_YAW = 4,
    LADDER_SPEED = 5,
    JUMP_FALL = 6,
    MOVE_YAW = 7,
    MOVE_BLEND_CROUCH = 8,
    MOVE_BLEND_WALK = 9,
    MOVE_BLEND_RUN = 10,
    BODY_YAW = 11,
    BODY_PITCH = 12,
    AIM_BLEND_STAND_IDLE = 13,
    AIM_BLEND_STAND_WALK = 14,
    AIM_BLEND_STAND_RUN = 14,
    AIM_BLEND_CROUCH_IDLE = 16,
    AIM_BLEND_CROUCH_WALK = 17,
    DEATH_YAW = 18
}
ffi.cdef [[
    typedef unsigned long HANDLE;
    typedef HANDLE HWND;
    typedef const char *LPCTSTR;
    HWND GetForegroundWindow();
    bool SetWindowTextA(HWND hWnd, LPCTSTR lpString);
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
    typedef struct { uint8_t r; uint8_t g; uint8_t b; uint8_t a; } color_struct_t;
    typedef void (__cdecl* console_color_print)(void*,const color_struct_t&, const char*, ...);

    typedef struct {
        float x;
        float y;
        float z;
    } vector_t;

    // 3d vector struct

    // animstate structs; used to override animations
    typedef struct
    {
        char    pad0[0x60]; // 0x00
        void* pEntity; // 0x60
        void* pActiveWeapon; // 0x64
        void* pLastActiveWeapon; // 0x68
        float        flLastUpdateTime; // 0x6C
        int            iLastUpdateFrame; // 0x70
        float        flLastUpdateIncrement; // 0x74
        float        flEyeYaw; // 0x78
        float        flEyePitch; // 0x7C
        float        flGoalFeetYaw; // 0x80
        float        flLastFeetYaw; // 0x84
        float        flMoveYaw; // 0x88
        float        flLastMoveYaw; // 0x8C // changes when moving/jumping/hitting ground
        float        flLeanAmount; // 0x90
        char    pad1[0x4]; // 0x94
        float        flFeetCycle; // 0x98 0 to 1
        float        flMoveWeight; // 0x9C 0 to 1
        float        flMoveWeightSmoothed; // 0xA0
        float        flDuckAmount; // 0xA4
        float        flHitGroundCycle; // 0xA8
        float        flRecrouchWeight; // 0xAC
        vector_t        vecOrigin; // 0xB0
        vector_t        vecLastOrigin;// 0xBC
        vector_t        vecVelocity; // 0xC8
        vector_t        vecVelocityNormalized; // 0xD4
        vector_t        vecVelocityNormalizedNonZero; // 0xE0
        vector_t        flVelocityLenght2D; // 0xEC
        float        flJumpFallVelocity; // 0xF0
        float        flSpeedNormalized; // 0xF4 // clamped velocity from 0 to 1
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float        flRunningSpeed; // 0xF8
        float        flDuckingSpeed; // 0xFC
        float        flDurationMoving; // 0x100
        float        flDurationStill; // 0x104
        bool        bOnGround; // 0x108
        bool        bHitGroundAnimation; // 0x109
        char    pad2[0x2]; // 0x10A
        float        flNextLowerBodyYawUpdateTime; // 0x10C
        float        flDurationInAir; // 0x110
        float        flLeftGroundHeight; // 0x114
        float m_flStopToFullRunningFraction; //0x116
        float        flHitGroundWeight; // 0x118 // from 0 to 1, is 1 when standing
        float        flWalkToRunTransition; // 0x11C // from 0 to 1, doesnt change when walking or crouching, only running
        char    pad3[0x4]; // 0x120
        float        flAffectedFraction; // 0x124 // affected while jumping and running, or when just jumping, 0 to 1
        char    pad4[0x208]; // 0x128
        float        flMinBodyYaw; // 0x330
        float        flMaxBodyYaw; // 0x334
        float        flMinPitch; //0x338
        float        flMaxPitch; // 0x33C
        int            iAnimsetVersion; // 0x340
    } CPlayer_Animation_State;


    // resolver strucs number 2 lulz
    typedef struct
    {
        float   m_anim_time;		
        float   m_fade_out_time;	
        int     m_flags;			
        int     m_activity;			
        int     m_priority;			
        int     m_order;			
        int     m_sequence;			
        float   m_prev_cycle;		
        float   m_weight;			
        float   m_weight_delta_rate;
        float   m_playback_rate;	
        float   m_cycle;			
        void* m_owner;			
        int     m_bits;				
    } C_AnimationLayer;

    typedef void*(__thiscall* get_client_entity_t)(void*, int);
]]
local urlmon = ffi.load 'UrlMon'
local wininet = ffi.load 'WinInet'
local utilitize = {
    this_call = function(call_function, parameters)
        return function(...)
            return call_function(parameters, ...)
        end
    end;

    entity_list_003 = ffi.cast(ffi.typeof("uintptr_t**"), utils.create_interface("client.dll", "VClientEntityList003"));
}
local get_entity_address = utilitize.this_call(ffi.cast("get_client_entity_t", utilitize.entity_list_003[0][3]), utilitize.entity_list_003);
local is_right_click = false
local rightclickcheck = false
local tools = {
    lerp = function(start, end_pos, time)
        if start == end_pos then
            return end_pos
        end

        local frametime = globals.frametime * 170
        time = time * frametime

        local val = start + (end_pos - start) * time

        if (math.abs(val - end_pos) < 0.01) then
            return end_pos
        end

        return val
    end,
    animation = {
        database = {},
        speed = 0.07,
        lerp = function(start, end_pos, time)
            local val = start + (end_pos - start) * (globals.frametime * time)
            return val
        end,
        new = function(self, name, new_value, speed, init)
            speed = speed or self.speed
    
            if self.database[name] == nil then
                self.database[name] = (init and init) or 0
            end
    
            self.database[name] = self.lerp(self.database[name], new_value, speed)
            return self.database[name]
        end
    },
    round = function(num)
        return math.floor(num + 0.5)
    end,
    download = function(url, name)
        if (files.read(lua.path .. "\\" .. name) == nil) then
            wininet.DeleteUrlCacheEntryA(url)
            urlmon.URLDownloadToFileA(nil, url, lua.path .. name, 0,0)
            -- print("yes")
        end
    end,
    is_right_clicking = function()
        local rightclick = common.is_button_down(0x02)
        if rightclick == nil then return false end
        if not rightclickcheck and rightclick then
            rightclickcheck = true
            return true
        elseif rightclick and rightclickcheck then
            return false
        elseif rightclickcheck and not rightclick then
            rightclickcheck = false
            return false
        end
    end,
    is_left_clicking = function()
        local rightclick = common.is_button_down(0x01)
        if rightclick == nil then return false end
        if not rightclickcheck and rightclick then
            rightclickcheck = true
            return true
        elseif rightclick and rightclickcheck then
            return false
        elseif rightclickcheck and not rightclick then
            rightclickcheck = false
            return false
        end
    end,
    get_anim_layer = function(b, c)
        c = c or 1
        b = ffi.cast(ffi.typeof("void***"), b)
        return ffi.cast("C_AnimationLayer**", ffi.cast("char*", b) + 0x2990)[0][c]
    end
}

tools.download("https://github.com/ItsVladGames/funnyfilestorage/raw/main/matrix.png", "image.png")
tools.download("https://github.com/ItsVladGames/funnyfilestorage/raw/main/default.jpg", "default.jpg")
tools.download("https://github.com/ItsVladGames/funnyfilestorage/raw/main/calibrib.ttf", "calibrib.ttf")



local images = {
    xane = render.load_image_from_file(lua.path .. "image.png", vector(20, 20)),
    default = render.load_image_from_file(lua.path .. "default.jpg", vector(20, 20)),
}

local fonts = {
    verdana = render.load_font("Verdana", 11, "a"),
    gs_font = render.load_font("nl\\metaset\\calibrib.ttf", vector(25, 22, -1), "a, d"),
}

local helpers = {
    anglespitch = { 
        ["0"] = 0,
        ["down"] = 89,
        ["up"] = -89,
    },

    anglesyaw = { 
        ["forward"] = 0,
        ["backward"] = 180,
        ["left"] = 90,
        ["right"] = -90,
        ["freestand"] = 180
    },

    conditions = {"global", "stand", "slow", "move", "duck", "duck+m", "air", "air+c"},   
    state = {},

    aspectratio = 0,

    inair = function(Player)
        local flags = Player.m_fFlags
        return bit.band(flags, 1) == 0
    end,

    iscrouching = function(Player)
        local flags = Player.m_fFlags
        return bit.band(flags, 4) == 4
    end,

    getvelocity = function(Player)
        if (Player == nil) then return end
        return Player.m_vecVelocity:length()
    end,

    updatestate = function(self, cmd)
        local localplayer = entity.get_local_player()
        if not localplayer then return end

        local velocity = self.getvelocity(localplayer)
        local flags = localplayer.m_fFlags
        local ducking = bit.lshift(1, 1)
        local ground = bit.lshift(1, 0)

        local condition = {state = 0, name = ""}


        if bit.band(flags, ground) == 1 and velocity < 3 and bit.band(flags, ducking) == 0 then
            condition.name = "stand"
            condition.state = 2
        else
            if bit.band(flags, ground) == 1 and velocity > 3 and bit.band(flags, ducking)  == 0 and references.slowwalk:get() then
                condition.name = "slow"
                condition.state = 3
            end
        end
        if bit.band(flags, ground) == 1 and velocity > 3 and bit.band(flags, ducking) == 0 and not references.slowwalk:get() and not cmd.in_jump then
            condition.name = "move"
            condition.state = 4
        end
        if bit.band(flags, ground) == 1 and bit.band(flags, ducking) > 0.9 --[[and menu.antiaim.antiaim[6].override:get()]] and velocity > 10 and not cmd.in_jump then
            condition.name = "duck+m"
            condition.state = 6
        elseif bit.band(flags, ground) == 1 and bit.band(flags, ducking) > 0.9 and not cmd.in_jump then
            condition.name = "duck"
            condition.state = 5
        end
        if (cmd.in_jump or bit.band(flags, ground) == 0) and bit.band(flags, ducking) == 0 then
            condition.name = "air"
            condition.state = 7
        end
        if (cmd.in_jump or bit.band(flags, ground) == 0) and bit.band(flags, ducking) > 0.9 then
            condition.name = "air+c"
            condition.state = 8
        end
        --print(condition.state .. " bahngwgw")
        -- if freestand_active ~= nil and --[[menu.antiaim.antiaim[9].override:get() and menu.antiaim.extra.freestand:get()]] then 
        --     condition.name = "freestand"
        --     condition.state = 9
        -- end  

        self.state = condition
    end,

    closestpointtoray = function(target, RayStart, RayEnd)
        local to = target - RayStart
        local direction = RayEnd - RayStart
        local rayLenght = #direction
        direction.x = direction.x / rayLenght
        direction.y = direction.y / rayLenght
        direction.z = direction.z / rayLenght
        local directionAlong = direction.x * to.x + direction.y * to.y + direction.z * to.z
        if directionAlong < 0 then return RayStart end
        if directionAlong > rayLenght then return RayEnd end
        return vector(RayStart.x + direction.x * directionAlong, RayStart.y + direction.y * directionAlong, RayStart.z + direction.z * directionAlong)
    end,

    shouldsafehead = function(MenuRef)
        local localplayer = entity.get_local_player()
        local Weapon = localplayer:get_player_weapon():get_weapon_info().weapon_name or "nil"

        if MenuRef:get("Above Enemy") then
            if (localplayer:get_origin().z - entity.get_threat(false):get_origin().z) > MenuRef.height:get() then
                return true
            end
        end

        if MenuRef:get("Knife") then
            if (Weapon == "weapon_knife") then
                return true
            end
        end
        
            
        if MenuRef:get("Taser") then
            if (Weapon == "weapon_taser") then
                return true
            end
        end

        return false
    end,

    anglevectors = function(AngleX, AngleY)
        local sp = math.sin(math.rad(AngleX))
        local sy = math.sin(math.rad(AngleY))
        local cp = math.cos(math.rad(AngleX))
        local cy = math.cos(math.rad(AngleY))
        return vector(cp * cy, cp * sy, -sp)
    end,

    round = function(X, N)
        local n = math.pow(10, N or 0)
        local x = X * n
        if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
        return x / n
    end,


    shouldantiaim = function(cmd)
        local is_freeze = entity.get_game_rules().m_bFreezePeriod 
        local localplayer = entity.get_local_player()

        if (localplayer:get_player_weapon():get_weapon_info().weapon_type == 9) then
            return ((localplayer:get_player_weapon().m_fThrowTime or 0) == 0)
        end

        if cmd.in_attack then
            return localplayer:get_player_weapon().m_flNextPrimaryAttack > globals.curtime
        end

        return ((localplayer.m_movetype == 9) or cmd.in_use or is_freeze) == false
    end,

    normalizeyaw = function(Angle)
        return math.fmod(Angle + 180, 360) - 180
    end,

    calculateattarget = function(self, Angles)
        local target = entity.get_threat()
        if (target == nil) then return 0 end

        local LocalPosition = entity.get_local_player():get_origin()
        local targetPosition = target:get_origin()
        local Angles = (targetPosition - LocalPosition):angles() - (Angles)
        return Angles.y
    end,
}

local groups = {
    home        =   pui.create("\f<house>", "home", 1),
    config      =   pui.create("\f<house>", "config", 2),
    modules     =   pui.create("\f<house>", "modules", 2),

    antiaim     =   pui.create("\f<user-group>", "main", 1),
    stealer     =   pui.create("\f<user-group>", "\n", 1),
    plist       =   pui.create("\f<user-group>", "\n\n", 2),
    fakelag     =   pui.create("\f<user-group>", "fakelag", 1),
    builder     =   pui.create("\f<user-group>", "builder", 2),

    helpers     =   pui.create("\f<gear>", "helpers", 1),
    helpers2    =   pui.create("\f<gear>", " ", 2),

    screen      =   pui.create("\f<gear>", "screen", 1),
    misc        =   pui.create("\f<gear>", "misc", 2),
}

local menu = {
    accent = groups.home:label("Welcome to \a[lb]metaset\n", function(gear)
        return {
            color = gear:color_picker("accent color", color(157, 168, 214))
        }
    end),
    groups.home:label("User : \a[lb]" .. lua.user .. "\n"),
    groups.home:label("Version : \a[lb]" .. lua.version .. "\n"),

    mode = groups.home:list("", {"config", "modules"}),
    config = {
        mode = groups.config:combo("", {"local", "global"}),
        configlist = groups.config:list("", {"test"}),
        configname = groups.config:input(""),
    },

    modules = {
        list = groups.modules:listable("", {"antiaim", "helpers\a[lb] [BETA]", "visuals", "misc"}),
    },

    antiaim = {
        buildertype = groups.antiaim:list("", {"neverlose", "metaset"}),
        manuals = groups.antiaim:combo("Manuals", {"none", "freestand", "forward", "left", "right"}, function(gear, self)
            return
            {
                static = gear:switch("Static on Manuals", false)
            }
        end),
        target = groups.antiaim:combo("Base", {"at target", "local view"}, function(gear)
            return 
            {
                backstab = gear:switch("Avoid Backstab"),
                safe = gear:selectable("Safehead", {"knife in air", "knife in air+c", "zeus in air+c", "allow defensive"}),
                --disable = gear:switch("Disable Defensive on Safehead")
            }
        end),
        flicker = groups.antiaim:switch("Flick Exploit", false, function(gear)
            return
            {
                states = gear:selectable("states", helpers.conditions),
                -- inverter = gear:switch("inverter"),
            }, true
        end),
        select = groups.stealer:combo("\n", helpers.conditions),
        stealselect = groups.stealer:combo("\n", {"stand", "move", "duck", "air", "air+c"}),
        -- stealer = groups.stealer:button("                                 \vAA-Stealer                                 ", function() end, true),
        stealer1 = groups.stealer:button("                  \v[dev / wip]\r Anti-aim Stealer              ", function() end, true),
        stealer2 = groups.stealer:button("                  \v[dev / wip]\r Anti-aim Stealer              ", function() end, false),
        --stealer = groups.stealer:button("\f<arrow-right-to-bracket>", function() end, true),
        fakelagenable = groups.fakelag:switch("Enable", false, function(gear)
            return 
            {
                types = gear:combo("Fakelag Type", {"neverlose", "custom"})
            }, true
        end),
        fakelagticks = groups.fakelag:slider("Ticks", 1, 16, 1, 1, "t"),
        stealer = {
            plist = groups.plist:list("\n", {"Empty"}),
            steal = groups.plist:button("                             \vSteal                            ", function() end, true),
            refresh = groups.plist:button("    \f<rotate-right>    ", function() end, false),
            progress = groups.plist:label("Progress: "),
            confirm = groups.plist:button("\a00FF00FF \f<circle-check>", function() end, true),
            cancel = groups.plist:button("\aFF0000FF \f<circle-xmark>", function() end, true),
            result = groups.plist:label("Result: "),
            error = groups.plist:label("Error: "),
        }
    },

    helpers = {
        smartbody = groups.helpers:switch("Smart Baim"),
        smartjump = groups.helpers:switch("Smart Jumpscout", false, function(gear)
            return
            {
                options = gear:selectable("\n", {"adaptive hitchance", "limit distance", "limit velocity"}),
                distance = gear:slider("distance", 60, 1300, 0, 1, function(self)
                    -- if self == 0 then
                    --     return "inf."
                    -- else
                        return self.. "u"
                    -- end
                end),
                velocity = gear:slider("velocity", 20, 330, 0, 1, function(self)
                    return self .. "u"
                end),
            },
            true
        end),
        fixrevo = groups.helpers:switch("Fix R8 Misfires", false),
        smartsafe = groups.helpers2:switch("Adaptive Safepoints", false, function(gear)
            return
            {
                options = gear:selectable("\n", {"lethal", "height advantage", "onshot", "holding nade"}),
                mode = gear:combo("\n\n", {"prefer", "force"})
            },
            true
        end),
        customzeus = groups.helpers2:switch("Zeusbot Helper"),
        indicators = groups.helpers2:switch("Helper Status Indicators", false, function(gear)
        return
            {
                options = gear:selectable("\n", {"baim", "safe", "zeus", "revo", "jumpscout hitchance"}),
                on_peek = gear:switch("only on peek"),
            },
            true
        end),
    },

    visuals = {
        solus = groups.screen:switch("Solus UI", false, function(gear)
            return
            {
                color = gear:color_picker("color", color(157, 168, 214)),
            },
            true
        end),
        indicators = groups.screen:switch("Indicators",false,function(gear)
            return
            {
                items = gear:selectable("",{"doubletap","hideshots", "damage", "freestand","fakeduck","baim","safepoint"}),
                color = gear:color_picker("color", color(148, 155, 255)),
            },
            true 
        end),
        warnings = groups.screen:switch("Warnings",false,function(gear)
            return
            {
                types = gear:selectable("", {"velocity", "defensive"}),
                color = gear:color_picker("color", color(255)),
            },
            true 
        end),
        damage_indicator = groups.screen:switch("Damage Indicator", false, function(gear)
            return
            {
                font = gear:combo("font", {"pixel", "clean"}),
                mods = gear:combo("visibility", {"always", "transparent when off", "override only"}),
                lerp = gear:switch("animated")
            }, 
            true
        end),
        hitmarker = groups.screen:switch("Hit Marker", false, function(gear)
            return 
            {
                color = gear:color_picker("color",color(255, 255, 255)),
            },
            true
        end),
        aspect = groups.screen:switch("Aspect Ratio",false, function(gear)
            return 
            {
                amount = gear:slider("amount", 0, 200, 0, 0.01, function(self)
                    if self == 138 then
                        return "69:50"
                    elseif self == 133 then
                        return "4:3"
                    elseif self == 125 then
                        return "5:4"
                    elseif self == 178 then
                        return "16:9"
                    end
                end),
                r1 = gear:button("       16:9        ", function() end , true),
                r2 = gear:button("        5:4        ", function() end , true),
                r3 = gear:button("        4:3        ", function() end , true),
            },
            true
        end),
        panel = groups.screen:switch("Info Panel", false, function(gear)
            return 
            {
                color = gear:color_picker("color", color(157, 168, 214))
            },
            true
        end),
        viewmodel = groups.screen:switch("Override Viewmodel", false, function(gear)
            return 
            {
                fov = gear:slider("fov: ", 0, 100, 60),
                x = gear:slider("x: ", -150, 150, 1, 0.1),
                y = gear:slider("y: ", -150, 150, 1, 0.1),
                z = gear:slider("z: ", -150, 150, -15, 0.1),
            },
            true
        end),
        gs_indicator =  groups.screen:switch("250$ Indicator", false, function(gear)
            return
            {
               types = gear:selectable("\n", {"doubletap", "hideshots", "dormant aimbot", "fake ping", "minimum damage", "fake duck", "force baim", "freestanding"}),
            },
            true
        end),
        custom_ui = groups.screen:switch("Custom Ui", false, function(gear)
            return
            {
                color = gear:color_picker("color", color(157, 168, 214,255))
            },
            true
        end),
    },

    misc = {
        ladder = groups.misc:switch("Fast Ladder", false, function(gear)
            return
            {
            },
            true
        end),
        animation = groups.misc:switch("Animation Breaker",false, function(gear)
            return
            {
                ground = gear:combo("grounded", {"\n", "skeet", "jitter", "moonwalk"}),
                air = gear:combo("airborne", {"\n", "static", "autistic"}),
                slide = gear:selectable("slide on:", {"run", "walk", "crouch"}),
                lean = gear:slider("move lean", 0, 100, 0, 1, "%")
            },
            true
        end),
        logs = groups.misc:switch("Aimbot Logs", false, function(gear)
            return 
            {
                types = gear:selectable("type", {"on screen", "console", "top left"}),
                screen = gear:combo("screen style", {"default", "alternative"}),
                -- funny = gear:label(""),
                color = gear:color_picker("\n", color(157, 168, 214)),
                notify = gear:button("                   push notification                  ", function() end, true) 
            },
            true
        end),
        clantag = groups.misc:switch("Clantag", false),

        walls = groups.misc:switch("Avoid Walls", false, function(gear)
            return
            {
                distance = gear:slider("distance", 2, 25, 0, 1)
            },
            true
        end),

        nadefix = groups.misc:switch("Nade Fix", false),

        trashtalk = groups.misc:switch("Trashtalk", false, function(gear)
            return
            {
                types = gear:combo("type", {"advertisement", "killsay"})
            },
            true
        end),

        model = groups.misc:switch("Model Transparency", false, function(gear)
            return
            {
                types = gear:selectable("types", {"on Nade", "scoped"}),
                nade = gear:slider("nading", 0, 255, 155, 1, "%"),
                scope = gear:slider("scoped", 0, 255, 155, 1, "%"),
            },
            true
        end),

        ping_spike = groups.misc:switch("Ping Spike", false, function(gear)
            return
            {
                amount = gear:slider("\n", 0, 1000, 150, 1, "ms"),  
                warning = gear:label(" \r values above 200 may cause issues \affff00ff\f<triangle-exclamation>\r")
            },
            true
        end),

        

        --custom model transparency
    },

    hidden = {
        solus_x = groups.home:slider("solus x", 0, render.screen_size().x, 400),
        solus_y = groups.home:slider("solus y", 0, render.screen_size().y, 400),
        panel_x = groups.home:slider("panel x", 0, render.screen_size().x, 0),
        panel_y = groups.home:slider("panel y", 0, render.screen_size().y, render.screen_size().y/2 - 21),
        dmg_x = groups.home:slider("dmg x", 0, render.screen_size().x, render.screen_size().x/2 + 2),
        dmg_y = groups.home:slider("dmg y", 0, render.screen_size().y, render.screen_size().y/2 - 12),
    },
    
    builder = {}
}
local module_handler = {
    prev_disabled = false,
    refresh = function(self)
        local antiaim = menu.modules.list:get(1)
        local helper = menu.modules.list:get(2)
        local visuals = menu.modules.list:get(3)
        local misc = menu.modules.list:get(4)  
        groups.antiaim:visibility(antiaim)
        groups.builder:visibility(antiaim)
        groups.fakelag:visibility(antiaim)
        groups.stealer:visibility(antiaim)
        groups.screen:visibility(visuals)
        groups.misc:visibility(misc)
        groups.screen:visibility(visuals)
        groups.misc:visibility(misc)
        if antiaim then 
            groups.antiaim:visibility(not self.prev_disabled)
            groups.builder:visibility(not self.prev_disabled)
            groups.fakelag:visibility(not self.prev_disabled)
            groups.plist:visibility(self.prev_disabled)
        end
    end,
    hide_antiaim = function(self)
        groups.antiaim:visibility(false)
        groups.builder:visibility(false)
        groups.fakelag:visibility(false)
        groups.plist:visibility(true)
        self.prev_disabled = true
    end,
    show_antiaim = function(self)
        groups.antiaim:visibility(true)
        groups.builder:visibility(true)
        groups.fakelag:visibility(true)
        groups.plist:visibility(false)
        self.prev_disabled = false
    end,
    update_plist = function(self)
        local plaiars = entity.get_players(true, true)
        local plist = menu.antiaim.stealer.plist

        if (not plaiars) or (plaiars == {}) then 
            plist:reset() 
            return 
        else
            local temptable = {}
            local done = false
            for k, v in pairs(plaiars) do           
                done = true     
                table.insert(temptable, v:get_name())
            end
            if done then
                plist:update(temptable)
            else
                plist:reset() 
            end
        end
    end,
}
local configsystem = {
    refresh = function(self)
        local configname = menu.config.configname:get()
        configs:check()
        local configsdata = json.parse(files.read(configs.path))
        local tempshit = {}
        for k, v in pairs(configsdata) do
            table.insert(tempshit, k)
        end

        table.sort(tempshit)

        menu.config.configlist:update(tempshit)
        menu.config.configname:set(configname)
        module_handler:refresh()
    end,
    export = function(self)
        local data = base64.encode(json.stringify(pui.save()))
        -- print(data)
        clipboard.set(data)
        module_handler:refresh()
    end,
    import = function(self)
        local success, why = pcall(base64.decode, clipboard.get())
        if not success then
            print_meta("Invalid config")
            return
        end
        local data = json.parse(base64.decode(clipboard.get()))
        -- print(json.stringify(data))
        local tempshit = menu.config.configlist:get()
        
        -- local load_modules = {}
        -- for k, v in pairs(menu.config.loadmodules:list()) do
        --     for i, j in pairs(menu.config.loadmodules:get()) do
        --         if math.floor(i) == k then
        --             table.insert(load_modules, j)
        --         end
        --     end
        -- end


        -- print(json.stringify(load_modules))
        pui.load(data--[[, table.unpack(load_modules)]])
        print_meta("Config Imported")
        menu.config.configlist:set(tempshit)
        module_handler:refresh()
    end,
    save = function(self)
        local configname = menu.config.configname:get()
        if not configname or configname == "" or configname == " " then
            print_meta("Invalid config name")
            return
        end
        if configname == "default" then
            print_meta("Can't override default config")
            return
        end
        local whatamidoing = "non"
        local configsdata = json.parse(files.read(configs.path))
        local localconfig = base64.encode(json.stringify(pui.save()))

        if configsdata[configname] ~= nil then
            whatamidoing = "save"
        else
            whatamidoing = "create"
        end


        configsdata[configname] = localconfig

        files.write(configs.path, json.stringify(configsdata))
        print_meta("Config '".. configname .."' saved")
        self.refresh()
        module_handler:refresh()
    end,
    load = function(self)
        local tempshit = menu.config.configlist:get()
        local configname = menu.config.configname:get()
        if not configname or configname == "" or configname == " " then
            print_meta("Invalid config name")
            return
        end
        local configsdata = json.parse(files.read(configs.path))

        local targetconfig = configsdata[configname]
        if not targetconfig then
            print_meta("Can't find config.. Did you refresh?")
            return
        end
        local data = json.parse(base64.decode(targetconfig))
        pui.load(data)
        menu.config.configlist:set(tempshit)
        self.refresh()
        print_meta("Config '".. configname .."' loaded")
        module_handler:refresh()
    end,
    delete_confirm = function(self)
        local configname = menu.config.configname:get()
        if not configname or configname == "" or configname == " " then
            print_meta("Invalid config name")
            return
        end
        local configsdata = json.parse(files.read(configs.path))

        configsdata[configname] = nil

        files.write(configs.path, json.stringify(configsdata))
        self.refresh()
        print_meta("Config deleted succesfully")

        menu.config.delete2:visibility(false)
        utils.execute_after(0.35 / refs.speed:get(), function()
            menu.config.delete:visibility(true)
        end)    
        module_handler:refresh()
    end,
    delete = function(self)
        local configname = menu.config.configname:get()
        if not configname or configname == "" or configname == " " then
            print_meta("Invalid config name")
            return
        end

        menu.config.delete:visibility(false)
        utils.execute_after(0.35 / refs.speed:get(), function()
            menu.config.delete2:visibility(true)
        end)
        module_handler:refresh()
    end,
}
local menuhandler = {
    created = false,
    antiaim = menu.modules.list:get(1),
    helpers = menu.modules.list:get(2),
    visuals = menu.modules.list:get(3),
    misc = menu.modules.list:get(4),
    update_modules = function(self)
        self.antiaim = menu.modules.list:get(1)
        self.helpers = menu.modules.list:get(2)
        self.visuals = menu.modules.list:get(3)
        self.misc = menu.modules.list:get(4)
    end,
    setup = function(self)
        for i,v in pairs(helpers.conditions) do
            menu.builder[i] = {}
            menu.builder[i].custom = {}
            menu.builder[i].custom.override = groups.builder:switch("\v[mt] " .. v .. "\r · override")
            menu.builder[i].custom.pitch = groups.builder:combo("\v[mt] " .. v .. "\r · pitch", {"off", "down", "up", "0"})
            menu.builder[i].custom.yaw = groups.builder:combo("\v[mt] " .. v .. "\r · yaw", {"forward", "backward", "left", "right"}, function(gear) return { offset = gear:slider("offset", -180, 180, 0, 1, "°") --[[ left = gear:slider("offset", -180,180, 0, 1),  right = gear:slider("offset", -180,180, 0, 1), randoml = gear:slider("offset", -180,180, 0, 1), randomr = gear:slider("offset", -180,180, 0, 1) ]] } end)
            menu.builder[i].custom.modifier = groups.builder:combo("\v[mt] " .. v .. "\r · modifier", {"none", "center", "spin", "left / right"}, function(gear) return { angle = gear:slider("angle", -180, 180, 0, 1, "°"); left = gear:slider("left", 0, 180, 0, 1, "°"); right = gear:slider("right", 0, 180, 0, 1, "°"); delay = gear:slider("delay", 1, 32, 1, 1, "t"); offset = gear:slider("offset", -180, 180, 0, 1, "°"); } end);
            menu.builder[i].custom.desync = groups.builder:switch("\v[mt] " .. v .. "\r · desync", false, function(gear) return { inverter = gear:switch("inverter", false); left = gear:slider("left", 0, 60, 0, 1, "°"); right = gear:slider("right", 0, 60, 0, 1, "°"); mods = gear:selectable("mods", {"Jitter", "Anti Bruteforce"}); }, true end)


            menu.builder[i].default = {}
            menu.builder[i].default.override = groups.builder:switch("\v[nl] " .. v .. "\r · override")
            menu.builder[i].default.pitch = groups.builder:combo("\v[nl] " .. v .. "\r · pitch", {"off", "down"})
            menu.builder[i].default.yaw = groups.builder:combo("\v[nl] " .. v .. "\r · yaw", {"backward", "left / right", "meta", "3way"}, function(gear) return {offset = gear:slider("offset", -180, 180, 0, 1, "°"), left = gear:slider("left", -180,180, 0, 1, "°"),  right = gear:slider("right", -180,180, 0, 1, "°"), randoml = gear:slider("random left", -60,60, 0, 1, "°"), randomr = gear:slider("random right", -60,60, 0, 1, "°"), delay = gear:slider("delay",0, 14, 0, 1, "t")} end)
            menu.builder[i].default.modifier = groups.builder:combo("\v[nl] " .. v .. "\r · modifier", {"none", "center", "offset"}, function(gear) return {offset = gear:slider("offset", -180, 180, 0, 1, "°")} end)
            menu.builder[i].default.desync = groups.builder:switch("\v[nl] " .. v .. "\r · desync", false, function(gear) return {inverter = gear:switch("inverter", false), left = gear:slider("left", 0, 60, 60, 1, "°"), right = gear:slider("right", 0, 60, 60, 1, "°"), mods = gear:selectable("options", {"avoid overlap", "jitter", "randomize jitter", "anti bruteforce"}), fs = gear:combo("freestanding", {"off", "peek fake", "peek real"})}  end)
            menu.builder[i].default.defensive = groups.builder:combo("\v[nl] " .. v .. "\r · defensive", {"off", "force", "on peek", "antiaim"}, function(gear)
                return {
                    pitch = gear:combo("pitch", {"off", "custom", "jitter", "sway", "switch", "clock", "random"}),
                    pitchoffset = gear:slider("offset", -89, 89, 0, 1, "°"),
                    pitchoffset2 = gear:slider("offset II.", -89, 89, 0, 1, "°"),
                    pitchtime = gear:slider("time", 1, 64, 20, 1),
                    yaw = gear:combo("yaw", {"off", "custom", "jitter", "spin", "random"}),
                    sync = gear:combo("jitter mode", {"independent", "sync with builder"}),
                    offset = gear:slider("offset", -180, 180, 0, 1, "°"),
                    range = gear:slider("range", -180, 180, 0, 1, "°"),
                    delay = gear:slider("delay", -1, 24, -1, 1, function(self)
                        if self == -1 then
                            return "off"
                        elseif self == 0 then
                            return "cycle"
                        else
                            return self .. "t"
                        end
                    end),
                }
            end)
        end

        menu.config.mode:disabled(true)
        menu.config.mode:set("local")
        configsystem:refresh()
        self.created = true
    end,
    antiaim_visibility = function(self)
        local antiaim = menu.modules.list:get(1)
        local helper = menu.modules.list:get(2)
        local visuals = menu.modules.list:get(3)
        local misc = menu.modules.list:get(4)
        local mode = menu.mode:get() == 2
        local default = menu.antiaim.buildertype:get() == 1
        local custom = menu.antiaim.buildertype:get() == 2
        local select = menu.antiaim.select:get()

        for k, v in pairs(menu.hidden) do
            v:visibility(false)
        end

        for i,v in pairs(helpers.conditions) do
            if not menu.builder[i] then return end
            local condition = v == select
            local override = menu.builder[i].custom.override:get()
            local customstate = menu.builder[i].custom
            menu.builder[1].custom.override:set(true)
            menu.builder[1].custom.override:visibility(false)
            customstate.override:visibility(custom and condition)
            customstate.pitch:visibility(custom and condition and override)
            customstate.yaw:visibility(custom and condition and override)
            customstate.modifier:visibility(custom and condition and override)
            customstate.modifier.offset:visibility(customstate.modifier:get() == "center")
            customstate.modifier.angle:visibility(customstate.modifier:get() == "spin")
            customstate.modifier.left:visibility(customstate.modifier:get() == "left / right")
            customstate.modifier.right:visibility(customstate.modifier:get() == "left / right")
            customstate.modifier.delay:visibility(customstate.modifier:get() == "left / right" or customstate.modifier:get() == "center")
            customstate.desync:visibility(custom and condition and override)

        
            override = menu.builder[i].default.override:get()

            local defaultstate = menu.builder[i].default

            menu.builder[1].default.override:set(true)
            menu.builder[1].default.override:visibility(false)
            defaultstate.override:visibility(default and condition)
            defaultstate.pitch:visibility(default and condition and override)
            defaultstate.yaw:visibility(default and condition and override)
            defaultstate.yaw.offset:visibility(defaultstate.yaw:get() == "backward" or defaultstate.yaw:get() == "3way")
            defaultstate.yaw.left:visibility(defaultstate.yaw:get() == "left / right" or defaultstate.yaw:get() == "meta")
            defaultstate.yaw.right:visibility(defaultstate.yaw:get() == "left / right" or defaultstate.yaw:get() == "meta")
            defaultstate.yaw.randoml:visibility(defaultstate.yaw:get() == "meta")
            defaultstate.yaw.randomr:visibility(defaultstate.yaw:get() == "meta")
            defaultstate.yaw.delay:visibility(defaultstate.yaw:get() == "left / right" or defaultstate.yaw:get() == "meta")
            defaultstate.modifier:visibility(default and condition and override)
            defaultstate.desync:visibility(default and condition and override)
            defaultstate.defensive:visibility(default and condition and override)
            defaultstate.defensive.pitch:visibility((defaultstate.defensive:get() == "antiaim" or defaultstate.defensive:get() == "on peek"))
            defaultstate.defensive.pitchoffset:visibility((defaultstate.defensive:get() == "antiaim" or defaultstate.defensive:get() == "on peek") and (defaultstate.defensive.pitch:get() == "custom" or defaultstate.defensive.pitch:get() == "jitter" or defaultstate.defensive.pitch:get() == "random" or defaultstate.defensive.pitch:get() == "switch"))
            defaultstate.defensive.pitchoffset2:visibility((defaultstate.defensive:get() == "antiaim" or defaultstate.defensive:get() == "on peek") and (defaultstate.defensive.pitch:get() == "jitter" or defaultstate.defensive.pitch:get() == "random" or defaultstate.defensive.pitch:get() == "switch"))
            defaultstate.defensive.pitchtime:visibility((defaultstate.defensive:get() == "antiaim" or defaultstate.defensive:get() == "on peek") and (defaultstate.defensive.pitch:get() == "sway" or defaultstate.defensive.pitch:get() == "clock"))
            defaultstate.defensive.yaw:visibility((defaultstate.defensive:get() == "antiaim" or defaultstate.defensive:get() == "on peek"))
            defaultstate.defensive.sync:visibility((defaultstate.defensive:get() == "antiaim" or defaultstate.defensive:get() == "on peek") and defaultstate.defensive.yaw:get() == "jitter")
            defaultstate.defensive.delay:visibility((defaultstate.defensive:get() == "antiaim" or defaultstate.defensive:get() == "on peek") and defaultstate.defensive.yaw:get() == "jitter" and (defaultstate.defensive.sync:get() == "independent"))
            defaultstate.defensive.offset:visibility((defaultstate.defensive:get() == "antiaim" or defaultstate.defensive:get() == "on peek") and (defaultstate.defensive.yaw:get() == "custom" or defaultstate.defensive.yaw:get() == "sway" or defaultstate.defensive.yaw:get() == "spin" or defaultstate.defensive.yaw:get() == "jitter"))
            defaultstate.defensive.range:visibility((defaultstate.defensive:get() == "antiaim" or defaultstate.defensive:get() == "on peek") and (defaultstate.defensive.yaw:get() == "sway" or defaultstate.defensive.yaw:get() == "jitter"))
        end

        menu.modules.list:visibility(mode)
        groups.config:visibility(not mode)
        menu.helpers.smartjump.distance:visibility(menu.helpers.smartjump.options:get("limit distance"))
        menu.helpers.smartjump.velocity:visibility(menu.helpers.smartjump.options:get("limit velocity"))
        menu.misc.ping_spike.warning:visibility(menu.misc.ping_spike.amount:get() > 200)
        menu.misc.logs.screen:visibility(menu.misc.logs.types:get("on screen"))
        menu.misc.logs.color:visibility(menu.misc.logs.types:get("on screen") or menu.misc.logs.types:get("console") or menu.misc.logs.types:get("top left"))
        menu.misc.logs.notify:visibility(menu.misc.logs.types:get("on screen") or menu.misc.logs.types:get("console") or menu.misc.logs.types:get("top left"))
        menu.misc.model.nade:visibility(menu.misc.model.types:get("On Nade"))
        menu.misc.model.scope:visibility(menu.misc.model.types:get("Scoped"))
        menu.visuals.custom_ui:visibility(false)

        for k, v in pairs(menu.helpers) do
            v:visibility(helper)
        end

        if lua.version == "basic" then
            menu.antiaim.buildertype:disabled(true)
            menu.antiaim.stealer1:disabled(true)
            menu.antiaim.stealer2:visibility(false)
            menu.antiaim.stealer1:visibility(true)
            menu.antiaim.select:visibility(true)
            menu.antiaim.stealselect:visibility(false)
            for k, v in pairs(menu.antiaim.stealer) do
                v:visibility(false)
            end
            for k, v in pairs(menu.helpers) do
                if v:get() then 
                    print_meta("Helpers only available in Beta")
                    break
                end
            end
            for k, v in pairs(menu.helpers) do
                v:disabled(true)
                v:set(false)
            end
            if menu.antiaim.buildertype:get() == 2 then 
                print_meta("Viewangles only available in Beta")
                menu.antiaim.buildertype:set(1)
            end
        elseif lua.version == "beta" then
            menu.antiaim.stealer1:disabled(true)
        end
        
        self.antiaim = menu.modules.list:get(1)
        self.helpers = menu.modules.list:get(2)
        self.visuals = menu.modules.list:get(3)
        self.misc = menu.modules.list:get(4)
    end
}
local handles = {
    disableladder = {
        "CHEGrenade",
        "CMolotovGrenade",
        "CSmokeGrenade",
        "CDecoyGrenade",
        "CIncendiaryGrenade",
        "CFlashbang",
    },
    aspectratio = function()
        if not menu.visuals.aspect:get() then 
            cvar.r_aspectratio:float(0)
            return 
        end
        cvar.r_aspectratio:float(menu.visuals.aspect.amount:get() / 100)
    end,
    viewmodel = function()
        if not menu.visuals.viewmodel:get() then 
            cvar.viewmodel_fov:float(60)
            cvar.viewmodel_offset_x:float(1)
            cvar.viewmodel_offset_y:float(1)
            cvar.viewmodel_offset_z:float(-1.5)
            return
        end
        cvar.sv_competitive_minspec:int(0)
        cvar.viewmodel_fov:float(menu.visuals.viewmodel.fov:get())
        cvar.viewmodel_offset_x:float(menu.visuals.viewmodel.x:get() / 10)
        cvar.viewmodel_offset_y:float(menu.visuals.viewmodel.y:get() / 10)
        cvar.viewmodel_offset_z:float(menu.visuals.viewmodel.z:get() / 10)
    end,
    ladder = function(self, cmd)
        if not menu.misc.ladder:get() then return end
        local lplr = entity.get_local_player()
        if not lplr or not lplr:is_alive() then return end
        if not (lplr["m_MoveType"] == 9) then return end
        local camera = render.camera_angles()
        local ladderval = 0
        local abs_ladderval = math.abs(ladderval)
        local weapon = lplr:get_player_weapon()
        local nade = false
        if weapon then
            for i = 1, #self.disableladder do
                if lplr:get_classname(weapon) == self.disableladder[i] then
                    nade = true
                    break
                end
            end
        end
        if cmd.forwardmove > 0 and not nade then
            if camera.x < 45 then
                cmd.view_angles.x = 89
                cmd.in_moveright = true
                cmd.in_moveleft = false
                cmd.in_forward = false
                cmd.in_back = true
                if cmd.sidemove == 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 90
                elseif cmd.sidemove < 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 150
                elseif cmd.sidemove > 0 then
                    cmd.view_angles.y = cmd.view_angles.y + 30
                end
            end
        elseif cmd.forwardmove < 0 and not nade then
            cmd.view_angles.x = 89
            cmd.in_moveright = false
            cmd.in_moveleft = true
            cmd.in_forward = true
            cmd.in_back = false
            if cmd.sidemove == 0 then
                cmd.view_angles.y = cmd.view_angles.y + 90
            elseif cmd.sidemove > 0 then
                cmd.view_angles.y = cmd.view_angles.y + 150
            elseif cmd.sidemove < 0 then
                cmd.view_angles.y = cmd.view_angles.y + 30 
            end
        end
    end,
    ping_spike = function()
        if menu.misc.ping_spike:get() then  
            cvar.sv_maxunlag:float(1)
            refs.fakeping:override(menu.misc.ping_spike.amount:get())
            refs.fakeping:disabled(true)
        else
            refs.fakeping:override()
            cvar.sv_maxunlag:float(0.2)
            refs.fakeping:disabled(false)
        end
    end
}
local antiaim = {
    olddt = false;
    olddefensive = false;
    shot_choke = 0;
    spinval = 0;
    pitchsway = false;
    yawsway = false;
    pitchswitch = false;
    delayinvert = false;
    speen = 0;
    way3 = 1;
    temp = false;
    Angles = {
        Pitch = 0;
        Yaw = 0;
        Desync = 0;
    };

    Data = {
        FakelagAmount = 0;
        NextSwitch = 0;
        SwitchLR = false;
        DesyncSide = false;
        DesyncJitter = 0;
        DesyncJitterSide = false;
        Sidemove = 1.1;
    };

    BackupData = {
        AddedYaw = 0;
        Yaw = 0;
        Desync = 0;
    };

    setAngle = function(cmd, Bool, Angle)
        if (Bool == false) then
            cmd.view_angles.y = Angle
        else
            cmd.view_angles.x = Angle
        end
    end;

    calculateFakelag = function(self, this)
        self.Data.FakelagAmount = this.desync:get() == true and 1 or 0
        -- print(menu.antiaim.fakelagenable.types:get_override())
        if menu.antiaim.fakelagenable:get() then
            if (menu.antiaim.fakelagenable.types:get() == "neverlose") or (menu.antiaim.fakelagenable.types:get_override() == "neverlose") then
                references.fakelaglimit:override(menu.antiaim.fakelagticks:get())
                references.fakelagenable:override(true)
            else
                self.Data.FakelagAmount = menu.antiaim.fakelagticks:get()
                references.fakelagenable:override(false)
            end
        else
            references.fakelagenable:override(false)
        end
    end;

    applyFakelag = function(self, cmd)
        if (menu.antiaim.fakelagenable.types:get() == "custom") or (menu.antiaim.fakelagenable.types:get_override() == "custom") then
            if cmd.choked_commands ~= self.Data.FakelagAmount then
                cvar.sv_maxusrcmdprocessticks:int(16)
                cmd.send_packet = false
            end
            if self.shot_choke > 0 then 
                self.shot_choke = self.shot_choke - 1
                cmd.send_packet = true
            end
        end

    end;

    calculatePitch = function(self, cmd, this)
        if (this.pitch:get() == "off") then
            self.Angles.Pitch = cmd.view_angles.x
            return
        end

        if (this.pitch:get() == "custom") then
            self.Angles.Pitch = this.Pitch.Angle:get()
            return
        end

        self.Angles.Pitch = helpers.anglespitch[this.pitch:get()]
    end;

    calculateYawBase = function(self, cmd, this)
        local BackupYaw = cmd.view_angles.y

        local attarget = menu.antiaim.target:get() == "at target" 

        if (menu.antiaim.manuals:get() == "none" or menu.antiaim.manuals:get() == "freestand") then

            if (attarget and entity.get_threat()) then
                if menu.antiaim.manuals:get() ~= "freestand" then
                    BackupYaw = (BackupYaw + helpers:calculateattarget(cmd.view_angles)) + helpers.anglesyaw[this.yaw:get()] + this.yaw.offset:get() --+ (menu.antiaim.manuals:get() == "freestand" and  rage.antiaim:get_target(true) or 0)
                    self.BackupData.AddedYaw = helpers:calculateattarget(cmd.view_angles) + helpers.anglesyaw[this.yaw:get()] + this.yaw.offset:get() --+ (menu.antiaim.manuals:get() == "freestand" and  rage.antiaim:get_target(true) or 0)
                else
                    if (rage.antiaim:get_target(true) ~= nil) and menu.antiaim.manuals:get() == "freestand" then 
                        BackupYaw = (rage.antiaim:get_target(true))
                        self.BackupData.AddedYaw = (rage.antiaim:get_target(true))
                    else
                        BackupYaw = (BackupYaw + helpers:calculateattarget(cmd.view_angles)) + helpers.anglesyaw[this.yaw:get()] + this.yaw.offset:get() --+ (menu.antiaim.manuals:get() == "freestand" and  rage.antiaim:get_target(true) or 0)
                        self.BackupData.AddedYaw = helpers:calculateattarget(cmd.view_angles) + helpers.anglesyaw[this.yaw:get()] + this.yaw.offset:get() --+ (menu.antiaim.manuals:get() == "freestand" and  rage.antiaim:get_target(true) or 0)    
                    end
                end
            else
                BackupYaw = (BackupYaw + helpers.anglesyaw[this.yaw:get()]) + this.yaw.offset:get()

                self.BackupData.AddedYaw = helpers.anglesyaw[this.yaw:get()] + this.yaw.offset:get()
            end
        else

            BackupYaw = (BackupYaw + helpers.anglesyaw[menu.antiaim.manuals:get()])

        end
        self.Angles.Yaw = BackupYaw
    end;

    calculateYawModifier = function(self, cmd, this)
        if this.modifier:get() == "none" then return end
        local is_freestanding = (rage.antiaim:get_target(true) ~= nil) and menu.antiaim.manuals:get() == "freestand" and menu.antiaim.manuals.static:get()
        local is_manual = (menu.antiaim.manuals:get() ~= "none") and ((menu.antiaim.manuals:get() ~= "freestand") and menu.antiaim.manuals.static:get())
        if is_manual or is_freestanding then return end
        if this.modifier:get() == "center" then
            if (self.Data.NextSwitch < globals.client_tick) then
                if (self.Data.SwitchLR == false) then
                    self.Angles.Yaw = self.Angles.Yaw + (this.modifier.offset:get() / 2)
                    self.BackupData.Yaw = self.Angles.Yaw

                    self.Data.NextSwitch = globals.client_tick + this.modifier.delay:get()
                    self.Data.SwitchLR = true
                    self.Data.DesyncSide = false
                else
                    self.Angles.Yaw = self.Angles.Yaw - (this.modifier.offset:get() / 2)
                    self.BackupData.Yaw = self.Angles.Yaw


                    self.Data.NextSwitch = globals.client_tick + this.modifier.delay:get()
                    self.Data.SwitchLR = false
                    self.Data.DesyncSide = true
                end
            end
            self.Angles.Yaw = self.BackupData.Yaw
            return
        end

        if this.modifier:get() == "spin" then
            if (self.Data.NextSwitch < globals.client_tick) then
                self.Angles.Yaw = self.BackupData.Yaw + this.modifier.offset:get()
                self.BackupData.Yaw = self.Angles.Yaw

                self.Data.NextSwitch = globals.client_tick + this.modifier.delay:get()
                self.Data.DesyncSide = this.modifier.offset:get() <= 0 and true or false
            end
            self.Angles.Yaw = self.BackupData.Yaw
            return
        end

        if this.modifier:get() == "left / right" then
            if (self.Data.NextSwitch < globals.client_tick) then
                if (self.Data.SwitchLR == false) then
                    self.Angles.Yaw = self.Angles.Yaw + this.modifier.right:get()
                    self.BackupData.Yaw = self.Angles.Yaw

                    self.Data.NextSwitch = globals.client_tick + this.modifier.delay:get()
                    self.Data.SwitchLR = true
                    self.Data.DesyncSide = false
                else
                    self.Angles.Yaw = self.Angles.Yaw - this.modifier.left:get()
                    self.BackupData.Yaw = self.Angles.Yaw


                    self.Data.NextSwitch = globals.client_tick + this.modifier.delay:get()
                    self.Data.SwitchLR = false
                    self.Data.DesyncSide = true
                end
            end
            self.Angles.Yaw = self.BackupData.Yaw
            return
        end
    end;

    calculateDesync = function(self, cmd, this)
        if not this.desync:get() then return end
        local BackupYaw = self.Angles.Yaw

        if this.desync.mods:get("Jitter") then
            if this.modifier:get() == "None" or this.modifier:get() == "Spin" then
                if self.Data.DesyncJitter < globals.client_tick then
                    if self.Data.DesyncJitterSide == false then
                        BackupYaw = BackupYaw - this.desync.right:get()
                        self.BackupData.Desync = BackupYaw
                        self.Data.DesyncJitter = globals.client_tick + 64
                        self.Data.DesyncJitterSide = true;
                    else
                        BackupYaw = BackupYaw + this.desync.left:get()
                        self.BackupData.Desync = BackupYaw
                        self.Data.DesyncJitter = globals.client_tick + 64
                        self.Data.DesyncJitterSide = false
                    end
                end
                self.Angles.Desync = self.BackupData.Desync
                return
            else
                BackupYaw = BackupYaw  + ((self.Data.DesyncSide == true and this.desync.left:get() or -this.desync.right:get()))
            end
        else
            BackupYaw = BackupYaw + ((this.desync.inverter:get() == true and this.desync.left:get() or -this.desync.right:get()))
        end
        self.Angles.Desync = BackupYaw
    end;

    ApplyAngles = function(self, cmd, this)
        if not helpers.shouldantiaim(cmd) then return end
        local localPlayer = entity.get_local_player()

        local Yaw = helpers.normalizeyaw(self.Angles.Yaw)
        local Desync = helpers.normalizeyaw(self.Angles.Desync)


        self.setAngle(cmd, true, self.Angles.Pitch)

        if this.desync:get() then
            if cmd.choked_commands == 0 then
                if (helpers.getvelocity(localPlayer) < 4) then
                    cmd.sidemove = self.Data.Sidemove
                end
                self.setAngle(cmd, false, Desync)

            else
                self.setAngle(cmd, false, Yaw)
                self.Data.Sidemove = self.Data.Sidemove * -1
            end
            return
        end

        self.setAngle(cmd, false, Yaw)

        --[[
        if Menu.desync:get() then
            if cmd.choked_commands == 0 then
                if ((Menu.desync.mode:get() == "Micro Move") and (Helpers.GetVelocity() < 4)) then
                    cmd.sidemove = self.Data.sidemove
                    --self.Data.sidemove = self.Data.sidemove * -1
                end
                self.SetAngle(cmd, false, desync)
            else
                self.SetAngle(cmd, false, normal)
                self.Data.sidemove = self.Data.sidemove * -1
            end
        end
        ]]
    end;

    NeverloseAntiaim = function(self, cmd, this)
        local lplr = entity.get_local_player()
        if not lplr then return end
        local bodyyaw = lplr.m_flPoseParameter[11] * 120 - 60
        local side = bodyyaw > 0
        local invert = rage.antiaim:inverter()
        --local pitch = references.pitch
        --local yaw = references.yaw 
        local tickbase = (references.doubletap:get() or references.hideshots:get()) and not references.fakeduck:get()
        local lc = self.olddt ~= tickbase
        local yaw = 0
        local string = {}
        local weapon = lplr:get_player_weapon()
        -- if self.olddefensive ~= defensive:is_active(lplr) and defensive:is_active(lplr) == false then
        --     self.pitchswitch = not self.pitchswitch
        -- end
        if (defensive:is_active(lplr, true, true).tick - globals.tickcount) == 1 then
            self.pitchswitch = not self.pitchswitch
        end

        if this.pitch:get() == "down" then 
            references.pitch:set("Down")
        else
            references.pitch:override("Disabled")
        end

        references.avoid_backstab:override(menu.antiaim.target.backstab:get())
        references.attarget:override((menu.antiaim.target:get() == "at target") and "At Target" or "Local View")

        if this.desync:get() then 
            references.body_yaw:override(true)
           
            if this.desync.mods:get("jitter") then 
                if this.yaw.delay:get() == 0 then 
                    table.insert(string, "Jitter")
                end
            end 
            if this.desync.mods:get("avoid overlap") then 
                table.insert(string, "Avoid Overlap")
            end
            if this.desync.mods:get("randomize jitter") then 
                table.insert(string, "Randomize Jitter")
            end
            if this.desync.mods:get("anti bruteforce") then 
                table.insert(string, "Anti Bruteforce")
            end

            

            references.left_limit:override(this.desync.left:get())
            references.right_limit:override(this.desync.right:get())
            references.inverter:override(this.desync.inverter:get())
        end
        if this.yaw:get() == "backward" then 
            references.yaw:set("Backward")
            yaw = this.yaw.offset:get()
        elseif this.yaw:get() == "3way" then 
            local offset = this.yaw.offset:get()
            if globals.choked_commands > 0 then return end
            if tickbase then 
                self.way3 = self.way3 + 1
                
                if self.way3 > 3 then 
                    self.way3 = 1
                end
                if self.way3 == 1 then 
                    yaw = -offset/2 +3 
                    rage.antiaim:inverter(false)
                elseif self.way3 == 2 then
                    yaw = offset/2
                    rage.antiaim:inverter(true)
                else
                    yaw = -7
                    rage.antiaim:inverter(true)
                    -- references.left_limit:override(0)
                    -- references.right_limit:override(0)
                end
            else
                table.insert(string, "Jitter")
                if side and self.temp then 
                    yaw = offset/2 +3 
                    self.temp = false
                elseif not side and self.temp then
                    yaw = -offset/2
                elseif side and not self.temp then 
                    yaw = -7
                    self.temp = true
                elseif side and not self.temp then 
                    yaw = -offset/2
                end
            end
            -- print(self.way3 .. " " .. yaw .. " " .. tostring(self.temp))
        elseif this.yaw:get() == "left / right" then 
            if this.desync.mods:get("jitter") then 
                if globals.choked_commands == 0 then 
                    if globals.tickcount % (this.yaw.delay:get()+5) *2 >  this.yaw.delay:get()+5 then
                        self.delayinvert = true
                    else
                        self.delayinvert = false
                    end
                end
                if tickbase then 
                    rage.antiaim:inverter(self.delayinvert)
                    yaw = self.delayinvert and this.yaw.left:get() or this.yaw.right:get()
                else 
                    table.insert(string, "Jitter")
                    yaw = side and this.yaw.left:get() or this.yaw.right:get()    
                end    
            else
                if globals.choked_commands > 0 then return end
                if globals.tickcount % (this.yaw.delay:get() + 5) * 2 > this.yaw.delay:get() + 5 then
                    self.delayinvert = true
                else
                    self.delayinvert = false
                end
                yaw = self.delayinvert and this.yaw.left:get() or this.yaw.right:get()
            end
        elseif this.yaw:get() == "meta" then 
            if this.desync.mods:get("jitter") then 
                if globals.choked_commands == 0 then 
                    if globals.tickcount % (this.yaw.delay:get() + 5) *2  >  this.yaw.delay:get() + 5 then
                        self.delayinvert = true
                    else
                        self.delayinvert = false
                    end
                end
                if tickbase then 
                    rage.antiaim:inverter(self.delayinvert)
                    yaw = self.delayinvert and this.yaw.left:get() + math.random(0, this.yaw.randoml:get()) or this.yaw.right:get() + math.random(0, this.yaw.randomr:get())
                else 
                    table.insert(string, "Jitter")
                    yaw = side and this.yaw.left:get() + math.random(0, this.yaw.randoml:get()) or this.yaw.right:get() + math.random(0, this.yaw.randomr:get())
                end    
            else
                if globals.choked_commands > 0 then return end
                if globals.tickcount % (this.yaw.delay:get() + 5) * 2 > this.yaw.delay:get() + 5 then
                    self.delayinvert = true
                else
                    self.delayinvert = false
                end
                yaw = self.delayinvert and this.yaw.left:get() + math.random(0, this.yaw.randoml:get()) or this.yaw.right:get() + math.random(0, this.yaw.randomr:get())
            end
        end
        
        if this.modifier:get() == "center" then 
            if this.yaw.delay:get() == 0 then 
                references.yaw:set("Backward")
                yaw = yaw + (side and this.modifier.offset:get()/2 or -this.modifier.offset:get()/2)

            else
                if this.desync.mods:get("jitter") then 
                    if globals.choked_commands > 0 then return end
                    if globals.tickcount % (this.yaw.delay:get() + 6) *2  >  this.yaw.delay:get() + 6 then
                        self.delayinvert = true
                    else
                        self.delayinvert = false
                    end
                    rage.antiaim:inverter(self.delayinvert)
                    --references.yaw_yaw:override(((tickbase and self.delayinvert or side) and this.yaw.left:get() or this.yaw.right:get()))

                    if tickbase then 
                        yaw = yaw + (self.delayinvert and this.modifier.offset:get()/2 or -this.modifier.offset:get()/2)
                    else 
                        yaw = yaw + (side and this.modifier.offset:get()/2 or -this.modifier.offset:get()/2)
                    end
                else
                    if globals.choked_commands > 0 then return end
                    yaw = yaw + (self.delayinvert and this.modifier.offset:get()/2 or -this.modifier.offset:get()/2)
                end
            end
        elseif this.modifier:get() == "offset" then 
            if this.yaw.delay:get() == 0 then 
                references.yaw:set("Backward")
                yaw = (side and this.modifier.offset:get() + yaw or yaw )

            else
                if this.desync.mods:get("jitter") then 
                    if globals.choked_commands > 0 then return end
                    if globals.tickcount % (this.yaw.delay:get() + 6) *2  >  this.yaw.delay:get() + 6 then
                        self.delayinvert = true
                    else
                        self.delayinvert = false
                    end
                    rage.antiaim:inverter(self.delayinvert)
                    --references.yaw_yaw:override(((tickbase and self.delayinvert or side) and this.yaw.left:get() or this.yaw.right:get()))

                    if tickbase then 
                        yaw = (self.delayinvert and this.modifier.offset:get() + yaw or yaw )
                    else 
                        yaw = (side and this.modifier.offset:get() + yaw or yaw )
                    end
                else
                    if globals.choked_commands > 0 then return end
                    yaw = (self.delayinvert and this.modifier.offset:get() + yaw or yaw )
                end
            end
        end



        if this.defensive:get() == "force" then
            references.hidden:override(false)
            references.lag_option:override("Always On")
        elseif this.defensive:get() == "antiaim" then 
            references.hidden:set(true)
            references.lag_option:override("Always On")
        else
            references.hidden:override(false)
            references.lag_option:override("On Peek")
        end

        if this.defensive:get() == "on peek" or this.defensive:get() == "antiaim" then
            references.hidden:override(true)
            if this.defensive.pitch:get() == "custom" then
                rage.antiaim:override_hidden_pitch(this.defensive.pitchoffset:get())
            elseif this.defensive.pitch:get() == "random" then
                rage.antiaim:override_hidden_pitch(math.random(this.defensive.pitchoffset:get(), this.defensive.pitchoffset2:get()))
            elseif this.defensive.pitch:get() == "jitter" then
                rage.antiaim:override_hidden_pitch(globals.tickcount % 4 < 2 and this.defensive.pitchoffset:get() or this.defensive.pitchoffset2:get())
            elseif this.defensive.pitch:get() == "switch" then
                rage.antiaim:override_hidden_pitch(self.pitchswitch and this.defensive.pitchoffset:get() or this.defensive.pitchoffset2:get())
                -- if (defensive:is_active(lplr, true, true).tick - globals.tickcount) == 1 then
                --     self.pitchswitch = not self.pitchswitch
                -- end
            elseif this.defensive.pitch:get() == "sway" then
                local higher = 0
                local lower = 0
                if this.defensive.pitchoffset:get() > this.defensive.pitchoffset2:get() then
                    higher = this.defensive.pitchoffset:get()
                    lower = this.defensive.pitchoffset2:get()
                elseif this.defensive.pitchoffset:get() < this.defensive.pitchoffset2:get() then
                    higher = this.defensive.pitchoffset2:get()
                    lower = this.defensive.pitchoffset:get()
                end
                local pitch = math.floor(tools.animation:new("pitchsway", self.pitchsway and 90 or -90, this.defensive.pitchtime:get()) + 0.5)
                if pitch > 87 then
                    self.pitchsway = false
                elseif pitch < -87 then
                    self.pitchsway = true
                end
                rage.antiaim:override_hidden_pitch(pitch)
            elseif this.defensive.pitch:get() == "clock" then
                local pitch = math.floor(tools.animation:new("pitchclock", self.pitchsway and 90 or -90, this.defensive.pitchtime:get()) + 0.5)
                if pitch > 87 then
                    self.pitchsway = false
                elseif pitch < -87 then
                    self.pitchsway = true
                end
                rage.antiaim:override_hidden_pitch(pitch)
            end

            if this.defensive.yaw:get() == "custom" then
                rage.antiaim:override_hidden_yaw_offset(this.defensive.offset:get() + yaw)
            elseif this.defensive.yaw:get() == "random" then
                rage.antiaim:override_hidden_yaw_offset(math.random(-180, 180))
            elseif this.defensive.yaw:get() == "static spin" then
                rage.antiaim:override_hidden_yaw_offset(self.spinval + yaw) -- awesome idea where it spins but if ur defensive it stops, so every defensive cycle u have new yaw (spinning when not defensive)
            elseif this.defensive.yaw:get() == "spin" then
                self.speen = this.defensive.offset:get() + self.speen
                rage.antiaim:override_hidden_yaw_offset(self.speen + yaw)
            elseif this.defensive.yaw:get() == "jitter" then
                local side = false
                if this.defensive.sync:get() == "sync with builder" then
                    side = this.yaw.delay:get() > 0 and self.delayinvert or rage.antiaim:inverter()
                else
                    if this.defensive.delay:get() == -1 then
                        side = globals.tickcount % (2 * 2) < 2
                    elseif this.defensive.delay:get() == 0 then
                        side = self.pitchswitch
                    else
                        side = globals.tickcount % (this.defensive.delay:get()) * 2 > (this.defensive.delay:get())
                    end
                end
                rage.antiaim:override_hidden_yaw_offset(yaw + this.defensive.offset:get() + (this.defensive.range:get() * (side and -1 or 1)))
            end
        end

        if menu.antiaim.flicker:get() and menu.antiaim.flicker.states:get(helpers.state.state) then
            -- local inverting = menu.antiaim.flicker.inverter:get()
            --print_dev(menu.antiaim.flicker.states:get(helpers.state.state))
            if not (menu.antiaim.flicker.states:get(helpers.state.state)) then return end
            if rage.exploit:get() < 1 then return end
            rage.antiaim:inverter(false)

            refs.yaw_yaw:override(5)
            refs.yaw_modifier:override("Random")
            refs.yaw_modifier_degree:override(5)
            refs.body_yaw:override(true)
            refs.body_options:override("")
            refs.left_limit:override(42)
            refs.right_limit:override(42)
            refs.freestanding:override(false)

            refs.hidden:override(true)
            rage.antiaim:override_hidden_pitch(89)
            rage.antiaim:override_hidden_yaw_offset(-70 or 90)
            rage.antiaim:override_hidden_yaw_offset(-90 or 70)

            refs.hslag:override("Break LC" or nil)
            refs.lag_option:override("Always On" or nil)
            --cmd.no_choke = true   
            cmd.force_defensive = cmd.command_number % 7 == 0
        end



        --print(weapon_info.weapon_name)
        if not weapon then return end
        local weapon_info = weapon:get_weapon_info()

        if menu.antiaim.target.safe:get("knife in air") and helpers.state.state == 7 and weapon_info.weapon_name == "weapon_knife" then 
            yaw = 0
            rage.antiaim:inverter(true)
            refs.left_limit:override(0)
            if not menu.antiaim.target.safe:get("allow defensive") then 
                refs.hidden:override(false)
            end
        elseif menu.antiaim.target.safe:get("knife in air+c") and helpers.state.state == 8 and weapon_info.weapon_name == "weapon_knife"  then 
            yaw = 0
            rage.antiaim:inverter(true)
            refs.left_limit:override(0)
            if not menu.antiaim.target.safe:get("allow defensive") then 
                refs.hidden:override(false)
            end
        elseif menu.antiaim.target.safe:get("zeus in air+c") and helpers.state.state == 8 and weapon_info.weapon_name == "weapon_taser"then 
            yaw = 0
            rage.antiaim:inverter(true)
            refs.left_limit:override(0)
            if not menu.antiaim.target.safe:get("allow defensive") then
                refs.hidden:override(false)
            end
        end

        if menu.antiaim.manuals:get() == "left" then 
            if not menu.antiaim.manuals.static:get() then
                yaw = yaw - 90
            else
                yaw = -90
                rage.antiaim:inverter(false)
                references.body_options:override("")
            end
        end
        if menu.antiaim.manuals:get() == "right" then 
            if not menu.antiaim.manuals.static:get() then
                yaw = yaw + 90
            else
                yaw = 90
                rage.antiaim:inverter(false)
            end
            references.body_options:override("")
        end
        if menu.antiaim.manuals:get() == "forward" then 
            if not menu.antiaim.manuals.static:get() then
                yaw = yaw - 180
            else
                yaw = 180
                rage.antiaim:inverter(false)
            end
            references.body_options:override("")
        end
        if menu.antiaim.manuals:get() == "freestand" then 
            if not menu.antiaim.manuals.static:get() then
                references.freestanding:override(true)
            else
                if rage.antiaim:get_target(true) ~= nil then
                references.freestanding:override(true)
                references.body_options:override("")
                rage.antiaim:inverter(false)
                end
            end
            
        else
            references.freestanding:override(false)
        end


        references.body_options:override(string)
        references.yaw_yaw:override(yaw)
        self.olddt = tickbase
        self.olddefensive = defensive:is_active(lplr)
    end;

    run = function(self, cmd)
        if not menu.modules.list:get(1) then return end
        local index = 1;
        local currentstate = helpers.state.state;
        --print(menu.antiaim.buildertype:get())
        if menu.antiaim.buildertype:get() == 2 and menu.builder[currentstate].custom.override:get() or menu.antiaim.buildertype:get() == 1 and menu.builder[currentstate].default.override:get() then index = currentstate end
        local this = ((menu.antiaim.buildertype:get() == 2) and menu.builder[index].custom) or menu.builder[index].default
        --print(index)
        if menu.antiaim.buildertype:get() == 2 then
            self:calculateFakelag(this)
            self:applyFakelag(cmd)
            self:calculatePitch(cmd, this)
            self:calculateYawBase(cmd, this)
            self:calculateYawModifier(cmd, this)
            self:calculateDesync(cmd, this)
            self:ApplyAngles(cmd, this)
            references.nl_enable:override(false)
            menu.antiaim.fakelagenable.types:override("Custom")
            menu.antiaim.fakelagenable.types:disabled(true)
        else
            references.nl_enable:override(true)
            self:calculateFakelag(this)
            self:applyFakelag(cmd)
            self:NeverloseAntiaim(cmd, this)
            menu.antiaim.fakelagenable.types:override()
            menu.antiaim.fakelagenable.types:disabled(false)
        end
    end;

    reset_builder = function(self)
        self.Data.FakelagAmount = 0
        self.Data.NextSwitch = 0
        self.Data.DesyncJitter = 0
    end
}
local key_modes = {
    "holding",
    "toggled",
    "~",
}

local indicators = {
    dt_text = {"waiting", color(255,50,50,255)},
    hs_text = {"waiting", color(255,50,50,255)},
    db = {},
    render_indicators = function(self)
        if not globals.is_connected or not globals.is_in_game then return end
        local lplr = entity.get_local_player()
        if not lplr or not lplr:is_alive() then return end
        if not menu.visuals.indicators:get() then return end
        if not menuhandler.visuals then return end
        local indcolor = menu.visuals.indicators.color.value
        local r,g,b,a = indcolor.r,indcolor.g,indcolor.b,indcolor.a

        if references.doubletap:get() then
            self.dt_text = rage.exploit:get() == 0 and {"waiting",color(255,150,150,255)} or (rage.exploit:get() > 0 and rage.exploit:get() < 1) and {"charging",color(255-(255-r),rage.exploit:get()*g,rage.exploit:get()*b,255)} or rage.exploit:get() == 1 and {"ready",indcolor}
        end
        if references.hideshots:get() then
            if references.doubletap:get() then
                self.hs_text = {"blocked",color(255,150,150,255)}
            else
                self.hs_text = rage.exploit:get() == 0 and {"waiting",color(255,150,150,255)} or (rage.exploit:get() > 0 and rage.exploit:get() < 1) and {"charging",color(255-(255-r),rage.exploit:get()*g,rage.exploit:get()*b,255)} or rage.exploit:get() == 1 and {"hiding",indcolor}
            end
        end

        local hotkeys = ui.get_binds()
        local has_mindmg = false
        local has_baim = false
        local has_safe = false
        
        for k, v in pairs(hotkeys) do
            if v.active then
                if v.name == "Min. Damage" then
                    has_mindmg = true
                elseif v.name == "Safe Points" then
                    has_safe = true
                elseif v.name == "Body Aim" then
                    has_baim = true
                end
            end
        end

        local funny_binds = {
            {name = "damage", enabled = menu.visuals.indicators.items:get("damage"), active = has_mindmg, color = color(r, g, b)},
            {name = "baim", enabled = menu.visuals.indicators.items:get("baim"), active = has_baim, color = color(r, g, b)},
            {name = "safe", enabled = menu.visuals.indicators.items:get("safepoint"), active = has_safe, color = color(r, g, b)},
            {name = "freestand", enabled = menu.visuals.indicators.items:get("freestand"), active = references.freestanding:get() or menu.antiaim.manuals:get() == "freestand", color = color(r, g, b)},
            {name = "fakeduck", enabled = menu.visuals.indicators.items:get("fakeduck"), active = references.fakeduck:get(), color = color(r, g, b)},
        }

        local offset = 0

        render.text(1, vector(vars.screensize.x/2,vars.screensize.y/2+15), color(math.clamp(r+30,0,255),math.clamp(g+30,0,255),math.clamp(b+30,0,255),255), "c b", "metaset")
        lerp.lerp("i_doubletap",(references.doubletap:get()and menu.visuals.indicators.items:get("doubletap")) and 1 or 0, 45)
        dt_text_offset = lerp.lerp("smoothdt", render.measure_text(1, "c b", self.dt_text[1]).x,50)
        render.text(1, vector(vars.screensize.x/2-7-dt_text_offset/4,vars.screensize.y/2+25), color(r,g,b,lerp.get("i_doubletap")*255), "c b", "dt")
        render.text(1, vector(vars.screensize.x/2-1+dt_text_offset/4,vars.screensize.y/2+25), color(self.dt_text[2].r,self.dt_text[2].g,self.dt_text[2].b,lerp.get("i_doubletap")*255), "c b", self.dt_text[1])
        offset = offset + lerp.get("i_doubletap") * 10

        lerp.lerp("i_hideshots",(references.hideshots:get() and menu.visuals.indicators.items:get("hideshots")) and 1 or 0, 45)
        hs_text_offset = lerp.lerp("smoothhs", render.measure_text(1, "c b", self.hs_text[1]).x,50)
        render.text(1, vector(vars.screensize.x/2-8-hs_text_offset/4,vars.screensize.y/2+25+lerp.get("i_doubletap")*10), color(r,g,b,lerp.get("i_hideshots")*255), "c b", "hs")
        render.text(1, vector(vars.screensize.x/2-1+hs_text_offset/4,vars.screensize.y/2+25+lerp.get("i_doubletap")*10), color(self.hs_text[2].r,self.hs_text[2].g,self.hs_text[2].b,lerp.get("i_hideshots")*255), "c b", self.hs_text[1])
        offset = offset + lerp.get("i_hideshots") * 10

        for k, v in pairs(funny_binds) do
            self.db[v.name] = tools.animation:new("i_"..v.name, (v.enabled and v.active) and 1 or 0, 45)
            render.text(1, vector(vars.screensize.x / 2,vars.screensize.y/2 + 25 + offset), color(v.color.r, v.color.g, v.color.b, self.db[v.name]*255), "c b", v.name)
            offset = offset + self.db[v.name] * 10
        end
    end,

    animtext = gradient.text_animate("M E T A S E T . C C", -2, {
        color(0, 0, 0, 50), 
        menu.visuals.indicators.color:get() --menu.home.accentcolor:get()
    }),

    render_watermark = function(self)
        if not globals.is_connected or not globals.is_in_game then return end
        local lplr = entity.get_local_player()
        if not lplr or not lplr:is_alive() then return end

        self.animtext:animate()
        render.text(1, vector(screen.size.x / 2, screen.size.y - 10), color(255, 0, 255), "c", self.animtext:get_animated_text())      
    end
}
local logs = {
    db = {},
    table = {},
    amount = 1,
    color = "",
    push_notify = function(self, hit, funny, target)
        local logs_count = 0
        for k, v in pairs(self.table) do
            if v ~= nil then
                logs_count = logs_count + 1
            end
        end
        if menu.misc.logs.screen:get() == "default" then 
            if logs_count > 9 then
                local to_delete = logs_count - 9
                local counter = 0
                for k, v in pairs(self.table) do
                    v.timer = globals.realtime + 0.200 - math.abs(to_delete - counter)
                    counter = counter + 1
                    if counter >= to_delete then
                        break
                    end
                end
            end
        else
            if logs_count > 32 then
                local to_delete = logs_count - 32
                local counter = 0
                for k, v in pairs(self.table) do
                    v.timer = globals.realtime + 0.200 - math.abs(to_delete - counter)
                    counter = counter + 1
                    if counter >= to_delete then
                        break
                    end
                end
            end
        end
        self.table[#self.table + 1] = {string = pui.string(hit), timer = globals.realtime + 5, hello = globals.realtime + 0.2, test = funny, funny = (math.random(0,1000) == 1), target = target and target or false}

        -- for k, v in pairs(self.table) do
        --     print(self.table[k])
        -- end
    end,
    remove_notify = function(self)
        local count = 0
        for k, v in pairs(self.table) do
            count = count + 1
            if v ~= nil then
                v.timer = globals.realtime + 0.200
            end
        end
    end,
    handle = function(self)
        local defaulty = screen.size.y - 50
        local offset = 0
        self.color = menu.misc.logs.color:get()
        for k, v in pairs(self.table) do
            if v ~= nil then
                if menu.misc.logs.types:get("on screen") then
                    if menu.misc.logs.screen:get() == "default" then 
                        if v.timer < globals.realtime then
                            self.table[k] = nil
                        else
                            local alpha = math.clamp(((v.timer - globals.realtime) / 0.200), 0, 1)
                            local text = string.upper(v.string)
                            local startpos = vector(screen.size.x / 2 - render.measure_text(2, "", text).x / 2 - 5, defaulty - offset - 6)
                            render.rect(startpos, startpos + vector(render.measure_text(2, "", text).x + 8, 14), color(0, 0, 0, alpha * 150), 0, true)
                            render.rect(startpos + vector(0, 13), startpos + vector(((v.timer - globals.realtime) / 5) * (render.measure_text(2, "", text).x + 5), 13), color(255, 255, 255, alpha * 150), 0, true)
                            
                            render.text(2, vector(screen.size.x / 2 - render.measure_text(2, "", text).x / 2, defaulty - offset - render.measure_text(2, "", text).y / 2), color(255, 255, 255, alpha * 255), "", text)
                            offset = offset + alpha * 18
                        end
                    else
                        if v.timer < globals.realtime then
                            self.table[k] = nil
                        else
                            --print("JEW")
                            local appear = math.clamp(((v.hello - globals.realtime) / 0.200), 0, 1)
                            local alpha = math.clamp(((v.timer - globals.realtime) / 0.200), 0, 1)
                            local text = string.upper(v.string)
                            local startpos = vector(screen.size.x - render.measure_text(2, "", text).x - (render.measure_text(2, "", text).x * -appear) , screen.size.y / 2 - offset + 100)
                            render.rect(startpos, startpos + vector(render.measure_text(2, "", text).x + 5, 20), color(0, 0, 0, alpha * 150), 0, true)
                            render.rect(startpos + vector(0, 18), startpos + vector(((v.timer - globals.realtime) / 5) * (render.measure_text(2, "", text).x + 5), 20), color(255, 255, 255, alpha * 150), 0, true)
                            if v.funny and v.target == entity.get_local_player() then
                                render.texture(images.xane , startpos - vector(20,0))
                            elseif v.target == false then
                                render.texture(images.default, startpos - vector(20,0), vector(20,20))
                            else
                                render.texture(v.target:get_steam_avatar(), startpos - vector(20,0), vector(20,20))
                            end
                            render.text(2, vector(screen.size.x - render.measure_text(2, "", text).x - (render.measure_text(2, "", text).x * - appear) + 1 , screen.size.y / 2 - offset + 103), color(255, 255, 255, alpha * 255), "", text)

                            offset = offset + alpha * 22
                        end
                    end
                end
            end
        end
    end,
    shot = function(self, shot)
        local id = shot.id
        self.db[id] = {}
        self.db[id].shot_pos = shot.target:get_origin()
        self.db[id].shot_vel = helpers.getvelocity(shot.target)
        self.db[id].shot_tick = globals.tickcount
        local targetwep = shot.target:get_player_weapon()
        if not targetwep then
            self.db[id].onshot = false
        else
            self.db[id].onshot = targetwep.m_fLastShotTime and globals.curtime - targetwep.m_fLastShotTime < 0.5 or false
        end
    end,
    result = function(self, shot)
        pui.colors.logs = self.color

        local id = shot.id
        local lc = false
        local reason = shot.state

        local currentorigin = shot.target:get_origin()
        local lastorigin = self.db[id].shot_pos

        local traveleddistance = (currentorigin - lastorigin):length()
        local predictedvelocity = (self.db[id].shot_vel * vector(globals.tickinterval, globals.tickinterval, globals.tickinterval) * vector(globals.tickcount - self.db[id].shot_tick + 5, globals.tickcount - self.db[id].shot_tick + 5, globals.tickcount - self.db[id].shot_tick + 5)):length()
        
        if (predictedvelocity < traveleddistance and traveleddistance > 10) then
            lc = true
        end

        if reason == "correction" and lc then
            reason = "lagcomp failure"
        end

        if shot.state == nil then
            --shot hit
            if menu.misc.logs.types:get("console") then
                print_meta(string.format("Hit %s(%i%%) in %s(%s) for %i(%i) damage | history(Δ): %i%s%s",
                    shot.target:get_name(),
                    shot.hitchance,
                    hitgroup_str[shot.hitgroup],
                    hitgroup_str[shot.wanted_hitgroup],
                    shot.damage,
                    shot.wanted_damage,
                    shot.backtrack,
                    self.db[id].onshot and " | onshot" or "",
                    lc and " | teleported" or ""
                ))
            end
            if menu.misc.logs.types:get("top left") then
                print_dev(string.format("Hit %s(%i%%) in %s(%s) for %i(%i) damage | history(Δ): %i%s%s",
                    shot.target:get_name(),
                    shot.hitchance,
                    hitgroup_str[shot.hitgroup],
                    hitgroup_str[shot.wanted_hitgroup],
                    shot.damage,
                    shot.wanted_damage,
                    shot.backtrack,
                    self.db[id].onshot and " | onshot" or "",
                    lc and " | teleported" or ""
                ))
            end
            

            self:push_notify(string.format(
                pui.string("Hit\a[logs]  %s \r(%i%%)  in \a[logs] %s  \r(%s)  for \a[logs] %i  \r(%i)  damage"),
                shot.target:get_name(),
                shot.hitchance,
                hitgroup_str[shot.hitgroup],
                hitgroup_str[shot.wanted_hitgroup],
                shot.damage,
                shot.wanted_damage
            ), false, shot.target)
        else
            --shot missed
            
            if menu.misc.logs.types:get("console") then
                print_meta(string.format("Missed %s(%i%%) in %s for %i damage due to %s | history(Δ): %i%s%s",
                    shot.target:get_name(),
                    shot.hitchance,
                    hitgroup_str[shot.wanted_hitgroup],
                    shot.wanted_damage,
                    reason,
                    shot.backtrack,
                    self.db[id].onshot and " | onshot" or "",
                    lc and " | teleported" or ""
                ))
            end
            if menu.misc.logs.types:get("top left") then
                print_dev(string.format("Missed %s(%i%%) in %s for %i damage due to %s | history(Δ): %i%s%s",
                    shot.target:get_name(),
                    shot.hitchance,
                    hitgroup_str[shot.wanted_hitgroup],
                    shot.wanted_damage,
                    reason,
                    shot.backtrack,
                    self.db[id].onshot and " | onshot" or "",
                    lc and " | teleported" or ""
                ))
            end

            self:push_notify(string.format(
                pui.string("Missed \a[logs] %s  \r(%i%%) in \a[logs] %s  \r for \a[logs] %i  \rdamage due to \a[logs] %s"),
                shot.target:get_name(),
                shot.hitchance,
                hitgroup_str[shot.wanted_hitgroup],
                shot.wanted_damage,
                reason
            ), false, shot.target)
        end
    end,
}
local hitmarker = {
    m_hit = false,
    
    fadetime = 1.0,
    _FadeTime = 0.25,
    _WaitTime = 0.25,
    
    hit = function(self, e)
        local lp = entity.get_local_player()
        local attacker = entity.get(e.attacker, true)

        if lp == attacker then
            self.m_hit = true
            self._FadeTime = 0.25
            self._WaitTime = 0.25
            self.fadetime = 1.0
        end
    end,
    spawn = function(self, e)
        local lp = entity.get_local_player()
        local spawned_player = entity.get(e.userid, true)
    
        if lp == spawned_player then
            self._FadeTime = 0.25
            self._WaitTime = 0.50
            self.fadetime = 1.0
            self.m_hit = false
        end
    end,
    draw = function(self)
        if globals.is_in_game == false then return end
        if not menu.visuals.hitmarker:get() then return end
        if self.m_hit then
            local colors = menu.visuals.hitmarker.color:get()
            local ss = render.screen_size()
    
            self._WaitTime = self._WaitTime - globals.frametime
            if self._WaitTime <= 0 then
                self.fadetime  = self.fadetime - ((1 / self._FadeTime) * globals.frametime)
            end
    
            render.line(vector(ss.x/2 - 5, ss.y/2 + 5), vector(ss.x/2 - (10/ss.x) * ss.x, ss.y/2 + (10/ss.y) * ss.y), color(colors.r, colors.g, colors.b, colors.a * self.fadetime))
            render.line(vector(ss.x/2 - 5, ss.y/2 - 5), vector(ss.x/2 - (10/ss.x) * ss.x, ss.y/2 - (10/ss.y) * ss.y), color(colors.r, colors.g, colors.b, colors.a * self.fadetime))
            render.line(vector(ss.x/2 + 5, ss.y/2 - 5), vector(ss.x/2 + (10/ss.x) * ss.x, ss.y/2 - (10/ss.y) * ss.y), color(colors.r, colors.g, colors.b, colors.a * self.fadetime))
            render.line(vector(ss.x/2 + 5, ss.y/2 + 5), vector(ss.x/2 + (10/ss.x) * ss.x, ss.y/2 + (10/ss.y) * ss.y), color(colors.r, colors.g, colors.b, colors.a * self.fadetime))
        end
    end,
    start = function(self)
        self.m_hit = false
        self.fadetime = 1.0
        self._FadeTime = 0.25
        self._WaitTime = 0.25
    end
}
local skeet = {
    render_indicator = function(str, ay, clr, circle_clr, circle_degree, bomb_ic)
        local x, y = render.screen_size().x / 100 + 9, render.screen_size().y / 1.47
        ts = render.measure_text(fonts.gs_font, nil, str)
    
        render.gradient(
            vector(x / 1.9, y + ay),
            vector(x / 1.9 + (ts.x) / 2 + 5, y + ay + ts.y + 11),
            color(0, 0, 0, 0),
            color(0, 0, 0, 50),
            color(0, 0, 0, 0),
            color(0, 0, 0, 50)
        )
        render.gradient(
            vector(x / 1.9 + (ts.x) / 2 + 5, y + ay),
            vector(x / 1.9 + (ts.x) + 40, y + ay + ts.y + 11),
            color(0, 0, 0, 50),
            color(0, 0, 0, 0),
            color(0, 0, 0, 50),
            color(0, 0, 0, 0)
        )
        render.text(fonts.gs_font, vector(x, y + 8 + ay), clr, nil, str)

        if circle_clr and circle_degree then
            render.circle_outline(vector(x + ts.x + 18, y + ay + ts.y / 2 + 8), color(0, 0, 0, 255), 10, 1, 10, 5)
            render.circle_outline(vector(x + ts.x + 18, y + ay + ts.y / 2 + 8), circle_clr, 9, 1, circle_degree, 3)
        end
    end,
    indicators = function(self, ctx)
        if not menu.visuals.gs_indicator:get() then return end
        local player = entity.get_local_player()
        if player == nil then
            return
        end
    
        local timer = 0
        local defused = false
        local damage = 0
        local dmg = 0
        
    
        local adjust_adding = 40
        local add_y = 0
    
        for _, enemy in ipairs(entity.get_players(true)) do
            if enemy == nil then
                fnayf = false
            end
            if enemy ~= nil and enemy:is_enemy() and enemy:is_dormant() then
                fnayf = true
            else
                fnayf = false
            end
        end
    
        local smdmg, fnaychance = false, 0
    
        local binds = ui.get_binds()
        for k, v in pairs(binds) do
            if v.active and v.name == "Min. Damage" then
                smdmg = true
            end
        end
    
        local binds = {
            {
                "PING",
                menu.visuals.gs_indicator.types:get("Fake Ping") and player:is_alive() and
                    ui.find("Miscellaneous", "Main", "Other", "Fake Latency"):get() > 0 and
                    player:is_alive(),
                color(163, 194, 43)
            },
            {
                "BODY",
                menu.visuals.gs_indicator.types:get("Force Baim") and player:is_alive() and refs.baim:get() == "Force",
                color(200, 199, 197)
            },
            {
                "DT",
                menu.visuals.gs_indicator.types:get("Doubletap") and player:is_alive() and
                    ui.find("Aimbot", "Ragebot", "Main", "Double Tap"):get() and
                    not ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get(),
                rage.exploit:get() == 1 and color(200, 199, 197) or color(255, 0, 50)
            },
            {
                "DA",
                menu.visuals.gs_indicator.types:get("Dormant Aimbot") and player:is_alive() and
                    ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"):get(),
                fnayf == true and color(200, 199, 197) or color(255, 0, 50)
            },
            {
                "DUCK",
                menu.visuals.gs_indicator.types:get("Fake Duck") and player:is_alive() and
                    ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get(),
                color(200, 199, 197)
            },
            {
                "MD",
                menu.visuals.gs_indicator.types:get("Minimum Damage") and player:is_alive() and smdmg == true,
                color(200, 199, 197)
            },
            {
                "FS",
                menu.visuals.gs_indicator.types:get("Freestanding") and player:is_alive() and
                    (refs.freestanding:get() or menu.antiaim.manuals:get() == "freestand"),
                color(200, 199, 197)
            },
            {
                "OSAA",
                menu.visuals.gs_indicator.types:get("Hideshots") and player:is_alive() and
                    ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"):get() and
                    not ui.find("Aimbot", "Ragebot", "Main", "Double Tap"):get() and
                    not ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):get(),
                color(200, 199, 197)
            }
        }
    
        for k, v in pairs(binds) do
            if v[2] then
                self.render_indicator(v[1], add_y, v[3], v[4], v[5], v[6])
                add_y = add_y - adjust_adding
            end
        end
    end
}
local vel_warn = {
    anim = {appearing = 0, appearing_alpha = 0},
    handle = function(self)
        if not menu.visuals.warnings.types:get("velocity") then return end
        local lplr = entity.get_local_player()
        if not lplr or not lplr:is_player() or not lplr:is_alive() then return end
        local colors = menu.visuals.warnings.color:get()
        local modifier = lplr.m_flVelocityModifier
        local frametime = globals.frametime
        local menuopen = ui.get_alpha() > 0.5
        self.anim.appearing = tools.lerp(self.anim.appearing, (modifier < 1 or menuopen) and 230 or 180, 0.06 + math.min(frametime/10.1, 0.25))
        self.anim.appearing_alpha = tools.lerp(self.anim.appearing_alpha, (modifier < 1 or menuopen) and 255 or 0, 0.06 + math.min(frametime/10.1, 0.25))
        local startpos = vector(screen.size.x / 2 - 60, math.floor(self.anim.appearing))

        render.rect(vector(screen.size.x / 2 - 60, math.floor(self.anim.appearing)), vector(screen.size.x / 2 - 60, math.floor(self.anim.appearing)) + vector(120, 6), color(0,0,0, math.min(math.floor(self.anim.appearing_alpha), 200)))
        render.rect(vector(screen.size.x / 2 - 58, math.floor(self.anim.appearing + 2)), vector(screen.size.x / 2 - 58, math.floor(self.anim.appearing + 2)) + vector(116 * modifier, 2), color(colors.r,colors.g,colors.b, math.floor(self.anim.appearing_alpha)))

        render.text(1, vector(screen.size.x / 2, math.floor(self.anim.appearing) - 7), color(255, 255, 255, math.floor(self.anim.appearing_alpha)), "c", string.format("- slow: %i%s -", math.abs(modifier * 100 + 100 * -1), "%"))
    end
}
local def_warn = {
    anim = {appearing_alpha = 0},
    handle = function(self)
        if not menu.visuals.warnings.types:get("defensive") then return end
        local lplr = entity.get_local_player()
        if not lplr or not lplr:is_player() or not lplr:is_alive() then return end
        local colors = menu.visuals.warnings.color:get()
        local modifier = lplr.m_flVelocityModifier
        local frametime = globals.frametime
        local menuopen = ui.get_alpha() > 0.1
        local defensivetable = defensive:is_active(lplr, true, true)
        local is_defe = defensivetable.tick - globals.tickcount > 1
        self.anim.appearing_alpha = tools.lerp(self.anim.appearing_alpha, (is_defe or menuopen) and 255 or 0, 0.06 + math.min(frametime/10.1, 0.25))

        render.rect(vector(screen.size.x / 2 - 60, 249), vector(screen.size.x / 2 - 60, 249) + vector(120, 6), color(0,0,0, math.min(math.floor(self.anim.appearing_alpha), 200)))
        render.rect(vector(screen.size.x / 2 - 58, 251), vector(screen.size.x / 2 - 58, 251) + vector(116 + (defensivetable.tick - globals.tickcount > 1 and ((defensivetable.tick - globals.tickcount) / 12) * -112 or 0), 2), color(colors.r,colors.g,colors.b, math.floor(self.anim.appearing_alpha)), 0, true)

        render.text(1, vector(screen.size.x / 2, 249 - 7), color(255, 255, 255, math.floor(self.anim.appearing_alpha)), "c", string.format("- defensive -", math.abs(modifier * 100 + 100 * -1), "%"))
    end
}
local clantag = {
    timing = 40,
    tag = {
        "",
        "m",
        "me",
        "met",
        "meta",
        "metas",
        "metase",
        "metaset",
        "metaset.",
        "metaset.c",
        "metaset.cc",
        "metaset.cc",
        "metaset.cc",
        "metaset.c",
        "metaset.",
        "metaset",
        "metase",
        "metas",
        "meta",
        "met",
        "me",
        "m",
        "",
    },
    last = nil,
    reset = 0,
    get = function(self)
        local local_player = entity.get_local_player()
        if not local_player then
            return
        end
        local latency = utils.net_channel().latency[0] / globals.tickinterval
        local tickcount_pred = globals.tickcount + latency
        local iter = math.floor(math.fmod(tickcount_pred / self.timing, #self.tag + 1) + 1)
        return self.tag[iter]
    end,
    set = function(self, tag)
        if not globals.is_connected or not globals.is_in_game then return end
        if tag == self.last then
            return
        end
        if tag == nil then
            return
        end
        common.set_clan_tag(tag)
        self.last = tag
    end,
    handle = function(self)
        if not globals.is_connected or not globals.is_in_game then
            return
        end
        local lplr = entity.get_local_player()
        if not lplr then
            return
        end
        if menu.misc.clantag:get() then
            self:set(self:get())
            self.reset = 0
        else
            if self.reset < 1 then
                self:set(" ")
                self.reset = self.reset + 1
            end
        end
    end
}
local animbreakers = {
    breaker = function()
        local lplr = entity.get_local_player()
        if not lplr then
            return
        end
        if not lplr:is_alive() then
            return
        end
        if not tools.get_anim_layer(get_entity_address(entity.get_local_player():get_index()), 12) then
            return
        end

        if not menu.misc.animation:get() then return end
    
        local tick = globals.client_tick % 4 > 1
        if menu.misc.animation.ground:get() == "jitter" then
            lplr.m_flPoseParameter[E_POSE_PARAMETERS.STRAFE_YAW] = tick and 1 or 0.7
            refs.legmovement:set("Sliding")
        elseif menu.misc.animation.ground:get() == "skeet" then
            refs.legmovement:override("Sliding")
            lplr.m_flPoseParameter[E_POSE_PARAMETERS.STRAFE_YAW] = 1
        elseif menu.misc.animation.ground:get() == "moonwalk" then
            refs.legmovement:override("Walking")
            lplr.m_flPoseParameter[E_POSE_PARAMETERS.STAND] = 0
            lplr.m_flPoseParameter[E_POSE_PARAMETERS.MOVE_YAW] = 1
        end
    
        if menu.misc.animation.slide:get("run") then
            refs.legmovement:override("Sliding")
            lplr.m_flPoseParameter[E_POSE_PARAMETERS.MOVE_BLEND_RUN] = 0
        end
        if menu.misc.animation.slide:get("walk") then
            refs.legmovement:override("Sliding")
            lplr.m_flPoseParameter[E_POSE_PARAMETERS.MOVE_BLEND_WALK] = 0
        end
        if menu.misc.animation.slide:get("crouch") then
            refs.legmovement:override("Sliding")
            lplr.m_flPoseParameter[E_POSE_PARAMETERS.MOVE_BLEND_CROUCH] = 0
            lplr.m_flPoseParameter[E_POSE_PARAMETERS.STAND] = tick and 0.5 or 1
        end

        if menu.misc.animation.air:get() == "static" then
            lplr.m_flPoseParameter[E_POSE_PARAMETERS.JUMP_FALL] = 1
        elseif menu.misc.animation.air:get() == "autistic" then
            if bit.band(entity.get_local_player().m_fFlags, bit.lshift(1, 0)) == 0 and
                    entity.get_local_player().m_vecVelocity:length2d() > 2
                then
                tools.get_anim_layer(get_entity_address(entity.get_local_player():get_index()), 6).m_weight = 1
            end
        end
        if entity.get_local_player().m_vecVelocity:length2d() > 2 then
            ffi.cast('C_AnimationLayer**', ffi.cast('uintptr_t', get_entity_address(lplr:get_index())) + 0x2990)[0][12].m_weight = menu.misc.animation.lean:get() / 100
            --lplr.m_flPoseParameter[E_POSE_PARAMETERS.STRAFE_YAW] = menu.misc.animation.lean:get() / 5
            entity.get_local_player().m_flModelScale = 1
            entity.get_local_player().m_ScaleType = 0
        end 
    end,
    legs = function(cmd)
        if menu.misc.animation.ground:get() == "Jitter" then
            refs.legmovement:override(cmd.command_number % 3 == 0 and "Default" or "Sliding")
        end
    end
}
local transparency = {
    nadestable = {
        "hegrenade",
        "smokegrenade",
        "incgrenade",
        "molotov"
    },
    model = function(self, ctx)
        if not menu.misc.model:get() then return end
        local lp = entity.get_local_player()
        if not lp then return end

        local weapon = lp:get_player_weapon()
        if not weapon then return end

        local weapon_info = weapon:get_weapon_info()
        if not weapon_info then return end

        if menu.misc.model.types:get("Scoped") and lp.m_bIsScoped then 
            return menu.misc.model.scope:get()
        end
        if menu.misc.model.types:get("On Nade") then
            for i = 1, #self.nadestable do
                if weapon_info.weapon_name == "weapon_"..self.nadestable[i] then
                    return menu.misc.model.nade:get()
                end
            end
        end
    end,
}
local trashtalk = {
    phrases = {
        "1",
        "sit down",
        "nn down",
        "kys faggot",
        "bombed like the kremlin",
        "know your place you fucking troglodyte",
        "200",
        "1 nn",
        "1 fucking fag",
        "hdf hurensohn",
        "1 hurensohn",
        "cf?",
        "dead by metaset nn",
        "why u *dead*?",
        "what happened?",
        "raped",
        "Banned: posted cp (Ends: Jan 07, 2025)",
        "no metaset?",
        "ur shit",
        "ur shit faggot",
        "stfu",
        "deepfried by metaset",
        "fantastic steeringwheel assistance",
        "crazy 1",
        "insane computer",
        "send selly link for that sick imaginary girlfriend",
        "interesting uid issue",
        "LOL that 1","LOL that antiaim",
        "send selly link for that sick osiris",
        "u pay for that kd?","nice fucking gamesense",
        "nice visuals",
        "cant tell if you are serious about that negative iq",
        "laughing my ass off that death",
        "breathtaking skeet",
        "crazy visuals",
        "insane resolver",
        "cool lagswitch",
        "awesome gaming carpet",
        "refund that gaming chair",
        "u pay for that resolver?",
        "ahaha that gaming carpet",
        "insane imaginary girlfriend",
        "you pay for that antiaim?",
        "lidl uid issue",
        "cough cough",
        "LOL that cheat",
        "good knifechanger",
        "haahahah that keybind",
        "-1 iq"
    },
    he_phrases = {
        "bombed like the kremlin",
        "bomboclat",
        "kobe",
        "get icbmd",
        "you talking mad shit for someone in icmbing distance",
        "BOMBOCLAAAT",
        "airstriked",
        "get arabed"
    },
    fire_phrases = {
        "deepfried",
        "fried by metaset",
        "burn jew",
        "burned jew",
        "Murr hurr mphuphurrur, hurr mph phrr.",
        "go burn"
    },
    blind_phrases = {
        "Think fast chucklenuts",
        "HE'S PULLING HIS COCK OUT, HE'S PULLING HIS COCK OUT"
    },
    friendly_phrases = {
        "IT WAS A MISINPUT, MISINPUT, CALM DOWN, YOU CALM THE FUCK DOWN",
        "misclick"
    },
    random = function(self, mode)
        if not mode then
            mode = 0
        end
        local temptable = mode == "nade" and self.he_phrases or mode == "molly" and self.fire_phrases or mode == "blind" and self.blind_phrases or self.phrases
        return temptable[utils.random_int(1, #temptable)]:gsub('"', "")
    end,
    blind = function(self, e)
        local lp = entity.get_local_player()
        if lp == nil or lp:is_alive() == false then
            return
        end

        local attacker = entity.get(e.userid, true)
    
        if menu.misc.trashtalk:get() then
            if lp == attacker and e.weapon == "flashbang" then
                utils.console_exec('say "' .. self:random("blind") .. '"')
            end
        end
    end,
    killsay = function(self, e)
        local lp = entity.get_local_player()
        if lp == nil or lp:is_alive() == false then
            return
        end
    
        local attacker = entity.get(e.attacker, true)
    
        if menu.misc.trashtalk:get() then
            if lp == attacker then
                if e.weapon == "hegrenade" then
                    utils.console_exec('say "' .. self:random("nade") .. '"')
                elseif e.weapon == "inferno" then
                    utils.console_exec('say "' .. self:random("molly") .. '"')
                else
                    utils.console_exec('say "' .. self:random() .. '"')
                end
            end
        end
    end
}
local avoid_collisions = {
    vector = function(angle_x, angle_y)
        local sp, sy, cp, cy = nil
        sp = math.sin(math.rad(angle_x));
        sy = math.sin(math.rad(angle_y));
        cp = math.cos(math.rad(angle_x));
        cy = math.cos(math.rad(angle_y));
        return vector(cp * cy, cp * sy, -sp);
    end,
    
    velocity = function(player)
        if(player == nil) then return end
        local vec = player.m_vecVelocity
        local velocity = vec:length()
        return velocity
    end,
    
    handle = function(self, cmd)
        local lp = entity.get_local_player()
        if not lp then return end
        if not menu.misc.walls:get() then return end
    
        local dm = menu.misc.walls.distance:get() 
        local camera_angles = render.camera_angles()
        local yaw = camera_angles.y
        local l = lp.m_vecOrigin
        local min = math.huge
        local val = math.huge
        
        for i = 1, 180 do
            local dir_x, dir_y, dir_z = self.vector(0, (yaw + i - 90)).x, self.vector(0, (yaw + i - 90)).y, self.vector(0, (yaw)).z
            local end_x, end_y, end_z = l.x + dir_x * 70, l.y + dir_y * 70, l.z + 60
            local tracer = utils.trace_line(l, vector(end_x, end_y, end_z), nil, nil, 1)
            if(l:dist(tracer.end_pos) < min) then
                min = l:dist(tracer.end_pos)
                val = i
            end
        end
    
        if(min < 25 + dm and cmd.in_jump and not (cmd.in_moveright or cmd.in_moveleft or cmd.in_back)) then
            forward_velo = math.abs(self.velocity(lp) * math.cos(math.rad(val)))
            if(math.abs(val-90) < 40) then
                side_velo = self.velocity(lp) * math.sin(math.rad(val)) * (25 + dm - min) / 15
            else
                side_velo = self.velocity(lp) * math.sin(math.rad(val))
            end
            cmd.forwardmove = forward_velo
            if(val >= 90) then
                cmd.sidemove = side_velo
            else
                cmd.sidemove = side_velo * -1
            end
        end
    end
}
local nade_fix = {
    menu = function()
        if menu.misc.nadefix:get() then
            refs.actions:override(refs.actions:get("Auto Pistols") and "Auto Pistols" or "")
        else
            refs.actions:override()
        end
    end,
    throwing = function(e)
        local ent = entity.get(e.userid, true)
        local me = entity.get_local_player()
        if me == ent then
            utils.console_exec("slot2")
            utils.console_exec("slot1")
        end
    end
}
local damage = {
    scale = {
        stomach = 1.25,
        chest = 1,
        head = 4,
        arms = 0.75,
        legs = 0.75,
    },
    calculate = function(self, start, enemy, hitbox)
        if not start then return 0 end
        local weaponidk = start:get_player_weapon()
        if not weaponidk then return 0 end
        local weapon = start:get_player_weapon():get_weapon_info()
        if not weapon then return 0 end
        local local_origin = start.m_vecAbsOrigin
        local distance = local_origin:dist(enemy.m_vecAbsOrigin)
        local weapon_adjust = weapon.damage
        local dmg_after_range = (weapon_adjust * math.pow(weapon.range_modifier, (distance * 0.002)))
        local armor = enemy.m_ArmorValue
        local newdmg = dmg_after_range * (weapon.armor_ratio * 0.5)
        if dmg_after_range - (dmg_after_range * (weapon.armor_ratio * 0.5)) * 0.5 > armor then
            newdmg = dmg_after_range - (armor / 0.5)
        end
        local enemy_health = enemy.m_iHealth
        -- local newdmg_indi = newdmg * 1.25

        return newdmg * self.scale[hitbox]
    end,
}
local ragebot = {
    is_revving = false,  --revvin my wife tonight
    is_baiming = false,
    baiming_value = " ",
    is_saving = false,
    js_hc = false,
    js_type = 0,
    zeus_fixing = false,
    smart_baim = function(self)
        refs.baim:override()
        self.is_baiming = false
        self.baiming_value = " "
        if not menu.helpers.smartbody:get() then return end
        local lplr = entity.get_local_player()
        if not lplr or not lplr:is_alive() then return end
        local weapon = lplr:get_player_weapon()
        if not weapon then return end
        local weapon_info = weapon:get_weapon_info()
        if weapon_info.weapon_type == 0 then return end
        local threat = entity.get_threat(true) or entity.get_threat()
        if not threat then return end
        if threat:is_dormant() then return end
        local health = threat.m_iHealth
        local damage_stomach = damage:calculate(lplr, threat, "stomach")
        local damage_chest = damage:calculate(lplr, threat, "chest")
        local damage_legs = damage:calculate(lplr, threat, "legs")

        if damage_legs > health then
            refs.baim:override("Force")
            self.is_baiming = true
            self.baiming_value = "Force"
        elseif damage_chest > health then
            refs.baim:override("Prefer")
            self.is_baiming = true
            self.baiming_value = "Prefer"
        elseif damage_stomach > health then
            refs.baim:override("Prefer")
            self.is_baiming = true
            self.baiming_value = "Prefer"
        end
    end,
    smart_safe = function(self)
        refs.safe:override()
        self.is_saving = false
        if not menu.helpers.smartsafe:get() then return end
        local lplr = entity.get_local_player()
        if not lplr or not lplr:is_alive() then return end
        local threat = entity.get_threat(true) or entity.get_threat()
        if not threat then return end
        local targetwep = threat:get_player_weapon()
        if not targetwep then return end
        local weapon = lplr:get_player_weapon()
        if not weapon then return end
        local weapon_info = weapon:get_weapon_info()
        if weapon_info.weapon_type == 0 then return end

        local health = threat.m_iHealth
        local threatpos = threat:get_origin()
        local localpos = lplr:get_origin()
        

        local damage_stomach = damage:calculate(lplr, threat, "stomach")
        local onshot = targetwep.m_fLastShotTime and globals.curtime - targetwep.m_fLastShotTime < 0.5 or false
        local nade = targetwep:get_weapon_info().weapon_type == 8
        local height = localpos.z - threatpos.z > 47

        if damage_stomach > health and menu.helpers.smartsafe.mode:get("lethal") then
            refs.safe:override(menu.helpers.smartsafe.mode:get())
            self.is_saving = true
        elseif onshot and menu.helpers.smartsafe.mode:get("onshot") then
            refs.safe:override(menu.helpers.smartsafe.mode:get())
            self.is_saving = true
        elseif nade and menu.helpers.smartsafe.mode:get("holding name") then
            refs.safe:override(menu.helpers.smartsafe.mode:get())
            self.is_saving = true
        elseif height and menu.helpers.smartsafe.mode:get("height advantage") then
            refs.safe:override(menu.helpers.smartsafe.mode:get())
            self.is_saving = true
        end
    end,
    airstop = function(self)
        refs.autostop_scout:override()
        refs.hitchance_scout:override()
        self.js_hc = false
        self.js_type = 0
        if not menu.helpers.smartjump:get() then return end

        local funnies = refs.autostop_scout:get()
        local funny_index = 0
        for i = 1, #funnies do
            if funnies[i] == "In Air" then
                funny_index = i
                break
            end
        end
        table.remove(funnies, funny_index)

        refs.autostop_scout:override({table.unpack(refs.autostop_scout:get()), "In Air"})
        local lplr = entity.get_local_player()
        if not lplr or not lplr:is_alive() then return end
        local threat = entity.get_threat(true) or entity.get_threat()
        if not threat or threat:is_dormant() then return end
        local flags = lplr.m_fFlags
        local airborne = bit.band(flags, bit.lshift(1, 0)) == 0
        local distance = (lplr:get_origin() - threat:get_origin()):length2d()
        local velocity = lplr.m_vecVelocity:length2d()
        local hitchance = 0
        if (100 - (distance / 100) * 5) > 0 then 
            hitchance = math.floor(100 - ((distance / 100) * 5))
        else
            hitchance = 40
        end
        -- print_dev(velocity)
        local shall_override = false

        if menu.helpers.smartjump.options:get("limit distance") then
            if distance > menu.helpers.smartjump.distance:get() then
                shall_override = true
            end
        end
        if menu.helpers.smartjump.options:get("limit velocity") then
            if velocity > menu.helpers.smartjump.velocity:get() then
                shall_override = true
            end
        end

        if menu.helpers.smartjump.options:get("adaptive hitchance") and airborne then
            refs.hitchance_scout:override(hitchance)
            self.js_type = 2
            self.js_hc = hitchance
        end

        if shall_override then
            refs.autostop_scout:override(funnies)
            self.js_type = 1
        end
    end,
    zeus_fix = function(self)
        refs.hitchance_zeus:override()
        self.zeus_fixing = false
        if not menu.helpers.customzeus:get() then return end
        local lplr = entity.get_local_player()
        if not lplr or not lplr:is_alive() then return end
        local threat = entity.get_threat(true) or entity.get_threat()
        if not threat then return end
        local weapon = lplr:get_player_weapon()
        if not weapon then return end
        local weapon_info = weapon:get_weapon_info()
        local inaccuracy = weapon:get_inaccuracy()
        local hc = inaccuracy / 1000
        if not threat:get_origin() then return end
        local dist = (lplr:get_origin() - threat:get_origin()):length2d()      
        if not (weapon_info.weapon_name == "weapon_taser") then return end
        if (hc < 0.00015 and dist < 130) then
            refs.hitchance_zeus:override(25)
            self.zeus_fixing = true
            -- print(1)
            -- print_dev(1)
        elseif (hc < 0.0001) then
            refs.hitchance_zeus:override(10)
            self.zeus_fixing = true
            -- print(2)
            -- print_dev(2)
        else
            -- print(0)
            -- print_dev(0)
        end
    end,
    revo_fix = function(self)
        refs.hslag:override()
        self.is_revving = false
        local lplr = entity.get_local_player()
        if not lplr then return end
        local weapon = lplr:get_player_weapon()
        if not weapon then return end
        local weapon_info = weapon:get_weapon_info()
        if weapon_info.is_revolver and menu.helpers.fixrevo:get() then
            refs.hslag:override("Favor Fake Lag")
            self.is_revving = true
        end
    end,
    inbicators = function(self)
        if not menu.helpers.indicators:get() then return end
        if not (menu.helpers.indicators.on_peek:get() and entity.get_threat(true) or entity.get_threat()) then return end
        local offset = 0

        if self.is_revving and menu.helpers.indicators.options:get("revo") then -- sir why is it not dragable :angry:
            render.text(2, vector(screen.size.x / 2 + 5, screen.size.y / 2 - 100 - offset * 10), refs.hideshots:get() and color(255, 255, 255) or menu.accent.color:get(), "", ("revolver"):upper())
            offset = offset + 1
        end
        if self.zeus_fixing and menu.helpers.indicators.options:get("zeus") then -- sir why is it not dragable :angry:
            render.text(2, vector(screen.size.x / 2 + 5, screen.size.y / 2 - 100 - offset * 10), color(255, 255, 255), "", ("zeus"):upper())
            offset = offset + 1
        end
        if self.is_baiming and menu.helpers.indicators.options:get("baim") then -- sir why is it not dragable :angry:
            render.text(2, vector(screen.size.x / 2 + 5, screen.size.y / 2 - 100 - offset * 10),  color(255, 255, 255), "", ("baim: ".. tostring(self.baiming_value) ):upper())
            offset = offset + 1
        end
        if self.is_saving and menu.helpers.indicators.options:get("safe") then -- sir why is it not dragable :angry:
            render.text(2, vector(screen.size.x / 2 + 5, screen.size.y / 2 - 100 - offset * 10),  color(255, 255, 255), "", ("safe"):upper())
            offset = offset + 1
        end
        if self.js_type ~= 0 and menu.helpers.indicators.options:get("jumpscout hitchance") then -- sir why is it not dragable :angry:
            render.text(2, vector(screen.size.x / 2 + 5, screen.size.y / 2 - 100 - offset * 10),  color(255, 255, 255), "", ((self.js_type == 1) and ("jump") or ("jump hc: " .. tostring(self.js_hc))):upper())
            offset = offset + 1
        end
    end
}
local custom_ui = {
    wep_switched = false,
    last_wep = false,
    switch_time = 0,
    switch_end = 0,
    switch_time_scale = 0,
    main = render.load_font("Segoe UI Black", 35, " a"),
    render_inventory = function(self)
        if not menu.visuals.custom_ui:get() then return end 
        local colors = menu.visuals.custom_ui.color:get()
        local lplr = entity.get_local_player()
        if not lplr or not lplr:is_alive() then return end
        local inventory = lplr:get_player_weapon(true)
        local weapon = lplr:get_player_weapon()
        
        -- local

        local finaltable = {}

        local type_enum = {
            [0] = {"KNIFE", 3},
            {"PISTOL", 2},
            {"SMG", 1},
            {"RIFLE", 1},
            {"SHOTGUN", 1},
            {"SNIPER", 1},
            {"MACHINE_GUN", 1},
            {"C4", 6},
            {"GRENADE", 4},
            {"EQUIPMENT", 5},
            {"STACKABLE_ITEM", 7}
        }

        local nade_priority = {
            weapon_hegrenade = 1,
            weapon_flashbang = 2,
            weapon_smokegrenade = 3,
            weapon_decoy = 4,
            weapon_molotov = 5,
            weapon_incgrenade = 5,
        }

        for i = 1, #inventory do
            local data = {data = inventory[i], type = inventory[i]:get_weapon_info().weapon_type, priority = type_enum[inventory[i]:get_weapon_info().weapon_type][2], name = inventory[i]:get_weapon_info().weapon_name, selected = inventory[i]:get_weapon_info().weapon_name == weapon:get_weapon_info().weapon_name}
            local done = false
            if not finaltable[1] then
                table.insert(finaltable, 1, data)
                done = true
            end
            for j = 1, #finaltable do
                if not finaltable[j] then
                    table.insert(finaltable, j, data)
                    done = true
                else
                    if (inventory[i]:get_weapon_info().weapon_type == 9) and (finaltable[j].type == 9) then
                        if nade_priority[inventory[i]:get_weapon_info().weapon_name] < nade_priority[finaltable[j].data:get_weapon_info().weapon_name] then
                            table.insert(finaltable, j, data)
                            done = true
                            break
                        end
                    else
                        if finaltable[j].priority > type_enum[inventory[i]:get_weapon_info().weapon_type][2] then
                            table.insert(finaltable, j, data)
                            done = true
                            break
                        end
                    end
                end
            end
            if not done then finaltable[#finaltable+1] = data end
        end

        local offsets = {

        }

        local offsetnum = 0

        for k, v in pairs(offsets) do
            offsetnum = offsetnum + 1
        end
        local can_shoot = false
        local next_shoot = 0
        local simtime = globals.curtime
        if weapon:get_weapon_info().is_revolver then -- for some reason can_shoot returns always false with r8 despite all 3 props being true, no idea why
            can_shoot = simtime > math.max(lplr.m_flNextAttack, weapon.m_flNextPrimaryAttack, weapon.m_flNextSecondaryAttack) -- doing this fixes it ><
            next_shoot = weapon.m_flNextPrimaryAttack
        else
            can_shoot = simtime > math.max(lplr.m_flNextAttack, weapon.m_flNextPrimaryAttack, weapon.m_flNextSecondaryAttack)
            next_shoot = math.max(lplr.m_flNextAttack, weapon.m_flNextPrimaryAttack, weapon.m_flNextSecondaryAttack)
        end
        if self.last_wep == weapon:get_weapon_info().weapon_name then

        else--[[if not self.wep_switched then]]
            self.wep_switched = true
            self.switch_time = next_shoot - simtime
            self.switch_time = next_shoot - simtime
            self.switch_end = next_shoot
        end


        

        if self.wep_switched then
            self.switch_time_scale = math.clamp((next_shoot - simtime) * self.switch_time, 0, 1)
        end

        if can_shoot or simtime > next_shoot or simtime > self.switch_end then
            self.wep_switched = false
        end

        for k,v in pairs(finaltable) do
            local sc = tools.animation:new(v.name.."_selected", v.selected and 50 or 0, 10)
            -- if finaltable[k-1] and v.priority == finaltable[k-1].priority then
            --     offsets[v.priority] = offsets[v.priority] and offsets[v.priority] + 1 or 1
            --     render.rect(vector(screen.size.x - v.data:get_weapon_icon().width - 30, screen.size.y - (50 * k)- 60), vector(screen.size.x, screen.size.y -  (50 * k)- 15), color(sc, sc, sc, 150))
            --     render.texture(v.data:get_weapon_icon(), vector(screen.size.x - 15 - v.data:get_weapon_icon().width, screen.size.y - (50 * k) -50), colors)
            -- else
                render.rect(vector(screen.size.x - v.data:get_weapon_icon().width - 30, screen.size.y - (50 * k) - 60), vector(screen.size.x, screen.size.y -  (50 * k) - 15), color(sc, sc, sc, 150))
                if v.selected then
                    render.rect(vector(screen.size.x - v.data:get_weapon_icon().width - 30, screen.size.y - (50 * k) - 17), vector(screen.size.x - (self.wep_switched and (v.data:get_weapon_icon().width - 30) * 2 * self.switch_time_scale or 0), screen.size.y - (50 * k) - 15), colors)
                end
                render.texture(v.data:get_weapon_icon(), vector(screen.size.x - 15 - v.data:get_weapon_icon().width, screen.size.y - (50 * k) -50), colors)
            -- end
        end


        -- print_dev(self.wep_switched, string.format("%2f", self.switch_time_scale))
        -- print_dev(self.switch_time)
        self.last_wep = weapon:get_weapon_info().weapon_name
    end,
    render_hp = function(self)
        if not menu.visuals.custom_ui:get() then return end 
        local colors = menu.visuals.custom_ui.color:get()
        local lplr = entity.get_local_player()
        if not lplr or not lplr:is_alive() then return end 
        local health = lplr.m_iHealth
        local armor = lplr.m_ArmorValue
        
        -- health
        render.rect(vector(0, screen.size.y - 50), vector(150, screen.size.y - 10), color(0, 0, 0, 150))
        render.rect(vector(0, screen.size.y - 12), vector(150 * (health / 100), screen.size.y - 10), colors)
        render.text(self.main, vector(2, screen.size.y - 49), colors, "", "Health: " .. tostring(health))
        
        render.rect(vector(160, screen.size.y - 50), vector(270, screen.size.y - 10), color(0, 0, 0, 150))
        render.rect(vector(160, screen.size.y - 12), vector(270, screen.size.y - 10), colors)
        render.text(self.main, vector(162, screen.size.y - 49), colors, "", "Kev: " .. tostring(armor))
        --render.text(self.main,vector(screen.size.x - 245, screen.size.y - 36), color(255,255,255,255), "", tostring(health))
    end,
}
local stealer = {
    tasks = {},
    taskrecord = {},
    common = {},
    idx = 0,
    state = "",
    state_num = "",
    player_list = {},
    progress = 0,
    status = "idle",
    final_left = 0,
    final_right = 0,
    maxvalue = function(table)
        local max = nil
        for key, value in pairs(table) do
            if max == nil or value > max then
                max = value
                maxkey = key
                -- print(key.."."..value)
            end
        end
        return maxkey
    end,
    angle_diff = function(dest, src)
        local delta = 0.0
        delta = math.fmod(dest - src, 360.0)
        if dest > src then
            if delta >= 180 then delta = delta - 360 end
        else
            if delta <= -180 then delta = delta + 360 end
        end
        return delta
    end,
    yawto180 = function(yawbruto)
        if yawbruto > 180 then
            return yawbruto - 360;
        end
        return yawbruto;
    end,
    yaw_to_player = function(self, player, forward)
        local LocalPlayer = entity.get_local_player()
        if not LocalPlayer or not player then return 0 end
    
        local lOrigin = LocalPlayer:get_origin()
        local ViewAngles = render.camera_angles()
        local pOrigin = player:get_origin()
        --local vel = get_vector_prop(idx, "")
        local Yaw = (-math.atan2(pOrigin.x - lOrigin.x, pOrigin.y - lOrigin.y) / 3.14 * 180 + 180) - (forward and 90 or -90)-- - ViewAngles.y +(forward and 0 or -180)
        if Yaw >= 180 then
            Yaw = 360 - Yaw
            Yaw = -Yaw
        end
        Yaw = self.yawto180(Yaw)
        return Yaw
    end,
    check_state = function(self, ent)
        local m_vecVelocity = ent.m_vecVelocity
        local velocity = m_vecVelocity:length2d()
        local flags = ent.m_fFlags
        local ducking = bit.lshift(1, 1)
        local ground = bit.lshift(1, 0)
        local state = ""
        local statenum = 0
    
    
        if bit.band(flags, ground) == 1 and velocity > 3 and bit.band(flags, ducking) == 0 then
            state = "move"
            statenum = 4
        elseif bit.band(flags, ground) == 0 and bit.band(flags, ducking) == 0 then
            state = "air"
            statenum = 7
        elseif bit.band(flags, ground) == 0 then
            state = "air+c"
            statenum = 8
        elseif bit.band(flags, ground) == 1 and velocity < 3 and bit.band(flags, ducking) == 0 then
            state = "stand"
            statenum = 2
        elseif bit.band(flags, ground) == 1 and bit.band(flags, ducking) > 0.9 then
            state = "duck"
            statenum = 5
        end
        return {string = state, number = statenum} 
    end,
    handle_tasks = function(self)
        if self.tasks == nil then return end
        for k, v in pairs(self.tasks) do
            if type(v) == "table" then
                if globals.tickcount >= v.endtime + 2 then
                    -- print(self.maxvalue(self.taskrecord[v.idx].right) .. " right | left " .. self.maxvalue(self.taskrecord[v.idx].left))
                    -- print("request ended")
                    self.tasks[k] = nil
                    self.status = "idle"
                    self.progress = 100
                    self.final_left = self.maxvalue(self.taskrecord[v.idx].left)
                    self.final_right = self.maxvalue(self.taskrecord[v.idx].right)
                    menu.antiaim.stealer.result:name(self.maxvalue(self.taskrecord[v.idx].left) .. " left | right " .. self.maxvalue(self.taskrecord[v.idx].right))
                    self.taskrecord[v.idx].right = {}
                    self.taskrecord[v.idx].left = {}
                    menu.antiaim.stealer.result:visibility(true)
                    menu.antiaim.stealer.confirm:visibility(true)
                    break
                else
                    local ent = entity.get(v.idx)
                    local eyeyaw = ent.m_angEyeAngles.y
                    local eyepitch = ent.m_angEyeAngles.z
                    local enemy_shit = self:yaw_to_player(ent, true)
                    local offset = self.angle_diff(math.floor(eyeyaw), math.floor(enemy_shit))  
                    local state = self:check_state(ent)
                    self.taskrecord[v.idx] = self.taskrecord[v.idx] and self.taskrecord[v.idx] or {}
                    if ent:is_dormant() then
                        self.status = "target dormant"
                        menu.antiaim.stealer.result:visibility(true)
                        menu.antiaim.stealer.result:name("\aFF0000FF" .. self.status)
                        v.endtime = v.endtime + 1
                        goto skiprecord
                    end
                    if self.state ~= state.string then
                        self.status = "waiting for state state"
                        menu.antiaim.stealer.result:visibility(true)
                        menu.antiaim.stealer.result:name("\aFF0000FF" .. self.status)
                        v.endtime = v.endtime + 1
                        goto skiprecord
                    else
                        self.state_num = state.number
                    end
                    if offset < -140 or offset > 140 then
                        local lplr = entity.get_local_player()
                        if not lplr:is_alive() then return end
                        local weapon = lplr:get_player_weapon()
                        if not weapon then return end
                        local weapon_class = weapon:get_weapon_info()
                        if weapon_class.weapon_name == "weapon_knife" then 
                            self.status = "anti backstab detected"
                            menu.antiaim.stealer.result:visibility(true)
                            menu.antiaim.stealer.result:name("\aFF0000FF" .. self.status)
                            v.endtime = v.endtime + 1
                            goto skiprecord
                        end
                    end
                    if not self.taskrecord[v.idx].old_yaw then
                        self.taskrecord[v.idx].old_yaw = offset
                        goto skiprecord
                    end
                    if math.abs(math.abs(self.taskrecord[v.idx].old_yaw) - math.abs(offset)) < 5 then
                        if  offset > 90 or offset < -90 then
                            self.status = "waiting for at target"
                            menu.antiaim.stealer.result:visibility(true)
                            menu.antiaim.stealer.result:name("\aFF0000FF" .. self.status)
                            v.endtime = v.endtime + 1
                            goto skiprecord
                        end
                    end
                    local diff = self.taskrecord[v.idx].old_yaw - offset
                    local def_1 = defensive:is_active(ent) == true and eyepitch < 79  
                    local def_2 = defensive:is_active(ent) and offset > 80
                    local def_3 = defensive:is_active(ent) and offset < -80
                    local right = 0
                    local left = 0
                    local defensive = def_1 or def_2 or def_3
                    self.taskrecord[v.idx].old_yaw = offset
                    if not defensive and offset > 0 then
                        right = offset
                    elseif not defensive and offset < 0 then 
                        left = offset
                    end
                    self.taskrecord[v.idx].right = self.taskrecord[v.idx].right and self.taskrecord[v.idx].right or {}
                    self.taskrecord[v.idx].left = self.taskrecord[v.idx].left and self.taskrecord[v.idx].left or {}
                    if right ~= 0 and right > 0 then 
                        self.taskrecord[v.idx].right[right] = self.taskrecord[v.idx].right[right] and self.taskrecord[v.idx].right[right] + 1 or 1
                    end
                    if left ~= 0 and left < 0 then 
                        self.taskrecord[v.idx].left[left] = self.taskrecord[v.idx].left[left] and self.taskrecord[v.idx].left[left] + 1 or 1
                    end
                    self.status = "recording"
                    self.progress = math.floor(((4 - (v.endtime - globals.tickcount) / 64) / 4 * 100) + 0.5)

                    menu.antiaim.stealer.result:visibility(false)
                    menu.antiaim.stealer.progress:name("Progress: "..self.progress.. "%")
                    ::skiprecord::
                end 
            end
        end
    end
}
local mindmg = drag_system.register({menu.hidden.dmg_x, menu.hidden.dmg_y}, vector(20, 15), "Mindmg", function(self)
    if not menu.visuals.damage_indicator:get() then return end
    local mouse = ui.get_mouse_position()
    local lplr = entity.get_local_player()
    if not globals.is_connected or not globals.is_in_game or not lplr or not lplr:is_alive() then return end

    if ui.get_alpha() > 0.9 then   
        render.rect_outline(vector(self.position.x - 3, self.position.y - 1), vector(self.position.x + 20, self.position.y + 15), color(255,255,255,150), 1, 5)
        if mouse.x > self.position.x - 3 and mouse.x < self.position.x + 20 and mouse.y > self.position.y - 1 and mouse.y < self.position.y + 15 then
            if tools.is_right_clicking() then
                menu.hidden.dmg_x:reset()
                menu.hidden.dmg_y:reset()
                drag_system.on_config_load()
            end
            if not tools.is_left_clicking() then 
                render.text(2, vector(self.position.x - 35, self.position.y + 15), color(255,255,255,150), "", string.upper("MB2  to  reset  Position"))
            end
        end
    end

    local binds = ui.get_binds()

    local override_on = false
    local override_value = 0
    for k, v in pairs(binds) do
        if v.name == "Min. Damage" and v.active then
            override_on = true
            override_value = v.value
        end
    end

    local alpha = 0
    local font = menu.visuals.damage_indicator.font:get() == "pixel" and 2 or 1
    local should_animate = menu.visuals.damage_indicator.lerp:get()
    local visibility_mode = menu.visuals.damage_indicator.mods:get()
    local funny_lerp = tools.round(tools.animation:new("mindmg", override_on and override_value or references.mindmg:get(), 15))
    local non_funny_lerp --[[ :( ]] = override_on and override_value or references.mindmg:get()



    if visibility_mode == "transparent when off" then
        alpha = tools.animation:new("mindmg alpha", override_on and 220 or 100, 6)
    elseif visibility_mode == "always" then
        alpha = 220
    elseif visibility_mode == "override only" then
        alpha = override_on and 220 or 0
    end 

    render.text(font, vector(self.position.x, self.position.y), color(255, 255, 255, alpha), "l b", should_animate and funny_lerp or non_funny_lerp)
end)
local panel = drag_system.register({menu.hidden.panel_x, menu.hidden.panel_y}, vector(100, 43), "Panel", function(self)
    local desync = ""
    local lplr = entity.get_local_player()
    local mouse = ui.get_mouse_position()
    if not helpers or not helpers.state or not helpers.state.name then return end
    if not lplr then 
        return
    else
        desync = math.abs(lplr.m_flPoseParameter[11] * 120 - 60)
    end
    if not menu.visuals.panel:get() then return end
    local y = (not (stealer.status == "idle")) and 93 or 43
    if ui.get_alpha() > 0.9 then
        render.rect_outline(vector(self.position.x, self.position.y), vector(self.position.x + 100, self.position.y + y), color(255,255,255,255), 1, 5)
        if mouse.x > self.position.x and mouse.x < self.position.x + 100 and mouse.y > self.position.y and mouse.y < self.position.y + y then
            if tools.is_right_clicking() then
                menu.hidden.panel_x:reset()
                menu.hidden.panel_y:reset()
                drag_system.on_config_load()
            end
            if not tools.is_left_clicking() then 
                render.text(2, vector(self.position.x + 6, self.position.y + y + 2), color(255,255,255,150), "", string.upper("MB2  to  reset  Position"))
            end
        end
    end

    render.text(2,vector(self.position.x + 5, self.position.y), color(255,255,255,255), "", string.upper("User : \a" .. menu.visuals.panel.color:get():to_hex() .. lua.user))
    render.text(2,vector(self.position.x + 5, self.position.y + 10), color(255,255,255,255), "", string.upper("Version : \a" .. menu.visuals.panel.color:get():to_hex() .. lua.version))
    render.text(2,vector(self.position.x + 5, self.position.y + 20), color(255,255,255,255), "", string.upper("Condition : \a" .. menu.visuals.panel.color:get():to_hex() .. helpers.state.name))
    render.text(2,vector(self.position.x + 5, self.position.y + 30), color(255,255,255,255), "", string.upper("Desync : \a" .. menu.visuals.panel.color:get():to_hex() .. math.floor(desync) .. "°"))
    
    if stealer.status == "idle" then return end
    render.text(2,vector(self.position.x + 5, self.position.y + 50), color(255,255,255,255), "", string.upper("-- \a" .. menu.visuals.panel.color:get():to_hex().. "stealer \aFFFFFFFF --"))
    render.text(2,vector(self.position.x + 5, self.position.y + 80), color(255,255,255,255), "", string.upper("state: \a" .. menu.visuals.panel.color:get():to_hex() .. stealer.state))
    render.text(2,vector(self.position.x + 5, self.position.y + 60), color(255,255,255,255), "", string.upper("progress: \a" .. menu.visuals.panel.color:get():to_hex() .. tostring(math.floor(stealer.progress + 0.5)) .. "%"))
    render.text(2,vector(self.position.x + 5, self.position.y + 70), color(255,255,255,255), "", string.upper("status: \a" .. menu.visuals.panel.color:get():to_hex() .. stealer.status))
end)
local solusbinds = drag_system.register({menu.hidden.solus_x, menu.hidden.solus_y}, vector(150, 70), "keybinds", function(self)
    if not menu.visuals.solus:get() then return end
    local kbcl = menu.visuals.solus.color:get()

    local bindinfo = ui.get_binds()

    local is_connected = globals.is_connected and globals.is_in_game

    local bindamounts = 0
    local finalbinds = {}
    local maximum_offset = 0
    local height_offset = 20
    local height = 0
    local font = 1
    local shitbinddatabase = {}
    if (ui.get_alpha() > 0.5) then
        table.insert(bindinfo, {name = "Menu Toggled", active = true, mode = 3})
    end
    for k, v in pairs(bindinfo) do
        shitbinddatabase[v.name] = shitbinddatabase[v.name] or {}
        shitbinddatabase[v.name].alpha = tools.animation:new("kb_"..v.name.."_alpha", v.active and 1 or 0, 15)
        if (v.active) or (shitbinddatabase[v.name].alpha > 0.05) then
            local text_width = render.measure_text(font, "s", v.name).x
            local shitmode = key_modes[v.mode]
            local tmptable = {name = v.name, mode = shitmode, alpha = shitbinddatabase[v.name].alpha}
            table.insert(finalbinds, tmptable)
            if shitbinddatabase[v.name].alpha > 0.5 then
                maximum_offset = maximum_offset < text_width and text_width or maximum_offset
            end
        end
    end

    local alpha = tools.animation:new("kb_alpha", ((ui.get_alpha() > 0.5) or is_connected and (#finalbinds > 0)) and 1 or 0, 15)

    alpha = alpha < 0.01 and 0 or alpha
    alpha = alpha > 0.99 and 1 or alpha
    
    local width = 75 + maximum_offset
    if m_width == nil then
        m_width = w;
    end

    m_width = tools.animation:new("kb_width", width, 15)
    w = math.floor(m_width + 0.5)

    local mathematic = 18 * render.get_scale(2) - 18

    height = height + #finalbinds * (18 * render.get_scale(2))

    local selfpos = vector(self.position.x, self.position.y)

    render.rect(selfpos + vector(0, 2), selfpos + vector(w, 18 * render.get_scale(2)), color(17, 17, 17, math.floor(alpha * 40)))
    render.rect(selfpos, selfpos + vector(w, 2), color(kbcl.r, kbcl.g, kbcl.b, math.floor(alpha * 255)))
    render.text(font, vector(self.position.x - render.measure_text(font, "s", "keybinds").x / 2 + w / 2, self.position.y + 4), color(255, 255, 255, math.floor(alpha * 255)), "s", "keybinds")

    for i = 1, #finalbinds do
        render.text(font, vector(self.position.x, self.position.y + mathematic + height_offset), color(255, 255, 255, math.clamp(math.abs(math.floor(finalbinds[i].alpha * 255)), 0, 255)), "s", finalbinds[i].name)
        render.text(font, vector(self.position.x + w - render.measure_text(font, "s", finalbinds[i].mode).x - 8, self.position.y + mathematic + height_offset), color(255, 255, 255, math.clamp(math.abs(math.floor(finalbinds[i].alpha * 255)), 0, 255)), "s", "["..finalbinds[i].mode.."]")
        height_offset = height_offset + math.floor(13 * finalbinds[i].alpha + 0.5)
    end
end)


menu.modules.list:set_callback(function() module_handler:refresh() end)
menu.misc.logs.notify:set_callback(function() pui.colors.logs = logs.color logs:push_notify(pui.string("Hit\a[logs]  ivg \r(94%)  in \a[logs] head  \r(head)  for \a[logs] 124  \r(132)  damage"), false, entity.get_local_player()) end)
menu.visuals.aspect.r1:set_callback(function() menu.visuals.aspect.amount:set(178) end)
menu.visuals.aspect.r2:set_callback(function() menu.visuals.aspect.amount:set(125) end)
menu.visuals.aspect.r3:set_callback(function() menu.visuals.aspect.amount:set(133) end)
menu.config.save = groups.config:button("   \f<floppy-disk>   ",                        function() configsystem:save() end, true)
menu.config.load = groups.config:button("               load config               ",    function() configsystem:load() drag_system.on_config_load() end, true)
menu.config.delete = groups.config:button("   \aff0000ff\f<trash>   ",                  function() configsystem:delete() end, true)
menu.config.delete2 = groups.config:button("   \aff0000ff\f<trash>   ",                  function() configsystem:delete_confirm() end, false)
menu.config.export = groups.config:button("             export             ",      function() configsystem.export() end, true)
menu.config.import = groups.config:button("             import             ",      function() configsystem.import() drag_system.on_config_load() end, true)
menu.config.delete2:visibility(false)
menu.antiaim.stealer2:visibility(false)
menu.antiaim.stealselect:visibility(false)
menu.antiaim.stealer.confirm:visibility(false)
menu.antiaim.stealer.error:visibility(false)
menu.antiaim.stealer.result:visibility(false)
menu.antiaim.stealer.cancel:visibility(false)
menu.antiaim.stealer.progress:visibility(false)


menu.visuals.custom_ui:set_callback(function() cvar.cl_drawhud:int(menu.visuals.custom_ui:get() and 0 or 1) end)
menu.antiaim.stealer.refresh:set_callback(function() module_handler:update_plist() end)
menu.antiaim.stealer.steal:set_callback(function()
    if (menu.antiaim.stealer.plist:list()[menu.antiaim.stealer.plist:get()] == "Empty") or (menu.antiaim.stealer.plist:list() == {}) then
        print_meta("Refresh the playerlist")
        print_dev("Refresh the playerlist")
        return
    end
    for k, v in pairs(entity.get_players(true, true)) do
        --print(menu.antiaim.stealer.plist:list()[menu.antiaim.stealer.plist:get()])
        if menu.antiaim.stealer.plist:list()[menu.antiaim.stealer.plist:get()] == v:get_name() then
            stealer.idx = v:get_index()
            stealer.state = menu.antiaim.stealselect:get()
            stealer.tasks[#stealer.tasks + 1] = {state = stealer.state, idx = stealer.idx, starttime = globals.tickcount, endtime = globals.tickcount + 256}
            menu.antiaim.stealer.plist:disabled(true)
            menu.antiaim.stealer.steal:visibility(false)
            menu.antiaim.stealer.refresh:visibility(false)
            menu.antiaim.stealer.progress:visibility(true)
            menu.antiaim.stealer.cancel:visibility(true)
        end
    end
end)

menu.antiaim.stealer.cancel:set_callback(function()
    stealer.tasks = {}
    menu.antiaim.stealer.plist:disabled(false)
    menu.antiaim.stealer.steal:visibility(true)
    menu.antiaim.stealer.refresh:visibility(true)
    menu.antiaim.stealer.progress:visibility(false)
    menu.antiaim.stealer.result:visibility(false)
    menu.antiaim.stealer.confirm:visibility(false)
    menu.antiaim.stealer.cancel:visibility(false)
end)

menu.antiaim.stealer.confirm:set_callback(function()
    menu.antiaim.stealer.plist:disabled(false)
    menu.antiaim.stealer.steal:visibility(true)
    menu.antiaim.stealer.refresh:visibility(true)
    menu.antiaim.stealer.progress:visibility(false)
    menu.antiaim.stealer.result:visibility(false)
    menu.antiaim.stealer.confirm:visibility(false)
    menu.antiaim.stealer.cancel:visibility(false)
    -- print_meta(stealer.state_num)
    -- print_meta(stealer.final_left)
    -- print_meta(stealer.final_right)
    -- print_meta(menu.builder[stealer.state_num].default.yaw.left:get())
    -- print_meta(menu.builder[stealer.state_num].default.yaw.right:get())
    menu.builder[stealer.state_num].default.yaw.left:set(stealer.final_left)
    menu.builder[stealer.state_num].default.yaw.right:set(stealer.final_right)
end)

menu.antiaim.stealer1:set_callback(function()
    module_handler:hide_antiaim()
    menu.antiaim.stealer1:visibility(false)
    menu.antiaim.stealer2:visibility(true)
    menu.antiaim.select:visibility(false)
    menu.antiaim.stealselect:set(menu.antiaim.select:get())
    menu.antiaim.stealselect:visibility(true)
    menu.antiaim.stealer.plist:visibility(true)
    menu.antiaim.stealer.steal:visibility(true)
    menu.antiaim.stealer.refresh:visibility(true)
    menu.antiaim.stealer.progress:visibility(false)
    menu.antiaim.stealer.result:visibility(false)
    menu.antiaim.stealer.confirm:visibility(false)
    menu.antiaim.stealer.cancel:visibility(false)
end)

menu.antiaim.stealer2:set_callback(function()
    module_handler:show_antiaim()
    menu.antiaim.stealer2:visibility(false)
    menu.antiaim.stealer1:visibility(true)
    menu.antiaim.select:visibility(true)
    menu.antiaim.stealselect:set(menu.antiaim.select:get())
    menu.antiaim.stealselect:visibility(false)
    for k, v in pairs(menu.antiaim.stealer) do
        v:visibility(false)
    end
end)

menuhandler:setup()

-- local imsotired = {
--     " ",
--     "m",
--     "me",
--     "met",
--     "meta",
--     "metas",
--     "metase",
--     "metaset",
--     "metaset.",
--     "metaset.c",
--     "metaset.cc",
--     "metaset.cc r",
--     "metaset.cc re",
--     "metaset.cc rec",
--     "metaset.cc reco",
--     "metaset.cc recod",
--     "metaset.cc recode",
-- }

local imsotired = {
    " ",
    "m",
    "m e",
    "m e t",
    "m e t a",
    "m e t a s",
    "m e t a s e",
    "m e t a s e t",
    "m e t a s e t .",
    "m e t a s e t . c",
    "m e t a s e t . c c",
}

local eventhandler = {
    introstart = globals.realtime,
    introdone = false,
    update_sidebar = function(self)
        local elapsed_time = globals.realtime - self.introstart
        local colorik = menu.accent.color:get()
        if elapsed_time >= 4 then
            self.introdone = true
        end
        if not self.introdone then
            ui.sidebar("\a".. colorik:to_hex() .. imsotired[math.clamp(math.floor(to_ticks(elapsed_time / 2) / #imsotired), 1, #imsotired)], "circle-user")
        else
            ui.sidebar("\a".. colorik:to_hex() .. "m e t a s e t . c c", "circle-user")
        end
    end,
    setup = function(self)
        -- pui.setup(menu)
        menu.config.configlist:set_callback(function(self)
            local listofitemsfunny = menu.config.configlist:list()
            menu.config.configname:set(listofitemsfunny[self:get()] and listofitemsfunny[self:get()] or "")

            menu.config.delete2:visibility(false)
            utils.execute_after(0.3, function()
                menu.config.delete:visibility(true)
            end)
        end)
        events.render:set(function()
            self:update_sidebar()
            indicators:render_indicators()
            logs:handle()
            indicators:render_watermark()
            --logs:remove_notify()
            if not menuhandler.created then 
                configsystem:refresh()
            end
            if menuhandler.visuals then
                custom_ui:render_inventory()
                custom_ui:render_hp()
                solusbinds:update()
                panel:update()
                mindmg:update()
                handles.aspectratio()
                handles.viewmodel()
                hitmarker:draw()
                skeet:indicators()
                vel_warn:handle()
                def_warn:handle()
            end
            if menuhandler.misc then
                clantag:handle()
                handles.ping_spike()
                nade_fix.menu()
            end
            if menuhandler.helpers then
                ragebot:inbicators()
            end
            if ui.get_alpha() > 0 then
                menuhandler:antiaim_visibility()
            end
        end)
        events.post_update_clientside_animation:set(function(ctx)
            animbreakers.breaker(ctx)
        end)
        events.net_update_end:set(function()
            stealer:handle_tasks()
        end)
        events.createmove:set(function(cmd)
            helpers:updatestate(cmd)
            antiaim:run(cmd)
            if menuhandler.misc then
                handles:ladder(cmd)
                animbreakers.legs(cmd)
                avoid_collisions:handle(cmd) 
            end
            if menuhandler.helpers then
                ragebot:zeus_fix()
                ragebot:smart_baim()
                ragebot:smart_safe()
                ragebot:airstop()
                ragebot:revo_fix()
            end
            if ui.get_alpha() > 0.5 then 
                cmd.in_attack = false
                cmd.in_attack2 = false
            end
        end)
        events.player_death:set(function(e)
            trashtalk:killsay(e)
        end)
        events.grenade_thrown:set(function(e)
            trashtalk:blind(e)
            nade_fix.throwing(e)

        end)
        events.aim_fire:set(function(shot)
            antiaim.shot_choke = 2
            logs:shot(shot)
        end)
        events.aim_ack:set(function(...)
            if not menuhandler.misc then return end
            logs:result((...))
        end)
        events.round_prestart:set(function(...)
            utils.execute_after(1, function() -- account for due to death shots when shooting right as the round ends
                logs.db = {} -- clear memory every so often
            end)
        end)
        events.round_start:set(function()
            logs:remove_notify()
        end)
        events.player_connect_full:set(function(event)
            if entity.get(event.userid, true) == entity.get_local_player() then
                logs:remove_notify()
                antiaim:reset_builder()
            end
        end)
        events.player_spawned:set(function(...) -- kys
            hitmarker:spawn(...)
        end)
        events.player_hurt:set(function(...) -- kys
            hitmarker:hit(...)  
        end)
        events.localplayer_transparency:set(function(ctx)
            return transparency:model(ctx)
        end)
        events.shutdown:set(function()
            cvar.cl_drawhud:int(1)
        end)
        -- events.grenade_thrown:set(function()
        
        -- end)

        -- events.render:set(function()
        --     if ui.get_alpha() > 0 then
        --         visibilityHandler()
        --     end
        -- end)
    end,
}
eventhandler:setup()
configs:check()

utils.execute_after(0.1, drag_system.on_config_load)
utils.execute_after(0.1, function()
    menuhandler:update_modules()
end)
utils.execute_after(0.2, function()
    pui.setup(menu)
    for k, v in pairs(menu.antiaim.stealer) do
        v:visibility(false)
    end
end)

