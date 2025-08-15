# https://github.com/plemaster01/LeMasterTechYT

# beatMaker.zip
#   beatMaker/sounds 
#   clap.wav   crash.wav  hi hat.WAV kick.WAV   kit2       snare.WAV  tom.WAV

using Jive
@useinside Main module test_waveflow_LeMasterTechYT

using Pkg
const waveflow_dir = normpath(Pkg.devdir(), "WaveFlow")
include(normpath(waveflow_dir, "src/WaveFlow.jl"))
using .WaveFlow

const clap_path = joinpath(@__DIR__, "beatMaker", "sounds", "clap.wav")
const crash_path = joinpath(@__DIR__, "beatMaker", "sounds", "crash.wav")
const hi_hat_path = joinpath(@__DIR__, "beatMaker", "sounds", "hi hat.wav")
const kick_path = joinpath(@__DIR__, "beatMaker", "sounds", "kick.wav")
const snare_path = joinpath(@__DIR__, "beatMaker", "sounds", "snare.wav")
const tom_path = joinpath(@__DIR__, "beatMaker", "sounds", "tom.wav")

using Test

function audio_seconds(source::AudioSource)::Float64
    sample_rate = source.sample_rate
    (nsamples, nchannels) = size(source.data)
    nsamples / sample_rate
end

const relaxing_seconds = 1.0

@testset "LeMasterTechYT" begin
    @testset "Audio loading" begin
        sys = WavesSystem()
        start!(sys)

        bus = create_bus()
        group = create_group()

        add_bus!(sys, bus)
        add_to_bus!(bus, group)

        clap = load_audio(clap_path)
        crash = load_audio(crash_path)
        hi_hat = load_audio(hi_hat_path)
        kick = load_audio(kick_path)
        snare = load_audio(snare_path)
        tom = load_audio(tom_path)

        add_to_group!(group, clap)
        add_to_group!(group, crash)
        add_to_group!(group, hi_hat)
        add_to_group!(group, kick)
        add_to_group!(group, snare)
        add_to_group!(group, tom)

        clap_seconds = audio_seconds(clap)
        crash_seconds = audio_seconds(crash)
        hi_hat_seconds = audio_seconds(hi_hat)
        kick_seconds = audio_seconds(kick)
        snare_seconds = audio_seconds(snare)
        tom_seconds = audio_seconds(tom)

        play!(tom)
        sleep(tom_seconds)

        play!(clap)
		sleep(clap_seconds)

        sleep(relaxing_seconds)

        close!(sys)
    end
end

end # module test_waveflow_LeMasterTechYT
