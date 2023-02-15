set_project("%HERE%%FDIR%")
set_version("0.1.0")

add_rules("mode.debug", "mode.release")

set_defaultmode("debug")
set_policy("build.warning", true)

target("%FDIR%")
    add_files("src/*.cpp")

    set_languages("c++latest")
    set_warnings("everything")

    set_rundir("$(projectdir)")
    set_policy("build.optimization.lto", true)

    if is_mode("debug") then
        add_cxxflags("-fsanitize=address", "-fsanitize=undefined", "-fno-omit-frame-pointer")
        add_ldflags("-fsanitize=address", "-fsanitize=undefined")
    end
