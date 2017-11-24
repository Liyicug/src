module m8r

export sf_init

immutable File
     tag::String
     rsf::Ptr{UInt8}
end

function init()
	 argv = [basename(Base.source_path())]
	 append!(argv,ARGS)
	 ccall((:sf_init,"libdrsf"),Void,(Int32,Ptr{Ptr{UInt8}}),length(argv),argv)
end

function input(tag::String)
	 rsf = ccall((:sf_input,"libdrsf"),Ptr{UInt8},(Ptr{UInt8},),tag)
	 File(tag,rsf)
end

function output(tag::String)
	 rsf = ccall((:sf_output,"libdrsf"),Ptr{UInt8},(Ptr{UInt8},),tag)
	 File(tag,rsf)
end

function histint(file::File,name::String)
	 val = Cint[0]
	 ccall((:sf_histint,"libdrsf"),Bool,(Ptr{UInt8},Ptr{UInt8},Ptr{Cint}),file.rsf,name,val)
	 return val[]
end

function leftsize(file::File,dim::Int)
	 ccall((:sf_leftsize,"libdrsf"),Culonglong,(Ptr{UInt8},Cint),file.rsf,dim)
end

function getfloat(name::String)
	 val = Cfloat[0]
	 ccall((:sf_getfloat,"libdrsf"),Bool,(Ptr{UInt8},Ptr{Cfloat}),name,val)
	 return val[]
end

function floatread(arr::Array{Float32,1},size::Int32,file::File)
	 ccall((:sf_floatread,"libdrsf"),Void,(Ptr{Cfloat},Csize_t,Ptr{UInt8}),arr,size,file.rsf)
end

function floatwrite(arr::Array{Float32,1},size::Int32,file::File)
	 ccall((:sf_floatwrite,"libdrsf"),Void,(Ptr{Cfloat},Csize_t,Ptr{UInt8}),arr,size,file.rsf)
end

end
