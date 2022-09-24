add_rules("mode.debug", "mode.release")

target("AsynctaskProjectInitProjectName")
    set_languages("c++latest")
    set_kind("binary")
    add_cxxflags("-Wall", "-Wextra")
    add_files("src/*.cpp")
