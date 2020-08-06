tag="v0.9.x"
tag="v1.0.7"
baseurl=file.path("https://raw.githubusercontent.com/tinyobjloader/tinyobjloader", tag)

for(s in c("tiny_obj_loader.cc", "tiny_obj_loader.h"))
  download.file(file.path(baseurl, s), destfile = file.path('src', s))
