using Jive
@useinside Main module test_waveflow_play

using Pkg
const waveflow_dir = normpath(Pkg.devdir(), "WaveFlow")
include(normpath(waveflow_dir, "src/WaveFlow.jl"))
using .WaveFlow

# from WaveFlow.jl/test/runtest.jl
const SND1_PATH = joinpath(waveflow_dir, "test", "assets", "snd1.ogg")
const SND2_PATH = joinpath(waveflow_dir, "test", "assets", "snd2.ogg")

using Test

function audio_seconds(source::AudioSource)::Float64
    sample_rate = source.sample_rate
    (nsamples, nchannels) = size(source.data)
    nsamples / sample_rate
end

@testset "test AudioSource" begin
    snd1 = load_audio(SND1_PATH)
    snd2 = load_audio(SND2_PATH)
    @test audio_seconds(snd1) ≈ 0.8496700073331703
    @test audio_seconds(snd2) ≈ 1.0
end

const relaxing_seconds = 0.8

@testset "WaveFlow" begin
    @testset "Audio loading" begin
        sys = WavesSystem()
        start!(sys)

        bus = create_bus()
        group = create_group()

        add_bus!(sys, bus)
        add_to_bus!(bus, group)
        snd1 = load_audio(SND1_PATH)

        @test snd1 isa AudioSource
        add_to_group!(group, snd1)
        snd1_seconds = audio_seconds(snd1)

        snd2 = load_audio(SND2_PATH)
        add_to_group!(group, snd2)
        snd2_seconds = audio_seconds(snd2)

        println("You should hear 2 quick sound playing at the same time.")
        turn_down_the_volume = 0.5
        snd1.volume = turn_down_the_volume
        snd2.volume = turn_down_the_volume
        play!(snd1)
        play!(snd2)

        sleep(maximum((snd1_seconds, snd2_seconds)) + relaxing_seconds)

        close!(sys)
    end
end

end # module test_waveflow_play
