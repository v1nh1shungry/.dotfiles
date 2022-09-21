add_rules("mode.debug", "mode.release")

target("AsynctaskProjectInitProjectName")
    set_languages("c++20")
    set_kind("binary")
    add_cxflags("-Wall", "-Wextra")
    add_files("src/*.cpp")
