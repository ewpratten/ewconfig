-- This is the 2022-05-21 version of "UnFish Lens" (https://obsproject.com/forum/resources/unfish-lens.1532/)
-- I use this script to correct for the distortion of my camera lenses.
-- Install by going to Tools -> Scripts and adding it.
-- Inspired by Corner Pin effect filter v1.1 by khaver

obs = obslua
bit = require("bit")

TEXT_FILTER_NAME = 'UnFish/Fish Lens'
TEXT_FISH_POWER = 'Strength'

SETTING_FISH_POWER = 'fish_power'

source_def = {}
source_def.id = 'filter-fish-lens'
source_def.type = obs.OBS_SOURCE_TYPE_FILTER
source_def.output_flags = bit.bor(obs.OBS_SOURCE_VIDEO)

function set_render_size(filter)
    target = obs.obs_filter_get_target(filter.context)

    local width, height
    if target == nil then
        width = 0
        height = 0
    else
        width = obs.obs_source_get_base_width(target)
        height = obs.obs_source_get_base_height(target)
    end

    filter.width = width
    filter.height = height
end

source_def.get_name = function()
    return TEXT_FILTER_NAME
end

source_def.create = function(settings, source)
    filter = {}
    filter.params = {}
    filter.context = source

    set_render_size(filter)

    obs.obs_enter_graphics()
    filter.effect = obs.gs_effect_create(shader, nil, nil)
    if filter.effect ~= nil then
        filter.params.fish_power = obs.gs_effect_get_param_by_name(filter.effect, 'fish_power')
        filter.params.texture_width = obs.gs_effect_get_param_by_name(filter.effect, 'texture_width')
        filter.params.texture_height = obs.gs_effect_get_param_by_name(filter.effect, 'texture_height')
    end
    obs.obs_leave_graphics()

    if filter.effect == nil then
        source_def.destroy(filter)
        return nil
    end

    source_def.update(filter, settings)
    return filter
end

source_def.destroy = function(filter)
    if filter.effect ~= nil then
        obs.obs_enter_graphics()
        obs.gs_effect_destroy(filter.effect)
        obs.obs_leave_graphics()
    end
end

source_def.get_width = function(filter)
    return filter.width
end

source_def.get_height = function(filter)
    return filter.height
end

source_def.update = function(filter, settings)
    filter.fish_power = obs.obs_data_get_double(settings, SETTING_FISH_POWER)

    set_render_size(filter)
end

source_def.video_render = function(filter, effect)
    if not obs.obs_source_process_filter_begin(filter.context, obs.GS_RGBA, obs.OBS_NO_DIRECT_RENDERING) then
        return
    end

    obs.gs_effect_set_float(filter.params.fish_power, filter.fish_power)
    obs.gs_effect_set_float(filter.params.texture_width, filter.width)
    obs.gs_effect_set_float(filter.params.texture_height, filter.height)

    obs.obs_source_process_filter_end(filter.context, filter.effect, filter.width, filter.height)
end

source_def.get_properties = function(settings)
    props = obs.obs_properties_create()

    obs.obs_properties_add_float_slider(props, SETTING_FISH_POWER, TEXT_FISH_POWER, -1.0, 2.0, 0.001)

    return props
end

source_def.get_defaults = function(settings)
    obs.obs_data_set_default_double(settings, SETTING_FISH_POWER, -0.18)
end

source_def.video_tick = function(filter, seconds)
    set_render_size(filter)
end

function script_description()
    return "Adds new video effect filter named '" .. TEXT_FILTER_NAME .. "' to imitate lens distortion"
end

function script_load(settings)
    obs.obs_register_source(source_def)
end

shader = [[
// Adaptation by Suslik V
// Based on the Sharpness shader of OBS Studio v27.0.0,
// And the https://github.com/Oncorporation/obs-shaderfilter/

uniform float4x4 ViewProj;
uniform texture2d image;

uniform float fish_power;
uniform float texture_width;
uniform float texture_height;

sampler_state def_sampler {
    Filter   = Linear;
    AddressU = Clamp;
    AddressV = Clamp;
};

struct VertData {
    float4 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

VertData VSDefault(VertData v_in)
{
    VertData vert_out;
    vert_out.pos = mul(float4(v_in.pos.xyz, 1.0), ViewProj);
    vert_out.uv  = v_in.uv;
    return vert_out;
}

float4 PSDrawBare(VertData v_in) : TARGET
{
    int center_x_percent = 50;
    int center_y_percent = 50;
    float power = fish_power;
    float2 uv_pixel_interval;
    uv_pixel_interval.x = 1.0 / texture_width;
    uv_pixel_interval.y = 1.0 / texture_height;
    float2 center_pos = float2(center_x_percent * .01, center_y_percent * .01);
    float2 uv = v_in.uv;
    if (power >= 0.0001) {
        float b = sqrt(dot(center_pos, center_pos));
        uv = center_pos  + normalize(v_in.uv - center_pos) * tan(distance(center_pos, v_in.uv) * power) * b / tan( b * power);
    } else if (power <= -0.0001) {
        float b;
        if (uv_pixel_interval.x < uv_pixel_interval.y){
            b = center_pos.x;
        } else {
            b = center_pos.y;
        }
        uv = center_pos  + normalize(v_in.uv - center_pos) * atan(distance(center_pos, v_in.uv) * -power * 10.0) * b / atan(-power * b * 10.0);
    }
    return image.Sample(def_sampler, uv);
}

technique Draw
{
    pass
    {
        vertex_shader = VSDefault(v_in);
        pixel_shader  = PSDrawBare(v_in);
    }
}
]]
